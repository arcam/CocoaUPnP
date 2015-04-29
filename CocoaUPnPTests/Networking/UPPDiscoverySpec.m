// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDiscovery.h"
#import "SSDPServiceBrowser.h"
#import "SSDPService.h"

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
    
    it(@"should add devices as they are discovered", ^{
        NSArray *availableDevices = discovery.availableDevices;
        expect(availableDevices.count).to.equal(0);
        
        id mockService = OCMClassMock([SSDPService class]);
        [discovery ssdpBrowser:nil didFindService:mockService];
        
        availableDevices = discovery.availableDevices;
        expect(availableDevices.count).to.equal(1);
    });
    
    it(@"should remove devices as they disappear", ^{
        id mockService = OCMClassMock([SSDPService class]);
        [discovery.devices addObject:mockService];
        
        NSArray *availableDevices = discovery.availableDevices;
        expect(availableDevices.count).to.equal(1);
        
        [discovery ssdpBrowser:nil didRemoveService:mockService];
        
        availableDevices = discovery.availableDevices;
        expect(availableDevices.count).to.equal(0);
    });
});

SpecEnd
