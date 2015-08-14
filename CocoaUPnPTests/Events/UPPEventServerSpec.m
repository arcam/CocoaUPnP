// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventServer.h"
#import <OCMock/OCMock.h>

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
            sut.webServer = mockServer;
        });

        it(@"should add a handler for NOTIFY", ^{
            OCMExpect([mockServer addHandlerForMethod:@"NOTIFY" path:[OCMArg any] requestClass:[OCMArg any] processBlock:[OCMArg any]]);

            [sut startServer];

            OCMVerifyAll(mockServer);
        });

        xit(@"should use the exposed path");
        pending(@"should use the exposed port");
        xit(@"should return success when starting successfully");
        xit(@"should return error when starting without delegate");
        xit(@"should forward error if unable to start");
    });

    describe(@"when recieving an event", ^{
        xit(@"should parse data and return to delegate upon recieving NOTIFY");
    });

});

SpecEnd
