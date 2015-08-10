// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "OHHTTPStubs.h"
#import "UPPBasicService.h"

#import <OCMock/OCMock.h>

static NSString * const UPPTestFakeURL = @"http://127.0.0.1:54321/Event";

SpecBegin(UPPEventSubscriptionManager)

describe(@"UPPEventSubscriptionManager", ^{

    __block id mockService;
    __block UPPEventSubscriptionManager *sut;

    beforeEach(^{
        sut = [UPPEventSubscriptionManager new];
        mockService = OCMClassMock([UPPBasicService class]);
        NSURL *url = [NSURL URLWithString:UPPTestFakeURL];
        OCMStub([mockService eventSubscriptionURL]).andReturn(url);

        OHHTTPStubsTestBlock testBlock = ^BOOL(NSURLRequest *request) {

            if (![request.HTTPMethod isEqualToString:@"SUBSCRIBE"]) {
                return NO;
            }

            NSDictionary *headers = request.allHTTPHeaderFields;
            if (![headers[@"HOST"] isEqualToString:UPPTestFakeURL] ||
                ![headers[@"CALLBACK"] isEqualToString:[[sut callbackURL] absoluteString]] ||
                ![headers[@"NT"] isEqualToString:@"upnp:event"] ||
                ![headers[@"TIMEOUT"] isEqualToString:@"Second-1800"]) {
                return NO;
            }

            return [request.URL isEqual:[NSURL URLWithString:UPPTestFakeURL]];
        };

        OHHTTPStubsResponseBlock responseBlock = ^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSData *data = [NSData data];

            /*
             HTTP/1.1 200 OK
             DATE: Fri, 01 Jan 2010 02:23:31 GMT
             SERVER: IPI/1.0 UPnP/1.0 DLNADOC/1.50
             SID: uuid:13eab030-7a75-1cef-8ef7-be182c857ac5
             TIMEOUT: Second-300
             CONTENT-LENGTH: 0
             CONNECTION: Keep-Alive
             */
            NSDictionary *headers = @{
                                      @"DATE": @"Fri, 01 Jan 2015 13:00:01 GMT",
                                      @"SERVER": @"IPI/1.0 UPnP/1.0 DLNADOC/1.50",
                                      @"SID": @"uuid:12345678",
                                      @"TIMEOUT": @"Second-300",
                                      @"CONTENT-LENGTH": @"0",
                                      @"CONNECTION": @"Keep-Alive"
                                      };
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:headers];
        };

        [OHHTTPStubs stubRequestsPassingTest:testBlock withStubResponse:responseBlock];
    });

    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });

    describe(@"when subscribing to service events", ^{
        it(@"should send a request to the services event subscription URL", ^{
            waitUntil(^(DoneCallback done) {
                [sut subscribeObject:nil toService:mockService completion:^(BOOL success) {
                    expect(success).to.beTruthy();
                    done();
                }];
            });
        });

        xit(@"should create a subscription object", ^{
        });

        xit(@"should reuse a subscription object", ^{
        });
    });

    describe(@"when resubscribing to service events", ^{
        xit(@"should send a request to the services event subscription URL", ^{
        });

        xit(@"should update a subscription object", ^{
        });
    });

    describe(@"when unsubscribing to service events", ^{
        xit(@"should send a request to the services event subscription URL", ^{
        });

        xit(@"should destroy a subscription object", ^{
        });
    });

    describe(@"when recieving an event", ^{
        xit(@"should parse the XML", ^{
        });

        xit(@"should pass the event object to the subscription object", ^{
        });
    });
});

SpecEnd
