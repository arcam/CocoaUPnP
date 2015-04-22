// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPSessionManager.h"

extern const NSInteger MockFailSessionErrorCode;

/**
 A subclass of `UPPSessionManager` which always calls the failure block on each
 network call.
 */
@interface MockFailSessionManager : UPPSessionManager

@end
