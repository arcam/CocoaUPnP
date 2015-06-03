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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.albumTitle = [decoder decodeObjectForKey:@"albumTitle"];
        self.artist = [decoder decodeObjectForKey:@"artist"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.genre = [decoder decodeObjectForKey:@"genre"];
        self.isContainer = [decoder decodeBoolForKey:@"isContainer"];
        self.childCount = [decoder decodeObjectForKey:@"childCount"];
        self.objectClass = [decoder decodeObjectForKey:@"objectClass"];
        self.objectID = [decoder decodeObjectForKey:@"objectID"];
        self.trackNumber = [decoder decodeObjectForKey:@"trackNumber"];
        self.parentID = [decoder decodeObjectForKey:@"parentID"];
        self.resources = [decoder decodeObjectForKey:@"resources"];
        self.itemTitle = [decoder decodeObjectForKey:@"itemTitle"];
        self.albumArtURLString = [decoder decodeObjectForKey:@"albumArtURLString"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.albumTitle forKey:@"albumTitle"];
    [encoder encodeObject:self.artist forKey:@"artist"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.genre forKey:@"genre"];
    [encoder encodeBool:self.isContainer forKey:@"isContainer"];
    [encoder encodeObject:self.childCount forKey:@"childCount"];
    [encoder encodeObject:self.objectClass forKey:@"objectClass"];
    [encoder encodeObject:self.objectID forKey:@"objectID"];
    [encoder encodeObject:self.trackNumber forKey:@"trackNumber"];
    [encoder encodeObject:self.parentID forKey:@"parentID"];
    [encoder encodeObject:self.resources forKey:@"resources"];
    [encoder encodeObject:self.itemTitle forKey:@"itemTitle"];
    [encoder encodeObject:self.albumArtURLString forKey:@"albumArtURLString"];
}

@end
