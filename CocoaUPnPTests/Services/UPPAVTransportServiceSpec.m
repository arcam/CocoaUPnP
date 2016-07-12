// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import "MockFailSessionManager.h"
#import "NetworkTestHelpers.h"

SpecBegin(UPPAVTransportService)

describe(@"UPPAVTransportService", ^{

    __block UPPAVTransportService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;
    __block UPPResponseBlock noCompletion;

    beforeEach(^{
        service = [[UPPAVTransportService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:AVTransport:1";

        sessionManager = OCMClassMock([UPPSessionManager class]);
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        instanceId = @"0";

        // We exit early for all GET requests that do not provide a completion
        // block, so explicity create an "empty" completion block.
        noCompletion = ^(NSDictionary *d, NSError *e) {};
    });

    describe(@"when setting current transport URI", ^{
        __block NSString *currentURI = @"currentURI";
        __block NSString *currentURIMetaData = @"currentURIMetaData";
        __block NSArray *keys;

        beforeEach(^{
            keys = @[ @"InstanceID", @"CurrentURI", @"CurrentURIMetaData" ];
        });

        it(@"should send parameters", ^{
            NSArray *v = @[ instanceId, currentURI, currentURIMetaData ];
            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setAVTransportURI:currentURI
                    currentURIMetaData:currentURIMetaData
                            instanceID:instanceId
                               success:nil];

            [sessionManager verify];
        });

        it(@"should not raise an exception with no metadata", ^{
            NSArray *v = @[ instanceId, currentURI, @"" ];
            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setAVTransportURI:currentURI
                    currentURIMetaData:nil
                            instanceID:instanceId
                               success:nil];

            [sessionManager verify];
        });

        it(@"should return set an error when call fails", ^{
            service.sessionManager = [[MockFailSessionManager alloc] init];

            [service setAVTransportURI:currentURI currentURIMetaData:currentURIMetaData instanceID:instanceId success:^(BOOL success, NSError *error) {
                expect(error).toNot.beNil();
                expect(error.code).to.equal(MockFailSessionErrorCode);
            }];
        });
    });

    describe(@"when setting next transport URI", ^{
        __block NSString *nextURI;
        __block NSArray *keys;

        beforeEach(^{
            nextURI = @"nextURI";
            keys = @[ @"InstanceID", @"NextURI", @"NextURIMetaData" ];
        });

        it(@"should send parameters", ^{
            NSString *nextURIMetaData = @"nextURIMetaData";
            NSArray *v = @[ instanceId, nextURI, nextURIMetaData ];
            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetNextAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setNextAVTransportURI:nextURI
                           nextURIMetaData:nextURIMetaData
                                instanceID:instanceId
                                   success:nil];

            [sessionManager verify];
        });

        it(@"should not raise an exception with nil metadata", ^{
            NSArray *v = @[ instanceId, nextURI, @"" ];
            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetNextAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setNextAVTransportURI:nextURI
                           nextURIMetaData:nil
                                instanceID:instanceId
                                   success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when requesting media information", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetMediaInfo",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service mediaInfoWithInstanceID:instanceId completion:noCompletion];
        });

        it(@"should return an error when call fails", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetMediaInfo",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectAndReturnErrorWithParams(expectedParams, sessionManager, url);

            [service mediaInfoWithInstanceID:instanceId completion:^(NSDictionary *mediaInfo, NSError *error) {
                expect(mediaInfo).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeGeneric);
            }];

            [sessionManager verify];
        });
    });

    describe(@"when getting transport information", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetTransportInfo",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service transportInfoWithInstanceID:instanceId completion:noCompletion];
        });
    });

    describe(@"when getting position information", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetPositionInfo",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service positionInfoWithInstanceID:instanceId completion:noCompletion];
        });
    });

    describe(@"when getting device capabilities", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetDeviceCapabilities",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service deviceCapabilitiesWithInstanceID:instanceId completion:noCompletion];
        });
    });

    describe(@"when getting transport settings", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetTransportSettings",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service transportSettingsWithInstanceID:instanceId completion:noCompletion];
        });
    });

    describe(@"when stopping playback", ^{
        it(@"should send stop command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Stop",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service stopWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when starting playback", ^{
        it(@"should send play command", ^{
            NSArray *k = @[ @"InstanceID", @"Speed" ];
            NSArray *v = @[ instanceId, @"1" ];
            UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Play",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service playWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });

        it(@"should send play command with speed", ^{
            NSArray *k = @[ @"InstanceID", @"Speed" ];
            NSArray *v = @[ instanceId, @"2" ];
            UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Play",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service playWithInstanceID:instanceId speed:@"2" success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when pausing playback", ^{
        it(@"should send pause command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Pause",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service pauseWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when recording", ^{
        it(@"should send record command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Record",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service recordWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when seeking playback", ^{
        it(@"should send seek command", ^{
            NSString *unit = @"REL_TIME";
            NSString *target = @"01:02:04.0000";
            NSArray *k = @[ @"InstanceID", @"Unit", @"Target" ];
            NSArray *v = @[ instanceId, unit, target ];
            UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Seek",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setSeekWithInstanceID:instanceId
                                      unit:unit
                                    target:target
                                   success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when sending next", ^{
        it(@"should send next command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Next",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service nextWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when sending previous", ^{
        it(@"should send previous command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Previous",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service previousWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when setting play mode", ^{
        it(@"should send play mode command", ^{
            NSString *newPlayMode = @"SHUFFLE";
            NSArray *k = @[ @"InstanceID", @"NewPlayMode" ];
            NSArray *v = @[ instanceId, newPlayMode ];
            UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetPlayMode",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setPlayMode:newPlayMode
                  withInstanceID:instanceId
                         success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when setting record mode", ^{
        it(@"should send record mode command", ^{
            NSString *newRecordMode = @"0:BASIC";
            NSArray *k = @[ @"InstanceID", @"NewRecordMode" ];
            NSArray *v = @[ instanceId, newRecordMode ];
            UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetRecordMode",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service setRecordMode:(NSString *)newRecordMode
                    withInstanceID:instanceId
                           success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when getting transport actions", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetCurrentTransportActions",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceParams() };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service transportActionsWithInstanceID:instanceId completion:noCompletion];
        });
    });
});

SpecEnd
