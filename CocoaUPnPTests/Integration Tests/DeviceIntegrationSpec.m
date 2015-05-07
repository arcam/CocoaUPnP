// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDeviceParser.h"
#import "OHHTTPStubs.h"
#import "UPPMediaRendererDevice.h"
#import "UPPRenderingControlService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"

SpecBegin(DeviceIntegration)

describe(@"UPPDeviceParser", ^{
    it(@"should populate a media renderer device and services from a URL", ^{
        NSString *urlString = @"http://127.0.0.1/desc.xml";
        NSURL *url = [NSURL URLWithString:urlString];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.absoluteString isEqualToString:url.absoluteString];
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSData *data = LoadDataFromXML(@"Device", [self class]);
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:nil];
        }];
        
        waitUntil(^(DoneCallback done) {
            [UPPDeviceParser parseURL:url withCompletion:^(id device, NSError *error) {
                UPPMediaRendererDevice *renderer = device;
                expect(renderer).toNot.beNil();
                expect(renderer).to.beKindOf([UPPMediaRendererDevice class]);
                
                expect(renderer.deviceType).to.equal(@"urn:schemas-upnp-org:device:MediaRenderer:1");
                expect(renderer.friendlyName).to.equal(@"Paul");
                expect(renderer.manufacturer).to.equal(@"ARCAM");
                expect(renderer.manufacturerURL.absoluteString).to.equal(@"http://www.arcam.co.uk");
                expect(renderer.modelDescription).to.equal(@"A description");
                expect(renderer.modelName).to.equal(@"model");
                expect(renderer.modelNumber).to.equal(@"123");
                expect(renderer.modelURL.absoluteString).to.equal(@"http://www.arcam.co.uk");
                expect(renderer.serialNumber).to.equal(@"123456789012");
                expect(renderer.udn).to.equal(@"uuid:5f9ec1b3-ed59-1900-4530-123456789012");
                expect(renderer.usn).to.equal(@"uuid:5f9ec1b3-ed59-1900-4530-123456789012::urn:schemas-upnp-org:device:MediaRenderer:1");
                
                
                UPPRenderingControlService *renderingService = [renderer renderingControlService];
                expect(renderingService).toNot.beNil();
                expect(renderingService.serviceType).to.equal(@"urn:schemas-upnp-org:service:RenderingControl:1");
                NSURL *controlURL = [NSURL URLWithString:@"http://127.0.0.1/RenderingControl/ctrl"];
                expect(renderingService.controlURL).to.equal(controlURL);
                NSURL *eventURL = [NSURL URLWithString:@"http://127.0.0.1/RenderingControl/evt"];
                expect(renderingService.eventSubscriptionURL).to.equal(eventURL);
                
                UPPConnectionManagerService *connectionManager = [renderer connectionManagerService];
                expect(connectionManager).toNot.beNil();
                expect(connectionManager.serviceType).to.equal(@"urn:schemas-upnp-org:service:ConnectionManager:1");
                controlURL = [NSURL URLWithString:@"http://127.0.0.1/ConnectionManager/ctrl"];
                expect(connectionManager.controlURL).to.equal(controlURL);
                eventURL = [NSURL URLWithString:@"http://127.0.0.1/ConnectionManager/evt"];
                expect(connectionManager.eventSubscriptionURL).to.equal(eventURL);
                
                UPPAVTransportService *avTransport = [renderer avTransportService];
                expect(avTransport).toNot.beNil();
                expect(avTransport.serviceType).to.equal(@"urn:schemas-upnp-org:service:AVTransport:1");
                controlURL = [NSURL URLWithString:@"http://127.0.0.1/AVTransport/ctrl"];
                expect(avTransport.controlURL).to.equal(controlURL);
                eventURL = [NSURL URLWithString:@"http://127.0.0.1/AVTransport/evt"];
                expect(avTransport.eventSubscriptionURL).to.equal(eventURL);
                
                done();
            }];
        });
    });
});

SpecEnd
