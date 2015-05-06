// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaRendererDevice.h"
#import "UPPBasicService.h"
#import "UPPRenderingControlService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"

SpecBegin(UPPMediaRendererDevice)

describe(@"UPPMediaRendererDevice", ^{
    
    __block UPPMediaRendererDevice *device;
    __block NSURL *baseURL;
    __block NSString *urn;
    
    beforeEach(^{
        urn = @"urn:schemas-upnp-org:device:MediaRenderer:1";
        baseURL = [NSURL URLWithString:@"http://127.0.0.1:5000"];
        
        device = [UPPMediaRendererDevice mediaRendererWithURN:urn baseURL:baseURL];
        
        UPPBasicService *renderingControlService = [[UPPBasicService alloc] init];
        renderingControlService.controlURL = [NSURL URLWithString:@"ctrl/render"];
        renderingControlService.nameSpace = @"urn:schemas-upnp-org:service:RenderingControl:1";
        
        UPPBasicService *connectionManagerService = [[UPPBasicService alloc] init];
        connectionManagerService.controlURL = [NSURL URLWithString:@"ctrl/connmgr"];
        connectionManagerService.nameSpace = @"urn:schemas-upnp-org:service:ConnectionManager:1";
        
        UPPBasicService *avTransportService = [[UPPBasicService alloc] init];
        avTransportService.controlURL = [NSURL URLWithString:@"ctrl/trnspt"];
        avTransportService.nameSpace = @"urn:schemas-upnp-org:service:AVTransport:1";
        
        NSArray *services = @[ renderingControlService,
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
    
    describe(@"rendering control service", ^{
        it(@"should return a rendering control service", ^{
            NSURL *controlURL = [baseURL URLByAppendingPathComponent:@"ctrl/render"];
            
            UPPRenderingControlService *service = [device renderingControlService];
            
            expect(service).toNot.beNil();
            expect(service.controlURL).to.equal(controlURL);
        });
        
        it(@"should return any rendering control service", ^{
            UPPBasicService *renderingControlService = [[UPPBasicService alloc] init];
            renderingControlService.nameSpace = @"urn:schemas-upnp-org:service:RenderingControl:2";
            device.services = @[ renderingControlService ];
            
            UPPRenderingControlService *service = [device renderingControlService];
            
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
            UPPBasicService *connectionManagerService = [[UPPBasicService alloc] init];
            connectionManagerService.nameSpace = @"urn:schemas-upnp-org:service:ConnectionManager:2";
            device.services = @[ connectionManagerService ];
            
            UPPConnectionManagerService *service = [device connectionManagerService];
            
            expect(service).toNot.beNil();
        });
    });
    
    describe(@"AV transport service", ^{
        it(@"should return an AV transport service", ^{
            NSURL *controlURL = [baseURL URLByAppendingPathComponent:@"ctrl/trnspt"];
            
            UPPAVTransportService *service = [device avTransportService];
            
            expect(service).toNot.beNil();
            expect(service.controlURL).to.equal(controlURL);
        });
        
        it(@"should match any AV transport service", ^{
            UPPBasicService *avTransportService = [[UPPBasicService alloc] init];
            avTransportService.nameSpace = @"urn:schemas-upnp-org:service:AVTransport:2";
            device.services = @[ avTransportService ];
            
            UPPAVTransportService *service = [device avTransportService];
            
            expect(service).toNot.beNil();
        });
    });
});

SpecEnd
