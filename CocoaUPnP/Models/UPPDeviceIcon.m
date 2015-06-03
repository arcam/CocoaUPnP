// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.mimetype = [decoder decodeObjectForKey:@"mimetype"];
        self.width = [decoder decodeObjectForKey:@"width"];
        self.height = [decoder decodeObjectForKey:@"height"];
        self.depth = [decoder decodeObjectForKey:@"depth"];
        self.url = [decoder decodeObjectForKey:@"url"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mimetype forKey:@"mimetype"];
    [encoder encodeObject:self.width forKey:@"width"];
    [encoder encodeObject:self.height forKey:@"height"];
    [encoder encodeObject:self.depth forKey:@"depth"];
    [encoder encodeObject:self.url forKey:@"url"];
}

@end
