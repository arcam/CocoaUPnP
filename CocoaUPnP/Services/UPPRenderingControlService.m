// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"
#import "UPPParameters.h"

@implementation UPPRenderingControlService

- (void)muteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    NSArray *keys = @[ @"InstanceID", @"Channel" ];
    NSString *ch = channel ?: @"Master";
    NSArray *values = @[ instanceId, ch ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"GetMute"
                              completion:completion];
}

- (void)setMute:(BOOL)mute withInstanceID:(NSString *)instanceId channel:(NSString *)channel success:(UPPSuccessBlock)successBlock
{
    NSArray *keys = @[ @"InstanceID", @"Channel", @"DesiredMute" ];
    NSString *ch = channel ?: @"Master";
    NSArray *values = @[ instanceId, ch, @(mute) ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetMute"
                                 success:successBlock];
}

- (void)volumeWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    NSArray *keys = @[ @"InstanceID", @"Channel" ];
    NSString *ch = channel ?: @"Master";
    NSArray *values = @[ instanceId, ch ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"GetVolume"
                              completion:completion];
}

- (void)setVolume:(NSNumber *)volume withInstanceID:(NSString *)instanceId channel:(NSString *)channel success:(UPPSuccessBlock)successBlock
{
    NSArray *keys = @[ @"InstanceID", @"Channel", @"DesiredVolume" ];
    NSString *ch = channel ?: @"Master";
    NSArray *values = @[ instanceId, ch, volume ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetVolume"
                                 success:successBlock];
}

@end
