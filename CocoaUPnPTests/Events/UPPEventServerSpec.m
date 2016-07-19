// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <OCMock/OCMock.h>
#import <CocoaUPnP/CocoaUPnP.h>
#import <GCDWebServers/GCDWebServers.h>
#import "TestHelpers.h"
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(UPPEventServer)

describe(@"UPPEventServer", ^{
    __block UPPEventServer *sut;

    beforeEach(^{
        sut = [UPPEventServer new];
    });

    describe(@"when initialising", ^{
        it(@"should have a server instance", ^{
            expect(sut).toNot.beNil();
            expect(sut.webServer).toNot.beNil();
            expect(sut.webServer).to.beKindOf([GCDWebServer class]);
        });
    });

    describe(@"when starting server", ^{
        __block id mockServer;

        beforeEach(^{
            mockServer = OCMClassMock([GCDWebServer class]);
            NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/"];
            OCMStub([mockServer serverURL]).andReturn(url);
            sut.webServer = mockServer;
        });

        it(@"should add a handler for NOTIFY", ^{
            OCMExpect([mockServer addHandlerForMethod:@"NOTIFY" path:@"/Event" requestClass:[GCDWebServerDataRequest class] processBlock:[OCMArg any]]);

            [sut startServer];

            OCMVerifyAll(mockServer);
        });

        it(@"should start up the server on the correct port", ^{
            OCMExpect([mockServer startWithPort:UPPEventServerPort bonjourName:nil]);

            [sut startServer];

            OCMVerifyAll(mockServer);
        });

        it(@"should expose the URL of the server when running", ^{
            OCMStub([mockServer startWithPort:UPPEventServerPort bonjourName:nil]).andReturn(YES);
            OCMStub([mockServer isRunning]).andReturn(YES);

            [sut startServer];
            NSURL *callbackURL = [sut eventServerCallbackURL];

            NSURL *expected = [NSURL URLWithString:@"http://127.0.0.1/Event"];
            expect(callbackURL).to.equal(expected);
        });

        it(@"should return nil for URL server not running", ^{
            OCMStub([mockServer isRunning]).andReturn(NO);
            expect([sut eventServerCallbackURL]).to.beNil();
        });
    });

    describe(@"when shutting down server", ^{
        __block id mockServer;

        beforeEach(^{
            mockServer = OCMClassMock([GCDWebServer class]);
            NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/"];
            OCMStub([mockServer serverURL]).andReturn(url);
            sut.webServer = mockServer;
        });

        it(@"should shut down web server if running", ^{
            OCMStub([mockServer isRunning]).andReturn(YES);
            OCMExpect([mockServer stop]);

            [sut stopServer];

            OCMVerifyAll(mockServer);
        });

        it(@"should not shut down web server if not running", ^{
            OCMStub([mockServer isRunning]).andReturn(NO);
            [[mockServer reject] stop];

            [sut stopServer];

            OCMVerifyAll(mockServer);
        });
    });

    describe(@"when recieving an event", ^{

        __block id response;
        __block id mockServer;
        __block GCDWebServerProcessBlock processBlock;

        beforeEach(^{
            mockServer = OCMClassMock([GCDWebServer class]);
            sut.webServer = mockServer;
            void (^theBlock)(NSInvocation *) = ^(NSInvocation *invocation) {
                [invocation retainArguments];
                NSUInteger args = [[invocation methodSignature] numberOfArguments];
                [invocation getArgument:&processBlock
                                atIndex:args - 1];
            };

            OCMStub([mockServer addHandlerForMethod:[OCMArg any]
                                               path:[OCMArg any]
                                       requestClass:[OCMArg any]
                                       processBlock:[OCMArg any]]).andDo(theBlock);

            [sut startServer];
        });

        it(@"should respond with an empty web server response", ^{
            response = processBlock(nil);

            expect(response).toNot.beNil();
            expect(response).to.beKindOf([GCDWebServerResponse class]);
        });

        it(@"should parse data and return to delegate upon recieving NOTIFY", ^{
            NSString *sid = @"uuid:13d860b0-5ed1-1cef-b959-88ea708ed26b";

            NSDictionary *headers;
            headers = @{ @"HOST": @"10.54.6.197:49170",
                         @"CONTENT-TYPE": @"text/xml; charset=\"utf-8\"",
                         @"CONTENT-LENGTH": @"3820",
                         @"NT": @"upnp:event",
                         @"NTS": @"upnp:propchange",
                         @"SID": sid,
                         @"SEQ": @"15" };

            NSData *body = LoadDataFromXML(@"LastChangeFull", [self class]);
            expect(body).toNot.beNil();

            id mockRequest = OCMClassMock([GCDWebServerDataRequest class]);
            OCMStub([mockRequest headers]).andReturn(headers);
            OCMStub([mockRequest data]).andReturn(body);

            id mockDelegate = OCMProtocolMock(@protocol(UPPEventServerDelegate));
            OCMExpect([mockDelegate eventReceived:[OCMArg checkWithBlock:^BOOL(NSDictionary *event) {
                expect(event).toNot.beNil();
                expect(event[UPPEventServerSIDKey]).to.equal(sid);
                expect(event[UPPEventServerBodyKey]).toNot.beNil();
                return YES;
            }]]);
            sut.eventDelegate = mockDelegate;
            expect(sut.eventDelegate).toNot.beNil();

            processBlock(mockRequest);

            OCMVerifyAll(mockDelegate);
        });
    });
});

SpecEnd
