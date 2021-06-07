// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"
#import "UPPParameters.h"

@implementation UPPRenderingControlService

- (void)muteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(UPPResponseBlock)completion
{
    if (!instanceId || !completion) { return; }

    NSArray *keys = @[ @"InstanceID", @"Channel" ];
    NSArray *values = @[ instanceId, channel ?: @"Master" ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"GetMute"
                              completion:completion];
}

- (void)setMute:(BOOL)mute withInstanceID:(NSString *)instanceId channel:(NSString *)channel success:(UPPSuccessBlock)success
{
    if (!instanceId) { return; }

    NSArray *keys = @[ @"InstanceID", @"Channel", @"DesiredMute" ];
    NSArray *values = @[ instanceId, channel ?: @"Master", @(mute)];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetMute"
                                 success:success];
}

- (void)volumeWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(UPPResponseBlock)completion
{
    if (!instanceId || !completion) { return; }

    NSArray *keys = @[ @"InstanceID", @"Channel" ];
    NSArray *values = @[ instanceId ?: @"0",
                         channel ?: @"Master" ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"GetVolume"
                              completion:completion];
}

- (void)setVolume:(NSNumber *)volume withInstanceID:(NSString *)instanceId channel:(NSString *)channel success:(UPPSuccessBlock)success
{
    if (!volume || !instanceId) { return; }

    NSArray *keys = @[ @"InstanceID", @"Channel", @"DesiredVolume" ];
    NSArray *values = @[ instanceId, channel ?: @"Master", volume ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetVolume"
                                 success:success];
}

@end
