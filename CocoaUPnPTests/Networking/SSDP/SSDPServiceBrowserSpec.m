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
    
    beforeEach(^{
        browser = [[SSDPServiceBrowser alloc] init];
        mockMulticastSocket = OCMClassMock([GCDAsyncUdpSocket class]);
        browser.multicastSocket = mockMulticastSocket;
    });
    
    afterEach(^{
        [mockMulticastSocket stopMocking];
    });
    
    it(@"should lazily setup multicast socket", ^{
        browser.multicastSocket = nil;
        
        GCDAsyncUdpSocket *socket = browser.multicastSocket;
        
        expect(socket).toNot.beNil();
        expect(socket.delegate).to.equal(browser);
        expect(socket.delegateQueue).to.equal(dispatch_get_main_queue());
    });
    
    describe(@"when starting browsing", ^{
        it(@"should setup multicast socket if not setup", ^{
            OCMExpect([mockMulticastSocket isConnected]).andReturn(NO);
            OCMExpect([mockMulticastSocket setIPv6Enabled:NO]);
            
            OCMExpect([mockMulticastSocket
                       bindToPort:1900 error:[OCMArg anyObjectRef]]).andReturn(YES);
            
            OCMExpect([mockMulticastSocket
                       joinMulticastGroup:SSDPMulticastGroupAddress
                       error:[OCMArg anyObjectRef]]).andReturn(YES);
            
            OCMExpect([mockMulticastSocket beginReceiving:[OCMArg anyObjectRef]]).andReturn(YES);
            
            [browser startBrowsingForServiceTypes:nil];
            
            OCMVerifyAll(mockMulticastSocket);
        });
        
        it(@"should not setup multicast socket if already setup", ^{
            // Strict mock will fail on any unexpected calls
            id strictMock = OCMStrictClassMock([GCDAsyncUdpSocket class]);
            browser.multicastSocket = strictMock;
            OCMExpect([strictMock isConnected]).andReturn(YES);
            
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
            OCMExpect([mockMulticastSocket isConnected]).andReturn(YES);
            
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
                                             toHost:SSDPMulticastGroupAddress
                                               port:SSDPMulticastUDPPort
                                        withTimeout:-1
                                                tag:11]);
            
            [browser startBrowsingForServiceTypes:nil];
            
            OCMVerifyAll(mockMulticastSocket);
        });
        
        it(@"should send data for specific service type", ^{
            OCMExpect([mockMulticastSocket isConnected]).andReturn(YES);
            
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
                                             toHost:SSDPMulticastGroupAddress
                                               port:SSDPMulticastUDPPort
                                        withTimeout:-1
                                                tag:11]);
            
            [browser startBrowsingForServiceTypes:@"upnp:rootdevice"];
            
            OCMVerifyAll(mockMulticastSocket);
        });
    });
    
    describe(@"when stopping browsing", ^{
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
});

SpecEnd
