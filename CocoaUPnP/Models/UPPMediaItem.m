
#import "UPPMediaItem.h"

@implementation UPPMediaItem

- (NSURL *)iconURL
{
    return [NSURL URLWithString:self.iconURLString];
}

- (NSURL *)albumArtURL
{
    return [NSURL URLWithString:self.albumArtURLString];
}

- (NSURL *)resourceURL
{
    return [NSURL URLWithString:self.resourceURLString];
}

@end
