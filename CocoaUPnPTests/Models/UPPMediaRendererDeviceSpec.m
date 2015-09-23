// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>

SpecBegin(UPPMediaRendererDevice)

describe(@"UPPMediaRendererDevice", ^{

    __block UPPMediaRendererDevice *device;
    __block NSURL *baseURL;
    __block NSString *urn;

    beforeEach(^{
        urn = @"urn:schemas-upnp-org:device:MediaRenderer:1";
        baseURL = [NSURL URLWithString:@"http://127.0.0.1:5000"];

        device = [UPPMediaRendererDevice mediaRendererWithURN:urn baseURL:baseURL];

        UPPServiceDescription *renderingControlService = [[UPPServiceDescription alloc] init];
        renderingControlService.controlURL = @"ctrl/render";
        renderingControlService.serviceType = @"urn:schemas-upnp-org:service:RenderingControl:1";

        UPPServiceDescription *connectionManagerService = [[UPPServiceDescription alloc] init];
        connectionManagerService.controlURL = @"ctrl/connmgr";
        connectionManagerService.serviceType = @"urn:schemas-upnp-org:service:ConnectionManager:1";

        UPPServiceDescription *avTransportService = [[UPPServiceDescription alloc] init];
        avTransportService.controlURL = @"ctrl/trnspt";
        avTransportService.serviceType = @"urn:schemas-upnp-org:service:AVTransport:1";

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
            expect(service.controlURL.absoluteURL).to.equal(controlURL);
        });

        it(@"should return any rendering control service", ^{
            UPPServiceDescription *renderingControlService = [[UPPServiceDescription alloc] init];
            renderingControlService.serviceType = @"urn:schemas-upnp-org:service:RenderingControl:2";
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
            expect(service.controlURL.absoluteURL).to.equal(controlURL);
        });

        it(@"should return any connection manager service", ^{
            UPPServiceDescription *connectionManagerService = [[UPPServiceDescription alloc] init];
            connectionManagerService.serviceType = @"urn:schemas-upnp-org:service:ConnectionManager:2";
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
            expect(service.controlURL.absoluteURL).to.equal(controlURL);
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
