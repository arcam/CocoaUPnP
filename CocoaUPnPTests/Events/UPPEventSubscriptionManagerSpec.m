// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "OHHTTPStubs.h"
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
static NSString * const UPPTestSID = @"uuid:12345678";
static NSString * const UPPTestTimeout = @"Second-1800";

NSDate *(^ExpectedExpiryDate)(void) = ^NSDate *(void) {
    return [NSDate dateWithTimeIntervalSinceNow:300];
};

SpecBegin(UPPEventSubscriptionManager)

describe(@"UPPEventSubscriptionManager", ^{

    __block id mockService;
    __block id mockObserver;
    __block UPPEventSubscriptionManager *sut;
    __block OHHTTPStubsResponseBlock responseBlock;
    __block OHHTTPStubsTestBlock testBlock;
    __block UPPEventSubscription *subscription;

    beforeEach(^{
        sut = [UPPEventSubscriptionManager new];
        mockService = OCMClassMock([UPPBasicService class]);
        mockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
        NSURL *url = [NSURL URLWithString:UPPTestFakeURL];
        OCMStub([mockService eventSubscriptionURL]).andReturn(url);

        subscription = [UPPEventSubscription subscriptionWithID:UPPTestSID
                                                     expiryDate:nil
                                           eventSubscriptionURL:[NSURL URLWithString:UPPTestFakeURL]];

        responseBlock = ^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSDictionary *headers = @{
                                      @"DATE": @"Fri, 01 Jan 2015 13:00:01 GMT",
                                      @"SERVER": @"IPI/1.0 UPnP/1.0 DLNADOC/1.50",
                                      @"SID": UPPTestSID,
                                      @"TIMEOUT": @"Second-300",
                                      @"CONTENT-LENGTH": @"0",
                                      @"CONNECTION": @"Keep-Alive"
                                      };
            return [OHHTTPStubsResponse responseWithData:[NSData data]
                                              statusCode:200
                                                 headers:headers];
        };
    });

    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });

    it(@"should conform to UPPEventServerDelegate", ^{
        expect(sut).to.conformTo(@protocol(UPPEventServerDelegate));
    });

    describe(@"when subscribing to service events", ^{

        beforeEach(^{
            testBlock = ^BOOL(NSURLRequest *request) {

                if (![request.HTTPMethod isEqualToString:@"SUBSCRIBE"]) {
                    return NO;
                }

                NSDictionary *headers = request.allHTTPHeaderFields;
                if (![headers[@"HOST"] isEqualToString:UPPTestFakeURL] ||
                    ![headers[@"CALLBACK"] isEqualToString:[[sut callbackURL] absoluteString]] ||
                    ![headers[@"NT"] isEqualToString:@"upnp:event"] ||
                    ![headers[@"TIMEOUT"] isEqualToString:UPPTestTimeout]) {
                    return NO;
                }

                return [request.URL isEqual:[NSURL URLWithString:UPPTestFakeURL]];
            };

            [OHHTTPStubs stubRequestsPassingTest:testBlock withStubResponse:responseBlock];
        });

        it(@"should send a request to the services event subscription URL", ^{
            waitUntil(^(DoneCallback done) {
                [sut subscribeObserver:nil toService:mockService completion:^(BOOL success) {
                    expect(success).to.beTruthy();
                    done();
                }];
            });
        });

        it(@"should create a subscription object", ^{
            NSMutableArray *subscriptions = [sut activeSubscriptions];
            expect(subscriptions.count).to.equal(0);

            waitUntil(^(DoneCallback done) {
                [sut subscribeObserver:mockObserver toService:mockService completion:^(BOOL success) {
                    expect(success).to.beTruthy();

                    expect(subscriptions.count).to.equal(1);
                    UPPEventSubscription *subscription = [subscriptions firstObject];
                    expect(subscription.subscriptionID).to.equal(UPPTestSID);

                    NSDate *expectedExpiry = ExpectedExpiryDate();
                    NSDate *expiry = subscription.expiryDate;
                    NSTimeInterval interval = [expectedExpiry timeIntervalSinceDate:expiry];
                    expect(interval).to.beLessThan(0.01);

                    expect(subscription.eventSubscriptionURL).to.equal([NSURL URLWithString:UPPTestFakeURL]);
                    expect([subscription eventObservers]).to.contain(mockObserver);

                    done();
                }];
            });
        });

        describe(@"when subscription already exists", ^{

            __block UPPEventSubscription *subscription;

            beforeEach(^{
                NSDate *date = [NSDate date];
                subscription = [UPPEventSubscription subscriptionWithID:UPPTestSID
                                                             expiryDate:date
                                                   eventSubscriptionURL:[NSURL URLWithString:UPPTestFakeURL]];
                [subscription addEventObserver:mockObserver];
                [sut.activeSubscriptions addObject:subscription];

                expect(sut.activeSubscriptions.count).to.equal(1);
            });

            it(@"should exit early if subscription exists", ^{
                waitUntil(^(DoneCallback done) {
                    [sut subscribeObserver:mockObserver toService:mockService completion:^(BOOL success) {

                        expect(sut.activeSubscriptions.count).to.equal(1);
                        expect([sut.activeSubscriptions lastObject]).to.beIdenticalTo(subscription);
                        done();
                    }];
                });
            });

            it(@"should add new observer if not included in subscription", ^{
                id anotherMockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
                waitUntil(^(DoneCallback done) {
                    [sut subscribeObserver:anotherMockObserver toService:mockService completion:^(BOOL success) {

                        expect(sut.activeSubscriptions.count).to.equal(1);
                        expect(subscription.eventObservers.count).to.equal(2);
                        done();
                    }];
                });
            });
        });
    });

    describe(@"when resubscribing to service events", ^{
        beforeEach(^{
            testBlock = ^BOOL(NSURLRequest *request) {

                if (![request.HTTPMethod isEqualToString:@"SUBSCRIBE"]) {
                    return NO;
                }

                NSDictionary *headers = request.allHTTPHeaderFields;
                if (![headers[@"HOST"] isEqualToString:UPPTestFakeURL] ||
                    ![headers[@"SID"] isEqualToString:UPPTestSID] ||
                    ![headers[@"TIMEOUT"] isEqualToString:UPPTestTimeout]) {
                    return NO;
                }

                return [request.URL isEqual:[NSURL URLWithString:UPPTestFakeURL]];
            };

            [OHHTTPStubs stubRequestsPassingTest:testBlock withStubResponse:responseBlock];
        });

        it(@"should send a request to the services event subscription URL", ^{
            waitUntil(^(DoneCallback done) {
                [sut renewSubscription:subscription completion:^(NSString *subscriptionID, NSDate *expiryDate, NSError *error) {
                    expect(subscriptionID).to.equal(UPPTestSID);
                    NSDate *expectedExpiry = ExpectedExpiryDate();
                    NSTimeInterval interval = [expectedExpiry timeIntervalSinceDate:expiryDate];
                    expect(interval).to.beLessThan(0.01);
                    done();
                }];
            });
        });

        it(@"should update a subscription object", ^{
            UPPEventSubscription *existingSubscription;
            existingSubscription = [UPPEventSubscription
                                    subscriptionWithID:UPPTestSID
                                    expiryDate:[NSDate distantPast]
                                    eventSubscriptionURL:[NSURL URLWithString:UPPTestFakeURL]];
            [sut.activeSubscriptions addObject:existingSubscription];
            expect(sut.activeSubscriptions.count).to.equal(1);

            waitUntil(^(DoneCallback done) {
                [sut renewSubscription:existingSubscription completion:^(NSString *subscriptionID, NSDate *expiryDate, NSError *error) {
                    expect(subscriptionID).to.equal(existingSubscription.subscriptionID);
                    expect(expiryDate).toNot.equal([NSDate distantPast]);
                    expect(error).to.beNil();
                    done();
                }];
            });
        });
    });

    describe(@"when unsubscribing to service events", ^{
        beforeEach(^{
            testBlock = ^BOOL(NSURLRequest *request) {

                if (![request.HTTPMethod isEqualToString:@"UNSUBSCRIBE"]) {
                    return NO;
                }

                NSDictionary *headers = request.allHTTPHeaderFields;
                if (![headers[@"HOST"] isEqualToString:UPPTestFakeURL] ||
                    ![headers[@"SID"] isEqualToString:UPPTestSID]) {
                    return NO;
                }

                return [request.URL isEqual:[NSURL URLWithString:UPPTestFakeURL]];
            };

            [OHHTTPStubs stubRequestsPassingTest:testBlock withStubResponse:responseBlock];
        });

        it(@"should send a request to the services event subscription URL", ^{
            waitUntil(^(DoneCallback done) {
                [sut unsubscribe:subscription completion:^(BOOL success) {
                    expect(success).to.beTruthy();
                    done();
                }];
            });
        });

        it(@"should destroy a subscription object", ^{
            UPPEventSubscription *existingSubscription;
            existingSubscription = [UPPEventSubscription
                                    subscriptionWithID:UPPTestSID
                                    expiryDate:[NSDate distantPast]
                                    eventSubscriptionURL:[NSURL URLWithString:UPPTestFakeURL]];
            [sut.activeSubscriptions addObject:existingSubscription];
            expect(sut.activeSubscriptions.count).to.equal(1);
            waitUntil(^(DoneCallback done) {
                [sut unsubscribe:existingSubscription completion:^(BOOL success) {
                    expect(sut.activeSubscriptions).toNot.contain(existingSubscription);
                    done();
                }];
            });
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
