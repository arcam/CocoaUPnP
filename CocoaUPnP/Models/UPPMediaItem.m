
#import "UPPMediaItem.h"

@implementation UPPMediaItem

- (NSURL *)albumArtURL
{
    return [NSURL URLWithString:self.albumArtURLString];
}

@end
