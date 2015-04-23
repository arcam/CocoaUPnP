// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"

@implementation UPPRenderingControlService

- (void)muteWithInstanceID:(NSString *)instanceId completion:(void (^)(NSDictionary *, NSError *))completion
{
    [self muteWithInstanceID:instanceId channel:@"Master" completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

- (void)muteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }
    
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"Channel": channel };
    
    [self _sendPostRequestWithParameters:parameters action:@"GetMute" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

@end
