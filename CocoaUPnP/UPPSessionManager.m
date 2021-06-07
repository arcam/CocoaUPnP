// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPSessionManager.h"
#import "UPPRequestSerializer.h"
#import "UPPResponseSerializer.h"

@implementation UPPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];

    if (self) {
        self.requestSerializer = [UPPRequestSerializer serializer];
        self.responseSerializer = [UPPResponseSerializer serializer];
    }

    return self;
}

@end
