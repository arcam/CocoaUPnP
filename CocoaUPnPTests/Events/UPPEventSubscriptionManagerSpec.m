// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "UPPBasicService.h"

#import <OCMock/OCMock.h>
#import "UPPEventSubscription.h"
#import "UPPEventServer.h"

/*
 NOTE: This spec shouldn't know about the existance of activeSubscriptions, but
     knowing about it will make testing much, much easier further down the line.
     I don't personally see this implementation changing, so this is one of
     those times where convenience greatly outweighs doing things 100% by the
     book.
 */
@interface UPPEventSubscriptionManager ()
@property (strong, nonatomic) NSMutableArray *activeSubscriptions;
@end

static NSString * const UPPTestFakeURL = @"http://127.0.0.1:54321/Event";
static NSString * const UPPTestFakeCallbackURL = @"http://10.0.0.1:54321/Event";
static NSString * const UPPTestSID = @"uuid:12345678";
static NSString * const UPPTestTimeout = @"Second-1800";

NSDate *(^ExpectedExpiryDate)(void);
NSURLResponse *(^SuccessfulResponse)(void);
NSURLResponse *(^UnsuccessfulResponse)(void);
void StubDataTaskAndReturnResponse(id session, NSURLResponse *response);

SpecBegin(UPPEventSubscriptionManager)

