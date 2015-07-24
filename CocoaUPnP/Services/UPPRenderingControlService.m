// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"

@implementation UPPRenderingControlService

- (void)muteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }

    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"Channel": channel ?: @"Master" };

    [self _sendPostRequestWithParameters:parameters action:@"GetMute" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)setMute:(BOOL)mute withInstanceID:(NSString *)instanceId channel:(NSString *)channel success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSNumber *muteNumber = mute ? @1 : @0;
    NSDictionary *parameters = @{ @"Channel": channel ?: @"Master",
                                  @"DesiredMute": muteNumber };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetMute"
                              parameters:parameters
                                 success:successBlock];
}

- (void)volumeWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }

    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"Channel": channel ?: @"Master" };

    [self _sendPostRequestWithParameters:parameters action:@"GetVolume" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)setVolume:(NSNumber *)volume withInstanceID:(NSString *)instanceId channel:(NSString *)channel success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSDictionary *parameters = @{ @"Channel": channel ?: @"Master" ,
                                  @"DesiredVolume": volume };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetVolume"
                              parameters:parameters
                                 success:successBlock];
}

@end
