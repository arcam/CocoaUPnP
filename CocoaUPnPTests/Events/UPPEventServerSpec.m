// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventServer.h"
#import <OCMock/OCMock.h>
#import "GCDWebServerDataRequest.h"
#import "GCDWebServerFunctions.h"

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

        it(@"should expose the URL of the server", ^{
            NSURL *expected = [NSURL URLWithString:@"http://127.0.0.1/Event"];
            expect([sut eventServerCallbackURL]).to.equal(expected);
        });
    });

    describe(@"when recieving an event", ^{
        xit(@"should parse data and return to delegate upon recieving NOTIFY");
    });
});

SpecEnd
