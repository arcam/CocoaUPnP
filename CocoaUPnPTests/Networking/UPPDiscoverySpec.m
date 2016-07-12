// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import <CocoaUPnP/SSDPServiceBrowser.h>
#import <CocoaUPnP/SSDPService.h>

@interface UPPDiscovery ()
@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) NSMutableArray *unparsedUUIDs;
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

    describe(@"starting / stopping browsing", ^{
        __block id mockBrowser;

        beforeEach(^{
            mockBrowser = OCMClassMock([SSDPServiceBrowser class]);
            discovery.browser = mockBrowser;
        });

        it(@"should tell browser to start", ^{
            NSString *services = @"ssdp:all";
            OCMExpect([mockBrowser startBrowsingForServiceTypes:services]);
            [discovery startBrowsingForServices:services];
            OCMVerifyAll(mockBrowser);
        });

        it(@"should tell browser to stop", ^{
            OCMExpect([mockBrowser stopBrowsingForServices]);
            [discovery stopBrowsingForServices];
            OCMVerifyAll(mockBrowser);
        });
    });

    describe(@"when SSDPServiceBrowserDelegate methods called", ^{

        __block id mockParser;
        __block id mockDevice;
        __block id mockService;
        __block id mockDelegate;
        __block NSURL *url;
        __block NSString *uniqueDeviceName;
        __block NSString *uniqueServiceName;

        beforeEach(^{
            uniqueDeviceName = @"foo";
            uniqueServiceName = [NSString stringWithFormat:@"%@::bar", uniqueDeviceName];
            url = [NSURL URLWithString:@"http://127.0.0.1/desc.xml"];

            mockParser = OCMClassMock([UPPDeviceParser class]);
            mockDevice = OCMClassMock([UPPBasicDevice class]);
            mockService = OCMClassMock([SSDPService class]);
            OCMStub([mockService xmlLocation]).andReturn(url);
            mockDelegate = OCMProtocolMock(@protocol(UPPDiscoveryDelegate));
            [discovery addBrowserObserver:mockDelegate];

            expect(discovery.availableDevices.count).to.equal(0);
        });

        afterEach(^{
            [mockParser stopMocking];
            [mockDevice stopMocking];
            [mockService stopMocking];
            [mockDelegate stopMocking];
        });

        describe(@"when a device is added", ^{
            beforeEach(^{
                OCMStub([mockParser parseURL:url withCompletion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
                    void(^completionBlock)(NSArray *devices, NSError *error);
                    [invocation getArgument:&completionBlock atIndex:3];
                    completionBlock(@[mockDevice], nil);
                });
                OCMStub([mockService uniqueServiceName]).andReturn(uniqueServiceName);
                OCMStub([mockDevice valueForKey:@"udn"]).andReturn(uniqueDeviceName);
            });

            it(@"should add parsed device to availableDevices", ^{
                [discovery ssdpBrowser:nil didFindService:mockService];

                NSArray *availableDevices = discovery.availableDevices;
                expect(availableDevices.count).to.equal(1);
                expect(availableDevices[0]).to.beIdenticalTo(mockDevice);
            });

            it(@"should not add the same device twice", ^{
                [discovery ssdpBrowser:nil didFindService:mockService];
                expect(discovery.availableDevices.count).to.equal(1);

                [discovery ssdpBrowser:nil didFindService:mockService];
                expect(discovery.availableDevices.count).to.equal(1);
            });

            it(@"should not add the same device even if unparsed", ^{
                [discovery.unparsedUUIDs addObject:uniqueDeviceName];

                [discovery ssdpBrowser:nil didFindService:mockService];
                expect(discovery.availableDevices.count).to.equal(0);

                OCMVerifyAll(mockParser);
            });


            it(@"should inform delegate", ^{
                OCMExpect([mockDelegate discovery:discovery didFindDevice:mockDevice]);

                [discovery ssdpBrowser:nil didFindService:mockService];

                OCMVerifyAll(mockDelegate);
            });
        });

        describe(@"when a parse error occurs", ^{
            it(@"should not try and add a device", ^{
                OCMStub([mockParser parseURL:url withCompletion:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
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

            __block UPPBasicDevice *device;

            beforeEach(^{
                // OCMock objects do not respond to predicate matches, so use a
                // real device instead
                device = [UPPBasicDevice new];
                device.udn = uniqueDeviceName;
                [discovery.devices addObject:device];
            });

            it(@"should remove devices", ^{
                OCMStub([mockService uniqueServiceName]).andReturn(uniqueServiceName);

                [discovery ssdpBrowser:nil didRemoveService:mockService];

                expect(discovery.availableDevices.count).to.equal(0);
            });

            it(@"should not remove devices if no match found", ^{
                OCMStub([mockService uniqueServiceName]).andReturn(@"baz::quz");

                [discovery ssdpBrowser:nil didRemoveService:mockService];

                expect(discovery.availableDevices.count).to.equal(1);
            });

            it(@"should inform delegate", ^{
                OCMStub([mockService uniqueServiceName]).andReturn(uniqueServiceName);
                OCMExpect([mockDelegate discovery:discovery didRemoveDevice:device]);

                [discovery ssdpBrowser:nil didRemoveService:mockService];

                OCMVerifyAll(mockDelegate);
            });
        });
    });

    it(@"should have a browser", ^{
        SSDPServiceBrowser *browser = discovery.browser;
        expect(browser).toNot.beNil();
        expect(browser.delegate).to.equal(discovery);
    });
});

SpecEnd
