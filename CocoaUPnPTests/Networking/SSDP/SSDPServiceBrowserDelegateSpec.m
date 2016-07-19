// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/SSDPServiceBrowser.h>
#import <CocoaUPnP/SSDPService.h>
#import "SSDPDelegateTestHelper.h"
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>

SpecBegin(SSDPServiceBrowserDelegate)

describe(@"SSDPServiceBrowser", ^{

    __block SSDPServiceBrowser *browser;
    __block id mockMulticastSocket;
    __block id mockDelegate;

    beforeEach(^{
        browser = [[SSDPServiceBrowser alloc] init];
        mockMulticastSocket = OCMClassMock([GCDAsyncUdpSocket class]);
        browser.multicastSocket = mockMulticastSocket;

        mockDelegate = OCMProtocolMock(@protocol(SSDPServiceBrowserDelegate));
        browser.delegate = mockDelegate;
    });

    afterEach(^{
        [mockMulticastSocket stopMocking];
    });

    it(@"should conform to GCDAsyncUdpSocketDelegate", ^{
        expect(browser).to.conformTo(@protocol(GCDAsyncUdpSocketDelegate));
    });

    it(@"should inform delegate when data received", ^{
        NSString *location = @"http://127.0.0.1/desc.xml";
        NSString *server = @"exampleServer";
        NSNumber *cache = @1800;
        NSString *searchTarget = @"upnp:root";
        NSString *usn = @"exampleUSN";

        NSString *header = [NSString stringWithFormat:
                            @"HTTP/1.1 200 OK\r\n"
                            @"LOCATION: %@\r\n"
                            @"SERVER: %@\r\n"
                            @"CACHE-CONTROL: max-age %@\r\n"
                            @"EXT: \r\n"
                            @"ST: %@\r\n"
                            @"USN: %@\r\n\r\n",
                            location,
                            server,
                            cache,
                            searchTarget,
                            usn];


        // Expect that the returned object is probably right
        OCMExpect([mockDelegate ssdpBrowser:[OCMArg checkWithBlock:^BOOL(id obj) {
            return [obj isEqual:browser];
        }] didFindService:[OCMArg checkWithBlock:^BOOL(SSDPService *service) {
            if ([service.uniqueServiceName isEqualToString:usn]) { return YES; }
            return NO;
        }]]);

        NSData *data = [header dataUsingEncoding:NSUTF8StringEncoding];
        [browser udpSocket:nil didReceiveData:data fromAddress:nil withFilterContext:nil];

        // Delegate calls are asynchronous, add a delay
        OCMVerifyAllWithDelay(mockDelegate, 0.5);
    });

    it(@"should inform delegate when alive notification received", ^{
        NSString *location = @"http://127.0.0.1/desc.xml";
        NSString *server = @"exampleServer";
        NSNumber *cache = @1800;
        NSString *notifyTarget = @"upnp:root";
        NSString *usn = @"exampleUSN";

        NSString *header = [NSString stringWithFormat:
                            @"NOTIFY * HTTP/1.1\r\n"
                            @"HOST: 239.255.255.250:1900\r\n"
                            @"CACHE-CONTROL: max-age = %@\r\n"
                            @"LOCATION: %@\r\n"
                            @"NT: %@\r\n"
                            @"NTS: ssdp:alive\r\n"
                            @"SERVER: %@\r\n"
                            @"USN: %@\r\n\r\n",
                            cache,
                            location,
                            notifyTarget,
                            server,
                            usn];

        // Expect that the returned object is probably right
        OCMExpect([mockDelegate ssdpBrowser:[OCMArg checkWithBlock:^BOOL(id obj) {
            return [obj isEqual:browser];
        }] didFindService:[OCMArg checkWithBlock:^BOOL(SSDPService *service) {
            if ([service.uniqueServiceName isEqualToString:usn]) { return YES; }
            return NO;
        }]]);

        NSData *data = [header dataUsingEncoding:NSUTF8StringEncoding];
        [browser udpSocket:nil didReceiveData:data fromAddress:nil withFilterContext:nil];

        // Delegate calls are asynchronous, add a delay
        OCMVerifyAllWithDelay(mockDelegate, 0.5);
    });

    it(@"should inform delegate when bye bye notification received", ^{
        NSString *notifyTarget = @"upnp:root";
        NSString *usn = @"exampleUSN";

        NSString *header = [NSString stringWithFormat:
                            @"NOTIFY * HTTP/1.1\r\n"
                            @"HOST: 239.255.255.250:1900\r\n"
                            @"NT: %@\r\n"
                            @"NTS: ssdp:byebye\r\n"
                            @"USN: %@\r\n\r\n",
                            notifyTarget,
                            usn];

        // Expect that the returned object is probably right
        OCMExpect([mockDelegate ssdpBrowser:[OCMArg checkWithBlock:^BOOL(id obj) {
            return [obj isEqual:browser];
        }] didRemoveService:[OCMArg checkWithBlock:^BOOL(SSDPService *service) {
            if ([service.uniqueServiceName isEqualToString:usn]) { return YES; }
            return NO;
        }]]);

        NSData *data = [header dataUsingEncoding:NSUTF8StringEncoding];
        [browser udpSocket:nil didReceiveData:data fromAddress:nil withFilterContext:nil];

        // Delegate calls are asynchronous, add a delay
        OCMVerifyAllWithDelay(mockDelegate, 5.0);
    });

    it(@"should inform delegate when socket closes", ^{
        id mockError = OCMClassMock([NSError class]);
        OCMExpect([mockDelegate ssdpBrowser:[OCMArg checkWithBlock:^BOOL(id obj) {
            return [obj isEqual:browser];
        }] didNotStartBrowsingForServices:mockError]);

        [browser udpSocketDidClose:nil withError:mockError];

        OCMVerifyAllWithDelay(mockDelegate, 0.5);
    });
});

SpecEnd
