// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

/**
 This class contains all the network calls needed for the UPnP [AVTransport1
 service](http://upnp.org/specs/av/UPnP-av-ContentDirectory-v1-Service.pdf).
 */
@interface UPPContentDirectoryService : UPPBasicService

/**
 Get the devices search capabilities
 
 @param completion A completion block which returns the parsed response, or an
 */
- (void)searchCapabilitiesWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion;

/**
 Get the devices sort capabilities
 
 @param completion A completion block which returns the parsed response, or an
 */
- (void)sortCapabilitiesWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion;

@end
