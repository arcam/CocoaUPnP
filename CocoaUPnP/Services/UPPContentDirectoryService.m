// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPContentDirectoryService.h"

@implementation UPPContentDirectoryService

- (void)searchCapabilitiesWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }
    
    [self _sendPostRequestWithParameters:nil action:@"GetSearchCapabilities" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

@end
