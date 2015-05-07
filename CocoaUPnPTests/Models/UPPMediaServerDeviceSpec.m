// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaServerDevice.h"
#import "UPPContentDirectoryService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"
#import "UPPServiceDescription.h"

SpecBegin(UPPMediaServerDevice)

describe(@"UPPMediaServerDevice", ^{
    
    __block UPPMediaServerDevice *device;
    __block NSURL *baseURL;
    __block NSString *urn;
    
    beforeEach(^{
        urn = @"urn:schemas-upnp-org:device:MediaServer:1";
        baseURL = [NSURL URLWithString:@"http://127.0.0.1:5000"];
        
        device = [UPPMediaServerDevice mediaServerWithURN:urn baseURL:baseURL];
        
        UPPServiceDescription *contentDirectoryService = [[UPPServiceDescription alloc] init];
        contentDirectoryService.controlURL = @"ctrl/dir";
        contentDirectoryService.serviceType = @"urn:schemas-upnp-org:service:ContentDirectory:1";
        
        UPPServiceDescription *connectionManagerService = [[UPPServiceDescription alloc] init];
        connectionManagerService.controlURL = @"ctrl/connmgr";
        connectionManagerService.serviceType = @"urn:schemas-upnp-org:service:ConnectionManager:1";
        
        UPPServiceDescription *avTransportService = [[UPPServiceDescription alloc] init];
        avTransportService.controlURL = @"ctrl/trnspt";
        avTransportService.serviceType = @"urn:schemas-upnp-org:service:AVTransport:1";
        
        NSArray *services = @[ contentDirectoryService,
                               connectionManagerService,
                               avTransportService ];
        
        device.services = services;
    });
    
    it(@"should have expected base url", ^{
        expect(device.baseURL).to.equal(baseURL);
    });
    
    it(@"should have an expected namespace", ^{
        expect(device.deviceType).to.equal(urn);
    });
    
    describe(@"content directory service", ^{
        it(@"should return a content directory service", ^{
            NSURL *controlURL = [baseURL URLByAppendingPathComponent:@"ctrl/dir"];
            
            UPPContentDirectoryService *service = [device contentDirectoryService];
            
            expect(service).toNot.beNil();
            expect(service.controlURL).to.equal(controlURL);
        });
        
        it(@"should return any content directory service", ^{
            UPPServiceDescription *contentDirectoryService = [[UPPServiceDescription alloc] init];
            contentDirectoryService.serviceType = @"urn:schemas-upnp-org:service:ContentDirectory:2";
            device.services = @[ contentDirectoryService ];
            
            UPPContentDirectoryService *service = [device contentDirectoryService];
            
            expect(service).toNot.beNil();
        });
    });
    
    describe(@"connection manager service", ^{
        it(@"should return a connection manager service", ^{
            NSURL *controlURL = [baseURL URLByAppendingPathComponent:@"ctrl/connmgr"];
            
            UPPConnectionManagerService *service = [device connectionManagerService];
            
            expect(service).toNot.beNil();
            expect(service.controlURL).to.equal(controlURL);
        });
        
        it(@"should return any connection manager service", ^{
            UPPServiceDescription *connectionManagerService = [[UPPServiceDescription alloc] init];
            connectionManagerService.serviceType = @"urn:schemas-upnp-org:service:ConnectionManager:2";
            device.services = @[ connectionManagerService ];
            
            UPPConnectionManagerService *service = [device connectionManagerService];
            
            expect(service).toNot.beNil();
        });
    });
    
    describe(@"av transport service", ^{
        it(@"should return an AV transport service", ^{
            NSURL *controlURL = [baseURL URLByAppendingPathComponent:@"ctrl/trnspt"];
            
            UPPAVTransportService *service = [device avTransportService];
            
            expect(service).toNot.beNil();
            expect(service.controlURL).to.equal(controlURL);
        });
        
        it(@"should match any AV transport service", ^{
            UPPServiceDescription *avTransportService = [[UPPServiceDescription alloc] init];
            avTransportService.serviceType = @"urn:schemas-upnp-org:service:AVTransport:2";
            device.services = @[ avTransportService ];
            
            UPPAVTransportService *service = [device avTransportService];
            
            expect(service).toNot.beNil();
        });
    });
});

SpecEnd
