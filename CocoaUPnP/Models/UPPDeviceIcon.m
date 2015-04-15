
#import "UPPDeviceIcon.h"

@implementation UPPDeviceIcon

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p, mimeType: %@, width: %@, height: %@, depth: %@, url: %@>",
            NSStringFromClass([self class]), self, self.mimetype, self.width,
            self.height, self.depth, self.url];
}

@end
