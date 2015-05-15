// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaItem.h"
#import "UPPMediaItemResource.h"

@implementation UPPMediaItem

- (NSURL *)albumArtURL
{
    return [NSURL URLWithString:self.albumArtURLString];
}

- (NSString *)duration
{
    if (self.resources.count == 0) {
        return nil;
    }

    for (UPPMediaItemResource *res in self.resources) {
        if (res.duration) {
            return res.duration;
        }
    }

    return nil;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, title: %@>",
            NSStringFromClass([self class]), self, self.itemTitle];
}

@end