describe(@"UPPEventSubscriptionManager", ^{

    __block UPPEventSubscriptionManager *sut;
    __block id mockSession;
    __block id mockService;
    __block id mockObserver;
    __block id mockEventServer;
    __block UPPEventSubscription *exampleSubscription;

    beforeEach(^{
        mockSession = OCMClassMock([NSURLSession class]);
        sut = [[UPPEventSubscriptionManager alloc] initWithSession:mockSession];
        expect(sut).toNot.beNil();

        mockService = OCMClassMock([UPPBasicService class]);
        NSURL *url = [NSURL URLWithString:UPPTestFakeURL];
        OCMStub([mockService eventSubscriptionURL]).andReturn(url);

        mockEventServer = OCMClassMock([UPPEventServer class]);
        NSURL *callbackURL = [NSURL URLWithString:UPPTestFakeCallbackURL];
        OCMStub([mockEventServer eventServerCallbackURL]).andReturn(callbackURL);
        sut.eventServer = mockEventServer;

        mockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));

        exampleSubscription = [UPPEventSubscription subscriptionWithID:UPPTestSID
                                                            expiryDate:nil
                                                  eventSubscriptionURL:url];
    });

    it(@"should conform to UPPEventServerDelegate", ^{
        expect(sut).to.conformTo(@protocol(UPPEventServerDelegate));
    });

    describe(@"shared instance", ^{
        it(@"should return an instance", ^{
            expect([UPPEventSubscriptionManager sharedManager]).toNot.beNil();
        });
        
        it(@"should return the same instance twice", ^{
            UPPEventSubscriptionManager *manager = [UPPEventSubscriptionManager sharedManager];
            expect([UPPEventSubscriptionManager sharedManager]).to.beIdenticalTo(manager);
        });
        
        it(@"should be separate from unique instance", ^{
            expect(sut).toNot.equal([UPPEventSubscriptionManager sharedManager]);
        });
    });

    describe(@"when subscribing to service events", ^{
        it(@"should send a SUBSCRIBE request to the service's event subscription URL", ^{
            OCMExpect([mockSession dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(NSURLRequest *request) {
                return [[request URL] isEqual:[NSURL URLWithString:UPPTestFakeURL]] &&
                       [[request HTTPMethod] isEqualToString:@"SUBSCRIBE"];
            }] completionHandler:[OCMArg any]]);

            [sut subscribeObserver:nil toService:mockService completion:nil];

            OCMVerifyAll(mockSession);
        });

        it(@"should send the required headers in the subscription request", ^{
            OCMExpect(([mockSession dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(NSURLRequest *request) {
                NSDictionary *headers = request.allHTTPHeaderFields;
                NSString *host = @"127.0.0.1:54321";
                expect(headers[@"HOST"]).to.equal(host);
                NSString *callback = [NSString stringWithFormat:@"<%@>", UPPTestFakeCallbackURL];
                expect(headers[@"CALLBACK"]).to.equal(callback);
                return [headers[@"HOST"] isEqualToString:host] &&
                       [headers[@"CALLBACK"] isEqualToString:callback] &&
                       [headers[@"NT"] isEqualToString:@"upnp:event"] &&
                       [headers[@"TIMEOUT"] isEqualToString:@"Second-1800"];
            }] completionHandler:[OCMArg any]]));

            [sut subscribeObserver:nil toService:mockService completion:nil];

            OCMVerifyAll(mockSession);
        });

        it(@"should create a subscription object when successful", ^{
            // Assert no subscriptions first
            NSMutableArray *subscriptions = [sut activeSubscriptions];
            expect(subscriptions.count).to.equal(0);

            // Stub out data task and return canned response
            StubDataTaskAndReturnResponse(mockSession, SuccessfulResponse());
            [sut subscribeObserver:mockObserver toService:mockService completion:nil];

            // Check assertions
            expect(subscriptions.count).to.equal(1);
            UPPEventSubscription *subscription = [subscriptions firstObject];
            expect(subscription.subscriptionID).to.equal(UPPTestSID);

            NSDate *expectedExpiry = ExpectedExpiryDate();
            NSDate *expiry = subscription.expiryDate;
            expect(expiry).toNot.beNil();
            NSTimeInterval interval = [expectedExpiry timeIntervalSinceDate:expiry];
            expect(interval).to.beLessThan(0.01);

            expect(subscription.eventSubscriptionURL).to.equal([NSURL URLWithString:UPPTestFakeURL]);
            expect([subscription eventObservers]).to.contain(mockObserver);
        });

        it(@"should not create a subscription object when unsuccessful", ^{
            expect([sut activeSubscriptions].count).to.equal(0);

            StubDataTaskAndReturnResponse(mockSession, UnsuccessfulResponse());
            [sut subscribeObserver:mockObserver toService:mockService completion:nil];

            expect([sut activeSubscriptions].count).to.equal(0);
        });

        it(@"should start up an event server if stopped", ^{
            OCMExpect([mockEventServer isRunning]).andReturn(NO);
            OCMExpect([mockEventServer startServer]);
            OCMExpect([mockEventServer setEventDelegate:sut]);

            [sut subscribeObserver:mockObserver toService:mockService completion:nil];

            OCMVerifyAll(mockEventServer);
        });

        it(@"should not start up an event server if already running", ^{
            OCMExpect([mockEventServer isRunning]).andReturn(YES);
            [[mockEventServer reject] startServer];
            [[mockEventServer reject] setEventDelegate:[OCMArg any]];

            [sut subscribeObserver:mockObserver toService:mockService completion:nil];

            OCMVerifyAll(mockEventServer);
        });

        it(@"should shut down the event server if no subscribers and subscription was unsuccessful", ^{
            expect([sut activeSubscriptions].count).to.equal(0);
            OCMExpect([mockEventServer stopServer]);

            StubDataTaskAndReturnResponse(mockSession, UnsuccessfulResponse());
            [sut subscribeObserver:mockObserver toService:mockService completion:nil];

            OCMVerifyAll(mockEventServer);
        });

        it(@"should not shut down the event server if there are subscribers and subscription was unsuccessful", ^{
            NSURL *url = [NSURL URLWithString:@"http://123.123.123.123"];
            UPPEventSubscription *anotherSubscription = [UPPEventSubscription subscriptionWithID:@"aDifferentSID" expiryDate:[NSDate distantFuture] eventSubscriptionURL:url];
            [sut.activeSubscriptions addObject:anotherSubscription];
            expect([sut activeSubscriptions].count).to.equal(1);
            [[mockEventServer reject] stopServer];

            StubDataTaskAndReturnResponse(mockSession, UnsuccessfulResponse());
            [sut subscribeObserver:mockObserver toService:mockService completion:nil];

            OCMVerifyAll(mockEventServer);
        });

        describe(@"when subscription already exists", ^{
            beforeEach(^{
                [exampleSubscription addEventObserver:mockObserver];
                [sut.activeSubscriptions addObject:exampleSubscription];
                expect(sut.activeSubscriptions.count).to.equal(1);
            });

            it(@"should not make a network call", ^{
                [[mockSession reject] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];

                [sut subscribeObserver:mockObserver toService:mockService completion:nil];

                expect(sut.activeSubscriptions.count).to.equal(1);
                expect([sut.activeSubscriptions lastObject]).to.beIdenticalTo(exampleSubscription);
                OCMVerifyAll(mockSession);
            });

            it(@"should add a new observer", ^{
                id anotherMockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));

                [sut subscribeObserver:anotherMockObserver toService:mockService completion:nil];

                expect(sut.activeSubscriptions.count).to.equal(1);
                expect(exampleSubscription.eventObservers.count).to.equal(2);
                expect([exampleSubscription.eventObservers lastObject]).to.equal(anotherMockObserver);
            });

            it(@"should not add the same observer", ^{
                [sut subscribeObserver:mockObserver toService:mockService completion:nil];
                UPPEventSubscription *addedSubscription = [sut.activeSubscriptions lastObject];
                expect(addedSubscription.eventObservers.count).to.equal(1);

                [sut subscribeObserver:mockObserver toService:mockService completion:nil];
                expect(addedSubscription.eventObservers.count).to.equal(1);
            });
        });
    });

    describe(@"when resubscribing to service events", ^{
        it(@"should send a SUBSCRIBE request to the services event subscription URL", ^{
            OCMExpect([mockSession dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(NSURLRequest *request) {
                return [[request URL] isEqual:[NSURL URLWithString:UPPTestFakeURL]] &&
                [[request HTTPMethod] isEqualToString:@"SUBSCRIBE"];
            }] completionHandler:[OCMArg any]]);

            [sut renewSubscription:exampleSubscription completion:nil];

            OCMVerifyAll(mockSession);
        });

        it(@"should send all required headers in the subscription request", ^{
            OCMExpect([mockSession dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(NSURLRequest *request) {
                NSDictionary *headers = request.allHTTPHeaderFields;
                return [headers[@"HOST"] isEqualToString:UPPTestFakeURL] &&
                       [headers[@"SID"] isEqualToString:UPPTestSID] &&
                       [headers[@"TIMEOUT"] isEqualToString:@"Second-1800"];
            }] completionHandler:[OCMArg any]]);

            [sut renewSubscription:exampleSubscription completion:nil];

            OCMVerifyAll(mockSession);
        });

        it(@"should pass back new header information", ^{
            UPPEventSubscription *existingSubscription;
            existingSubscription = [UPPEventSubscription
                                    subscriptionWithID:UPPTestSID
                                    expiryDate:[NSDate distantPast]
                                    eventSubscriptionURL:[NSURL URLWithString:UPPTestFakeURL]];
            [sut.activeSubscriptions addObject:existingSubscription];
            expect(sut.activeSubscriptions.count).to.equal(1);

            StubDataTaskAndReturnResponse(mockSession, SuccessfulResponse());

            [sut renewSubscription:existingSubscription completion:^(NSString *subscriptionID, NSDate *expiryDate, NSError *error) {
                expect(subscriptionID).to.equal(existingSubscription.subscriptionID);
                expect(expiryDate).toNot.equal([NSDate distantPast]);
                expect(error).to.beNil();
            }];
        });
    });

    describe(@"when unsubscribing from service events", ^{
        beforeEach(^{
            NSDate *expiry = [NSDate dateWithTimeIntervalSinceNow:30];
            NSURL *url = [NSURL URLWithString:UPPTestFakeURL];

            exampleSubscription = [UPPEventSubscription subscriptionWithID:UPPTestSID
                                                         expiryDate:expiry
                                               eventSubscriptionURL:url];
            [exampleSubscription addEventObserver:mockObserver];
            [sut.activeSubscriptions addObject:exampleSubscription];

            expect([exampleSubscription eventObservers]).to.contain(mockObserver);
            expect(sut.activeSubscriptions).to.contain(exampleSubscription);
        });

        it(@"should remove the observer from the subscription", ^{
            [sut removeObserver:mockObserver fromService:mockService completion:nil];

            expect([exampleSubscription eventObservers]).toNot.contain(mockObserver);
        });

        it(@"should send UNSUBSCRIBE call if there are no more observers", ^{
            expect([exampleSubscription eventObservers].count).to.equal(1);

            OCMExpect([mockSession dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(NSURLRequest *request) {
                return [[request HTTPMethod] isEqualToString:@"UNSUBSCRIBE"] &&
                       [[request URL] isEqual:[NSURL URLWithString:UPPTestFakeURL]];
            }] completionHandler:[OCMArg any]]);

            [sut removeObserver:mockObserver fromService:mockService completion:nil];

            expect([exampleSubscription eventObservers]).toNot.contain(mockObserver);
            OCMVerifyAll(mockSession);
        });

        it(@"should send required headers if there are no more observers", ^{
            expect([exampleSubscription eventObservers].count).to.equal(1);

            OCMExpect([mockSession dataTaskWithRequest:[OCMArg checkWithBlock:^BOOL(NSURLRequest *request) {
                NSDictionary *headers = request.allHTTPHeaderFields;
                return [headers[@"HOST"] isEqualToString:UPPTestFakeURL] &&
                       [headers[@"SID"] isEqualToString:UPPTestSID];
            }] completionHandler:[OCMArg any]]);

            [sut removeObserver:mockObserver fromService:mockService completion:nil];

            expect([exampleSubscription eventObservers]).toNot.contain(mockObserver);
            OCMVerifyAll(mockSession);
        });

        it(@"should not send an unsubscribe call if there are still observers", ^{
            id anotherMockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
            [exampleSubscription addEventObserver:anotherMockObserver];
            expect([exampleSubscription eventObservers].count).to.equal(2);
            [[mockSession reject] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];

            [sut removeObserver:mockObserver fromService:mockService completion:nil];

            expect([exampleSubscription eventObservers]).toNot.contain(mockObserver);
            expect([exampleSubscription eventObservers]).to.contain(anotherMockObserver);
            OCMVerifyAll(mockSession);
        });

        it(@"should shut down event server if no more subscriptions exist", ^{
            expect(sut.activeSubscriptions.count).to.equal(1);
            OCMExpect([mockEventServer stopServer]);

            StubDataTaskAndReturnResponse(mockSession, SuccessfulResponse());
            [sut removeObserver:mockObserver fromService:mockService completion:nil];

            OCMVerifyAll(mockEventServer);
        });

        it(@"should not shut down event server if more subscriptions exist", ^{
            NSURL *url = [NSURL URLWithString:@"http://123.123.123.123"];
            UPPEventSubscription *anotherSubscripton = [UPPEventSubscription subscriptionWithID:nil expiryDate:nil eventSubscriptionURL:url];
            [sut.activeSubscriptions addObject:anotherSubscripton];
            expect(sut.activeSubscriptions.count).to.equal(2);
            [[mockEventServer reject] stopServer];

            StubDataTaskAndReturnResponse(mockSession, SuccessfulResponse());
            [sut removeObserver:mockObserver fromService:mockService completion:nil];

            OCMVerifyAll(mockEventServer);
        });
    });

    describe(@"when recieving an event", ^{

        __block id mockSubscription;

        beforeEach(^{
            mockSubscription = OCMClassMock([UPPEventSubscription class]);
            OCMStub([mockSubscription valueForKey:@"subscriptionID"]).andReturn(UPPTestSID);
            [sut.activeSubscriptions addObject:mockSubscription];
        });

        it(@"should pass the event object to the subscription object", ^{
            NSDictionary *event = @{ UPPEventServerSIDKey: UPPTestSID };
            OCMExpect([mockSubscription informObserversOfEvent:event]);

            [sut eventReceived:event];

            OCMVerifyAll(mockSubscription);
        });
    });
});

SpecEnd

#pragma mark - Helper Blocks

NSDate *(^ExpectedExpiryDate)(void) = ^NSDate *(void) {
    return [NSDate dateWithTimeIntervalSinceNow:300];
};

NSURLResponse *(^SuccessfulResponse)(void) = ^NSURLResponse *(void) {
    return [[NSHTTPURLResponse alloc] initWithURL:nil
                                       statusCode:200
                                      HTTPVersion:nil
                                     headerFields:@{ @"SID": UPPTestSID,
                                                     @"TIMEOUT": @"Second-1800" }];
};

NSURLResponse *(^UnsuccessfulResponse)(void) = ^NSURLResponse *(void) {
    return [[NSHTTPURLResponse alloc] initWithURL:nil
                                       statusCode:500
                                      HTTPVersion:nil
                                     headerFields:nil];
};

void StubDataTaskAndReturnResponse(id session, NSURLResponse *response)
{
    [[[session stub] andDo:^(NSInvocation *invocation) {
        void (^successBlock)(NSData *, NSURLResponse *, NSError *) = nil;
        [invocation getArgument:&successBlock atIndex:3];
        successBlock(nil, response, nil);

    }] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
}