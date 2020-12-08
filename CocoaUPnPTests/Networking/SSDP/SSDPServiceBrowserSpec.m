// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/SSDPServiceBrowser.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

// Expose private methods
@interface SSDPServiceBrowser ()
- (NSString *)_userAgentString;
@end

SpecBegin(SSDPServiceBrowser)

describe(@"SSDPServiceBrowser", ^{

    __block SSDPServiceBrowser *browser;
    __block id mockUnicastSocket;

    beforeEach(^{
        browser = [[SSDPServiceBrowser alloc] init];
        mockUnicastSocket = OCMClassMock([GCDAsyncUdpSocket class]);
        browser.unicastSocket = mockUnicastSocket;
    });

    afterEach(^{
        [mockUnicastSocket stopMocking];
    });

    it(@"should lazily setup unicast socket", ^{
        browser.unicastSocket = nil;

        GCDAsyncUdpSocket *socket = browser.unicastSocket;

        expect(socket).toNot.beNil();
        expect(socket.delegate).to.equal(browser);
        expect(socket.delegateQueue).to.equal(dispatch_get_main_queue());
    });

    describe(@"when starting browsing", ^{
        describe(@"unicast socket", ^{
            it(@"should get setup", ^{
                OCMExpect([mockUnicastSocket isClosed]).andReturn(YES);
                OCMExpect([mockUnicastSocket setIPv6Enabled:NO]);
                OCMExpect([mockUnicastSocket enableReusePort:YES error:[OCMArg anyObjectRef]]).andReturn(YES);
                OCMExpect([mockUnicastSocket bindToPort:1900 error:[OCMArg anyObjectRef]]).andReturn(YES);
                OCMExpect([mockUnicastSocket joinMulticastGroup:@"239.255.255.250" error:[OCMArg anyObjectRef]]).andReturn(YES);
                OCMExpect([mockUnicastSocket beginReceiving:[OCMArg anyObjectRef]]).andReturn(YES);

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(mockUnicastSocket);
            });

            it(@"should not get setup if already setup", ^{
                // Strict mock will fail on any unexpected calls
//                id strictMock = OCMStrictClassMock([GCDAsyncUdpSocket class]);
                browser.unicastSocket = mockUnicastSocket;
                OCMExpect([mockUnicastSocket isClosed]).andReturn(NO);

                // We don't really care about what the methods parameters are,
                // just need to state we expect it to be called.
                [[mockUnicastSocket reject] bindToPort:1900 error:[OCMArg anyObjectRef]];

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(mockUnicastSocket);
                [mockUnicastSocket stopMocking];
            });
        });
    });

    describe(@"when stopping browsing", ^{
        describe(@"unicast socket", ^{
            it(@"should leave unicast group", ^{
                OCMExpect([mockUnicastSocket
                           leaveMulticastGroup:SSDPMulticastGroupAddress
                           error:[OCMArg anyObjectRef]]);

                [browser stopBrowsingForServices];

                OCMVerifyAll(mockUnicastSocket);
            });

            it(@"should close socket", ^{
                OCMExpect([mockUnicastSocket close]);

                [browser stopBrowsingForServices];

                OCMVerifyAll(mockUnicastSocket);

                // Can't check for nil, as we lazily instantiate, so check for nil
                // by comparing multicastSocket to our mock
                expect(browser.unicastSocket).toNot.equal(mockUnicastSocket);
            });
        });
    });
});

SpecEnd
