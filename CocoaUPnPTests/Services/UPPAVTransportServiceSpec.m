// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "MockFailSessionManager.h"
#import "UPPConstants.h"
#import "UPPError.h"
#import "NetworkTestHelpers.h"

SpecBegin(UPPAVTransportService)

describe(@"UPPAVTransportService", ^{

    __block UPPAVTransportService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;

    beforeEach(^{
        service = [[UPPAVTransportService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:AVTransport:1";

        sessionManager = OCMClassMock([UPPSessionManager class]);
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        instanceId = @"0";
    });

    describe(@"when setting current transport URI", ^{
        __block NSString *currentURI;
        __block NSString *currentURIMetaData;

        beforeEach(^{
            currentURI = @"currentURI";
            currentURIMetaData = @"currentURIMetaData";
        });

        it(@"should send parameters", ^{
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"CurrentURI": currentURI,
                                      @"CurrentURIMetaData": currentURIMetaData };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            [service setAVTransportURI:currentURI
                    currentURIMetaData:currentURIMetaData
                            instanceID:instanceId
                               success:nil];

            [sessionManager verify];
        });

        it(@"should not raise an exception with no metadata", ^{
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"CurrentURI": currentURI,
                                      @"CurrentURIMetaData": @"" };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

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

        beforeEach(^{
            nextURI = @"nextURI";
        });

        it(@"should send parameters", ^{
            NSString *nextURIMetaData = @"nextURIMetaData";

            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"NextURI": nextURI,
                                      @"NextURIMetaData": nextURIMetaData };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetNextAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            [service setNextAVTransportURI:nextURI
                           nextURIMetaData:nextURIMetaData
                                instanceID:instanceId
                                   success:nil];

            [sessionManager verify];
        });

        it(@"should not raise an exception with nil metadata", ^{
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"NextURI": nextURI,
                                      @"NextURIMetaData": @"" };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetNextAVTransportURI",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

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
                                              UPPParametersKey: InstanceDict() };

            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service mediaInfoWithInstanceID:instanceId completion:^(NSDictionary *mediaInfo, NSError *error) {
                expect(mediaInfo[@"Hello"]).to.equal(@"World");
            }];
        });

        it(@"should return an error when call fails", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetMediaInfo",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyFailedGetPostWithParams(expectedParams, sessionManager, url);

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
                                              UPPParametersKey: InstanceDict() };

            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service transportInfoWithInstanceID:instanceId completion:^(NSDictionary *dict, NSError *error) {
                expect(dict[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];
        });
    });

    describe(@"when getting position information", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetPositionInfo",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service positionInfoWithInstanceID:instanceId completion:^(NSDictionary *dict, NSError *error) {
                expect(dict[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];
        });
    });

    describe(@"when getting device capabilities", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetDeviceCapabilities",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service deviceCapabilitiesWithInstanceID:instanceId completion:^(NSDictionary *dict, NSError *error) {
                expect(dict[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];
        });
    });

    describe(@"when getting transport settings", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetTransportSettings",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service transportSettingsWithInstanceID:instanceId completion:^(NSDictionary *dict, NSError *error) {
                expect(dict[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];
        });
    });

    describe(@"when stopping playback", ^{
        it(@"should send stop command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Stop",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            [service stopWithInstanceID:instanceId success:nil];

            [sessionManager verify];
        });
    });

    describe(@"when starting playback", ^{
        it(@"should send play command", ^{
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"Speed": @"1" };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Play",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service playWithInstanceID:instanceId success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });

        it(@"should send play command with speed", ^{
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"Speed": @"2" };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Play",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service playWithInstanceID:instanceId speed:@"2" success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when pausing playback", ^{
        it(@"should send pause command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Pause",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service pauseWithInstanceID:instanceId success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when recording", ^{
        it(@"should send record command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Record",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service recordWithInstanceID:instanceId success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when seeking playback", ^{
        it(@"should send seek command", ^{
            NSString *unit = @"REL_TIME";
            NSString *target = @"01:02:04.0000";

            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"Unit": unit,
                                      @"Target": target };
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Seek",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service setSeekWithInstanceID:instanceId
                                      unit:unit
                                    target:target
                                   success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when sending next", ^{
        it(@"should send next command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Next",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service nextWithInstanceID:instanceId success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when sending previous", ^{
        it(@"should send previous command", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Previous",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service previousWithInstanceID:instanceId success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when setting play mode", ^{
        it(@"should send play mode command", ^{
            NSString *newPlayMode = @"SHUFFLE";
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"NewPlayMode": newPlayMode };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetPlayMode",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service setPlayMode:(NSString *)newPlayMode
                  withInstanceID:instanceId
                         success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when setting record mode", ^{
        it(@"should send record mode command", ^{
            NSString *newRecordMode = @"0:BASIC";
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"NewRecordMode": newRecordMode };

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"SetRecordMode",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            VerifyPostWithParams(expectedParams, sessionManager, url);

            NSError *error = nil;
            [service setRecordMode:(NSString *)newRecordMode
                    withInstanceID:instanceId
                           success:nil];

            [sessionManager verify];
            expect(error).to.beNil();
        });
    });

    describe(@"when getting transport actions", ^{
        it(@"should return information", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetCurrentTransportActions",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: InstanceDict() };

            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service transportActionsWithInstanceID:instanceId completion:^(NSDictionary *dict, NSError *error) {
                expect(dict[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];
        });
    });
});

SpecEnd
