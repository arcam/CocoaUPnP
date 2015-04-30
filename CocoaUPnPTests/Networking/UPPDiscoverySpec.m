// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDiscovery.h"
#import "SSDPServiceBrowser.h"
#import "SSDPService.h"
#import "UPPBasicDevice.h"
#import "UPPDeviceParser.h"

@interface UPPDiscovery ()
@property (strong, nonatomic) NSMutableArray *devices;
@end

SpecBegin(UPPDiscovery)

describe(@"UPPDiscovery", ^{
    
    __block UPPDiscovery *discovery;
    
    beforeEach(^{
        discovery = [[UPPDiscovery alloc] init];
        
    });
    
    it(@"should have a shared instance", ^{
        expect([UPPDiscovery sharedInstance]).to.beIdenticalTo([UPPDiscovery sharedInstance]);
    });
    
    it(@"should conform to SSDPServiceBrowserDelegate", ^{
        expect(discovery).to.conformTo(@protocol(SSDPServiceBrowserDelegate));
    });
    
    describe(@"when SSDPServiceBrowserDelegate methods called", ^{
        
        __block id mockParser;
        __block id mockDevice;
        __block id mockService;
        __block NSURL *url;
        __block NSString *usn;
        
        beforeEach(^{
            mockParser = OCMClassMock([UPPDeviceParser class]);
            discovery.parser = mockParser;
            
            mockDevice = OCMClassMock([UPPBasicDevice class]);
            
            url = [NSURL URLWithString:@"http://127.0.0.1/desc.xml"];
            mockService = OCMClassMock([SSDPService class]);
            OCMStub([mockService location]).andReturn(url);
            
            usn = @"usn";
            
            expect(discovery.availableDevices.count).to.equal(0);
        });
        
        afterEach(^{
            [mockParser stopMocking];
            [mockDevice stopMocking];
            [mockService stopMocking];
        });
        
        describe(@"when a device is added", ^{
            it(@"should parse and add parsed devices to availableDevices", ^{
                OCMExpect([mockParser parseURL:url withCompletion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void(^completionBlock)(UPPBasicDevice *device, NSError *error);
                    [invocation getArgument:&completionBlock atIndex:3];
                    completionBlock(mockDevice, nil);
                });
                
                [discovery ssdpBrowser:nil didFindService:mockService];
                
                NSArray *availableDevices = discovery.availableDevices;
                expect(availableDevices.count).to.equal(1);
                expect(availableDevices[0]).to.beIdenticalTo(mockDevice);
                
                OCMVerifyAll(mockParser);
            });
            
            it(@"should not try and add a device if there was a parser error", ^{
                OCMExpect([mockParser parseURL:url withCompletion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void(^completionBlock)(UPPBasicDevice *device, NSError *error);
                    [invocation getArgument:&completionBlock atIndex:3];
                    completionBlock(nil, nil);
                });
                
                [discovery ssdpBrowser:nil didFindService:mockService];
                
                NSArray *availableDevices = discovery.availableDevices;
                expect(availableDevices.count).to.equal(0);
            });
        });

        describe(@"when a device is removed", ^{
            beforeEach(^{
                // OCMock objects do not respond to predicate matches
                UPPBasicDevice *device = [UPPBasicDevice new];
                device.udn = usn;
                [discovery.devices addObject:device];
            });
            
            it(@"should remove devices as they disappear", ^{
                OCMStub([mockService uniqueServiceName]).andReturn(usn);
                
                [discovery ssdpBrowser:nil didRemoveService:mockService];
                
                expect(discovery.availableDevices.count).to.equal(0);
            });
            
            it(@"should not remove devices if no match found", ^{
                OCMStub([mockService uniqueServiceName]).andReturn(@"foo");
                
                [discovery ssdpBrowser:nil didRemoveService:mockService];
                
                expect(discovery.availableDevices.count).to.equal(1);
            });
        });
    });
});

SpecEnd
