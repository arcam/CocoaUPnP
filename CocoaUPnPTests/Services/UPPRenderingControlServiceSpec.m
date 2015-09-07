// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"
#import "UPPConstants.h"
#import "UPPSessionManager.h"
#import "NetworkTestHelpers.h"

SpecBegin(UPPRenderingControlService)

describe(@"UPPRenderingControlService", ^{

    __block UPPRenderingControlService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;

    beforeEach(^{
        service = [[UPPRenderingControlService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:RenderingControl:1";

        sessionManager = [OCMockObject mockForClass:[UPPSessionManager class]];
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        instanceId = @"0";
    });

    describe(@"mute status", ^{

        __block NSDictionary *params;
        __block NSDictionary *expectedParams;
        __block NSString *channel;

        beforeEach(^{
            channel = @"Master";
        });

        describe(@"when getting mute", ^{
            beforeEach(^{
                params = @{ @"InstanceID": instanceId,
                            @"Channel": channel };
                expectedParams = @{ UPPSOAPActionKey: @"GetMute",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                VerifyGetPostWithParams(expectedParams, sessionManager, url);

                [service muteWithInstanceID:instanceId channel:channel completion:^(NSDictionary *response, NSError *error) {
                    expect(response).toNot.beNil();
                    expect(error).to.beNil();
                }];

                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                VerifyGetPostWithParams(expectedParams, sessionManager, url);

                [service muteWithInstanceID:instanceId channel:nil completion:^(NSDictionary *response, NSError *error) {
                    expect(response).toNot.beNil();
                    expect(error).to.beNil();
                }];

                [sessionManager verify];
            });
        });

        describe(@"when setting mute", ^{
            beforeEach(^{
                params = @{ @"InstanceID": instanceId,
                            @"Channel": channel,
                            @"DesiredMute": @1 };

                expectedParams = @{ UPPSOAPActionKey: @"SetMute",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                VerifyPostWithParams(expectedParams, sessionManager, url);

                [service setMute:YES
                  withInstanceID:instanceId
                         channel:channel
                         success:nil];

                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                VerifyPostWithParams(expectedParams, sessionManager, url);

                [service setMute:YES
                  withInstanceID:instanceId
                         channel:channel
                         success:nil];

                [sessionManager verify];
            });

            it(@"should send required parameters with mute off", ^{
                params = @{ @"InstanceID": instanceId,
                            @"Channel": channel,
                            @"DesiredMute": @0 };

                expectedParams = @{ UPPSOAPActionKey: @"SetMute",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
                VerifyPostWithParams(expectedParams, sessionManager, url);

                [service setMute:NO
                  withInstanceID:instanceId
                         channel:nil
                         success:nil];

                [sessionManager verify];
            });
        });
    });

    describe(@"volume", ^{

        __block NSDictionary *params;
        __block NSDictionary *expectedParams;
        __block NSString *channel;

        beforeEach(^{
            channel = @"Master";
        });

        describe(@"when getting volume", ^{
            beforeEach(^{
                params = @{ @"InstanceID": instanceId,
                            @"Channel": channel };
                expectedParams = @{ UPPSOAPActionKey: @"GetVolume",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                VerifyGetPostWithParams(expectedParams, sessionManager, url);

                [service volumeWithInstanceID:instanceId channel:channel completion:^(NSDictionary *response, NSError *error) {
                    expect(response).toNot.beNil();
                    expect(error).to.beNil();
                }];

                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                VerifyGetPostWithParams(expectedParams, sessionManager, url);

                [service volumeWithInstanceID:instanceId channel:nil completion:^(NSDictionary *response, NSError *error) {
                    expect(response).toNot.beNil();
                    expect(error).to.beNil();
                }];

                [sessionManager verify];
            });
        });

        describe(@"when setting volume", ^{
            beforeEach(^{
                params = @{ @"InstanceID": instanceId,
                            @"Channel": channel,
                            @"DesiredVolume": @1 };

                expectedParams = @{ UPPSOAPActionKey: @"SetVolume",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                VerifyPostWithParams(expectedParams, sessionManager, url);

                [service setVolume:@1
                    withInstanceID:instanceId
                           channel:channel
                           success:nil];

                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                VerifyPostWithParams(expectedParams, sessionManager, url);

                [service setVolume:@1
                    withInstanceID:instanceId
                           channel:nil
                           success:nil];

                [sessionManager verify];
            });
        });
    });
});

SpecEnd
