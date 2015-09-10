// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"
#import "UPPConstants.h"
#import "UPPSessionManager.h"
#import "NetworkTestHelpers.h"
#import "UPPParameters.h"

SpecBegin(UPPRenderingControlService)

describe(@"UPPRenderingControlService", ^{

    __block UPPRenderingControlService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;
    __block void (^noCompletion)(NSDictionary *, NSError *);

    beforeEach(^{
        service = [[UPPRenderingControlService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:RenderingControl:1";

        sessionManager = [OCMockObject mockForClass:[UPPSessionManager class]];
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        instanceId = @"0";

        // We exit early for all GET requests that do not provide a completion
        // block, so explicity create an "empty" completion block.
        noCompletion = ^(NSDictionary *d, NSError *e) {};
    });

    describe(@"mute status", ^{

        __block NSDictionary *expectedParams;
        __block NSString *channel;

        beforeEach(^{
            channel = @"Master";
        });

        describe(@"when getting mute", ^{
            beforeEach(^{
                NSArray *k = @[ @"InstanceID", @"Channel" ];
                NSArray *v = @[ instanceId, channel ];
                UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];

                expectedParams = @{ UPPSOAPActionKey: @"GetMute",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);
                [service muteWithInstanceID:instanceId channel:channel completion:noCompletion];
                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);
                [service muteWithInstanceID:instanceId channel:nil completion:noCompletion];
                [sessionManager verify];
            });
        });

        describe(@"when setting mute", ^{
            beforeEach(^{
                NSArray *k = @[ @"InstanceID", @"Channel", @"DesiredMute" ];
                NSArray *v = @[ instanceId, channel, @YES ];
                UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
                expectedParams = @{ UPPSOAPActionKey: @"SetMute",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);

                [service setMute:YES
                  withInstanceID:instanceId
                         channel:channel
                         success:nil];

                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);

                [service setMute:YES
                  withInstanceID:instanceId
                         channel:channel
                         success:nil];

                [sessionManager verify];
            });

            it(@"should send required parameters with mute off", ^{
                NSArray *k = @[ @"InstanceID", @"Channel", @"DesiredMute" ];
                NSArray *v = @[ instanceId, channel, @NO ];
                UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];

                expectedParams = @{ UPPSOAPActionKey: @"SetMute",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
                ExpectGetWithParams(sessionManager, expectedParams, url);

                [service setMute:NO
                  withInstanceID:instanceId
                         channel:nil
                         success:nil];

                [sessionManager verify];
            });
        });
    });

    describe(@"volume", ^{

        __block NSDictionary *expectedParams;
        __block NSString *channel;

        beforeEach(^{
            channel = @"Master";
        });

        describe(@"when getting volume", ^{
            beforeEach(^{
                NSArray *k = @[ @"InstanceID", @"Channel" ];
                NSArray *v = @[ instanceId, channel ];
                UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
                expectedParams = @{ UPPSOAPActionKey: @"GetVolume",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);
                [service volumeWithInstanceID:instanceId channel:channel completion:noCompletion];
                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);
                [service volumeWithInstanceID:instanceId channel:nil completion:noCompletion];
                [sessionManager verify];
            });
        });

        describe(@"when setting volume", ^{
            beforeEach(^{
                NSArray *k = @[ @"InstanceID", @"Channel", @"DesiredVolume" ];
                NSArray *v = @[ instanceId, channel, @1 ];
                UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];
                expectedParams = @{ UPPSOAPActionKey: @"SetVolume",
                                    UPPNameSpaceKey: service.serviceType,
                                    UPPParametersKey: params };
            });

            it(@"should send required parameters", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);

                [service setVolume:@1
                    withInstanceID:instanceId
                           channel:channel
                           success:nil];

                [sessionManager verify];
            });

            it(@"should send required parameters with nil channel", ^{
                ExpectGetWithParams(sessionManager, expectedParams, url);

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
