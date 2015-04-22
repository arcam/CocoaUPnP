// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

@interface UPPContentDirectoryService : UPPBasicService

- (void)searchCapabilitiesWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion;

@end
