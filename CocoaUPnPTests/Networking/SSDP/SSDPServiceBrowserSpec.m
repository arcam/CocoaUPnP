// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "SSDPServiceBrowser.h"
#import "GCDAsyncUdpSocket.h"

// Expose private methods
@interface SSDPServiceBrowser ()
- (NSString *)_userAgentString;
@end

SpecBegin(SSDPServiceBrowser)

describe(@"SSDPServiceBrowser", ^{

    __block SSDPServiceBrowser *browser;
    __block id mockMulticastSocket;
    __block id mockUnicastSocket;

    beforeEach(^{
        browser = [[SSDPServiceBrowser alloc] init];
        mockMulticastSocket = OCMClassMock([GCDAsyncUdpSocket class]);
        browser.multicastSocket = mockMulticastSocket;

        mockUnicastSocket = OCMClassMock([GCDAsyncUdpSocket class]);
        browser.unicastSocket = mockUnicastSocket;
    });

    afterEach(^{
        [mockMulticastSocket stopMocking];
        [mockUnicastSocket stopMocking];
    });

    it(@"should lazily setup multicast socket", ^{
        browser.multicastSocket = nil;

        GCDAsyncUdpSocket *socket = browser.multicastSocket;

        expect(socket).toNot.beNil();
        expect(socket.delegate).to.equal(browser);
        expect(socket.delegateQueue).to.equal(dispatch_get_main_queue());
    });

    it(@"should lazily setup unicast socket", ^{
        browser.unicastSocket = nil;

        GCDAsyncUdpSocket *socket = browser.unicastSocket;

        expect(socket).toNot.beNil();
        expect(socket.delegate).to.equal(browser);
        expect(socket.delegateQueue).to.equal(dispatch_get_main_queue());
    });

    describe(@"when starting browsing", ^{
        describe(@"multicast socket", ^{
            it(@"should get setup", ^{
                OCMExpect([mockMulticastSocket isClosed]).andReturn(YES);
                OCMExpect([mockMulticastSocket setIPv6Enabled:NO]);

                OCMExpect([mockMulticastSocket bindToAddress:[OCMArg any] error:[OCMArg anyObjectRef]]).andReturn(YES);

                OCMExpect([mockMulticastSocket
                           joinMulticastGroup:SSDPMulticastGroupAddress
                           error:[OCMArg anyObjectRef]]).andReturn(YES);

                OCMExpect([mockMulticastSocket beginReceiving:[OCMArg anyObjectRef]]).andReturn(YES);

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(mockMulticastSocket);
            });

            it(@"should not get setup if already setup", ^{
                // Strict mock will fail on any unexpected calls
                id strictMock = OCMStrictClassMock([GCDAsyncUdpSocket class]);
                browser.multicastSocket = strictMock;
                OCMExpect([strictMock isClosed]).andReturn(NO);

                // We don't really care about what the methods parameters are,
                // just need to state we expect it to be called.
                [[[strictMock expect] ignoringNonObjectArgs] sendData:[OCMArg any]
                                                               toHost:[OCMArg any]
                                                                 port:123
                                                          withTimeout:123
                                                                  tag:123];

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(strictMock);
                [strictMock stopMocking];
            });

            it(@"should send data if connected", ^{
                OCMExpect([mockMulticastSocket isClosed]).andReturn(NO);

                NSString *searchHeader = [NSString stringWithFormat:
                                          @"M-SEARCH * HTTP/1.1\r\n"
                                          @"HOST: 239.255.255.250:1900\r\n"
                                          @"MAN: \"ssdp:discover\"\r\n"
                                          @"ST: ssdp:all\r\n"
                                          @"MX: 3\r\n"
                                          @"USER-AGENT: %@/1\r\n\r\n\r\n",
                                          [browser _userAgentString]];
                NSData *data = [searchHeader dataUsingEncoding:NSUTF8StringEncoding];

                OCMExpect([mockMulticastSocket sendData:data
                                                 toHost:@"239.255.255.250"
                                                   port:1900
                                            withTimeout:-1
                                                    tag:11]);

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(mockMulticastSocket);
            });

            it(@"should send data for specific service type", ^{
                OCMExpect([mockMulticastSocket isClosed]).andReturn(NO);

                NSString *searchHeader = [NSString stringWithFormat:
                                          @"M-SEARCH * HTTP/1.1\r\n"
                                          @"HOST: 239.255.255.250:1900\r\n"
                                          @"MAN: \"ssdp:discover\"\r\n"
                                          @"ST: upnp:rootdevice\r\n"
                                          @"MX: 3\r\n"
                                          @"USER-AGENT: %@/1\r\n\r\n\r\n",
                                          [browser _userAgentString]];
                NSData *data = [searchHeader dataUsingEncoding:NSUTF8StringEncoding];

                OCMExpect([mockMulticastSocket sendData:data
                                                 toHost:@"239.255.255.250"
                                                   port:1900
                                            withTimeout:-1
                                                    tag:11]);

                [browser startBrowsingForServiceTypes:@"upnp:rootdevice"];

                OCMVerifyAll(mockMulticastSocket);
            });
        });

        describe(@"unicast socket", ^{
            it(@"should get setup", ^{
                OCMExpect([mockUnicastSocket isClosed]).andReturn(YES);
                OCMExpect([mockUnicastSocket setIPv6Enabled:NO]);
                OCMExpect([mockUnicastSocket bindToPort:1900 error:[OCMArg anyObjectRef]]).andReturn(YES);
                OCMExpect([mockUnicastSocket joinMulticastGroup:@"239.255.255.250" error:[OCMArg anyObjectRef]]).andReturn(YES);
                OCMExpect([mockUnicastSocket beginReceiving:[OCMArg anyObjectRef]]).andReturn(YES);

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(mockUnicastSocket);
            });

            it(@"should not get setup if already setup", ^{
                // Strict mock will fail on any unexpected calls
                id strictMock = OCMStrictClassMock([GCDAsyncUdpSocket class]);
                browser.unicastSocket = strictMock;
                OCMExpect([strictMock isClosed]).andReturn(NO);

                // We don't really care about what the methods parameters are,
                // just need to state we expect it to be called.
                [[strictMock reject] bindToPort:1900 error:[OCMArg anyObjectRef]];

                [browser startBrowsingForServiceTypes:nil];

                OCMVerifyAll(strictMock);
                [strictMock stopMocking];
            });
        });
    });

    describe(@"when stopping browsing", ^{
        describe(@"multicast socket", ^{
            it(@"should leave multicast group", ^{
                OCMExpect([mockMulticastSocket
                           leaveMulticastGroup:SSDPMulticastGroupAddress
                           error:[OCMArg anyObjectRef]]);

                [browser stopBrowsingForServices];

                OCMVerifyAll(mockMulticastSocket);
            });

            it(@"should close socket", ^{
                OCMExpect([mockMulticastSocket close]);

                [browser stopBrowsingForServices];

                OCMVerifyAll(mockMulticastSocket);

                // Can't check for nil, as we lazily instantiate, so check for nil
                // by comparing multicastSocket to our mock
                expect(browser.multicastSocket).toNot.equal(mockMulticastSocket);
            });
        });

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
                expect(browser.multicastSocket).toNot.equal(mockUnicastSocket);
            });
        });
    });
});

SpecEnd
