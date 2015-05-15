// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"
#import "UPPDeviceIcon.h"
#import "UPPServiceDescription.h"
#import "UPPError.h"
#import "OHHTTPStubs.h"
#import "UPPMediaRendererDevice.h"
#import "UPPRenderingControlService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"
#import "UPPMediaServerDevice.h"
#import "UPPContentDirectoryService.h"

SpecBegin(UPPDeviceParser)

describe(@"UPPDeviceParser", ^{

    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });

    it(@"should populate a media renderer device and services from a URL", ^{
        NSString *urlString = @"http://127.0.0.1/desc.xml";
        NSURL *url = [NSURL URLWithString:urlString];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL isEqual:url];
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

                // Icons
                NSArray *iconList = renderer.iconList;
                expect(iconList.count).to.equal(2);
                UPPDeviceIcon *icon = [iconList firstObject];
                expect(icon.mimetype).to.equal(@"image/jpeg");
                expect(icon.width).to.equal(48);
                expect(icon.height).to.equal(48);
                expect(icon.depth).to.equal(24);
                expect(icon.url).to.equal(@"/icon_small.jpg");

                // Services
                UPPRenderingControlService *renderingService = [renderer renderingControlService];
                expect(renderingService).toNot.beNil();
                expect(renderingService.serviceType).to.equal(@"urn:schemas-upnp-org:service:RenderingControl:1");
                NSURL *controlURL = [NSURL URLWithString:@"http://127.0.0.1/RenderingControl/ctrl"];
                expect(renderingService.controlURL.absoluteURL).to.equal(controlURL);
                NSURL *eventURL = [NSURL URLWithString:@"http://127.0.0.1/RenderingControl/evt"];
                expect(renderingService.eventSubscriptionURL.absoluteURL).to.equal(eventURL);

                UPPConnectionManagerService *connectionManager = [renderer connectionManagerService];
                expect(connectionManager).toNot.beNil();
                expect(connectionManager.serviceType).to.equal(@"urn:schemas-upnp-org:service:ConnectionManager:1");
                controlURL = [NSURL URLWithString:@"http://127.0.0.1/ConnectionManager/ctrl"];
                expect(connectionManager.controlURL.absoluteURL).to.equal(controlURL);
                eventURL = [NSURL URLWithString:@"http://127.0.0.1/ConnectionManager/evt"];
                expect(connectionManager.eventSubscriptionURL.absoluteURL).to.equal(eventURL);

                UPPAVTransportService *avTransport = [renderer avTransportService];
                expect(avTransport).toNot.beNil();
                expect(avTransport.serviceType).to.equal(@"urn:schemas-upnp-org:service:AVTransport:1");
                controlURL = [NSURL URLWithString:@"http://127.0.0.1/AVTransport/ctrl"];
                expect(avTransport.controlURL.absoluteURL).to.equal(controlURL);
                eventURL = [NSURL URLWithString:@"http://127.0.0.1/AVTransport/evt"];
                expect(avTransport.eventSubscriptionURL.absoluteURL).to.equal(eventURL);

                done();
            }];
        });
    });

    it(@"should populate a media server device and services from a URL", ^{
        NSString *urlString = @"http://127.0.0.2/desc.xml";
        NSURL *url = [NSURL URLWithString:urlString];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL isEqual:url];
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSData *data = LoadDataFromXML(@"MediaServer", [self class]);
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:nil];
        }];

        waitUntil(^(DoneCallback done) {
            [UPPDeviceParser parseURL:url withCompletion:^(id device, NSError *error) {
                UPPMediaServerDevice *server = device;
                expect(server).toNot.beNil();
                expect(server).to.beKindOf([UPPMediaServerDevice class]);

                expect(server.deviceType).to.equal(@"urn:schemas-upnp-org:device:MediaServer:1");
                expect(server.friendlyName).to.equal(@"Raspberry Pi");
                expect(server.manufacturer).to.equal(@"Justin Maggard");
                expect(server.manufacturerURL.absoluteString).to.equal(@"http://www.debian.org/");
                expect(server.modelDescription).to.equal(@"MiniDLNA on Debian");
                expect(server.modelName).to.equal(@"Windows Media Connect compatible (MiniDLNA)");
                expect(server.modelNumber).to.equal(@"1");
                expect(server.modelURL.absoluteString).to.equal(@"http://www.debian.org/");
                expect(server.serialNumber).to.equal(@"12345678");
                expect(server.udn).to.equal(@"uuid:4d696e69-444c-164e-9d41-b827eba5850a");
                expect(server.usn).to.equal(@"uuid:4d696e69-444c-164e-9d41-b827eba5850a::urn:schemas-upnp-org:device:MediaServer:1");

                // Icons
                NSArray *iconList = server.iconList;
                expect(iconList.count).to.equal(4);
                UPPDeviceIcon *icon = [iconList firstObject];
                expect(icon.mimetype).to.equal(@"image/png");
                expect(icon.width).to.equal(48);
                expect(icon.height).to.equal(48);
                expect(icon.depth).to.equal(24);
                expect(icon.url).to.equal(@"/icons/sm.png");

                UPPContentDirectoryService *cds = [server contentDirectoryService];
                expect(cds).toNot.beNil();
                expect(cds.serviceType).to.equal(@"urn:schemas-upnp-org:service:ContentDirectory:1");
                expect(cds.controlURL.absoluteString).to.equal(@"http://127.0.0.2/ctl/ContentDir");
                expect(cds.eventSubscriptionURL.absoluteString).to.equal(@"http://127.0.0.2/evt/ContentDir");

                UPPConnectionManagerService *connectionManager = [server connectionManagerService];
                expect(connectionManager).toNot.beNil();
                expect(connectionManager.serviceType).to.equal(@"urn:schemas-upnp-org:service:ConnectionManager:1");
                expect(connectionManager.controlURL.absoluteString).to.equal(@"http://127.0.0.2/ctl/ConnectionMgr");
                expect(connectionManager.eventSubscriptionURL.absoluteString).to.equal(@"http://127.0.0.2/evt/ConnectionMgr");

                expect([server avTransportService]).to.beNil();

                done();
            }];
        });
    });

    it(@"should return an error when no device found", ^{
        NSString *urlString = @"http://127.0.0.3/desc.xml";
        NSURL *url = [NSURL URLWithString:urlString];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL isEqual:url];
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSData *data = LoadDataFromXML(@"Empty", [self class]);
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:nil];
        }];

        waitUntil(^(DoneCallback done) {
            [UPPDeviceParser parseURL:url withCompletion:^(id device, NSError *error) {
                expect(device).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeNoDeviceElementFound);
                done();
            }];
        });
    });

    it(@"should exit early with no data", ^{
        NSString *urlString = @"http://127.0.0.3/desc.xml";
        NSURL *url = [NSURL URLWithString:urlString];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL isEqual:url];
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:nil];
        }];

        waitUntil(^(DoneCallback done) {
            [UPPDeviceParser parseURL:url withCompletion:^(id device, NSError *error) {
                expect(device).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeEmptyData);
                done();
            }];
        });
    });
});

SpecEnd
