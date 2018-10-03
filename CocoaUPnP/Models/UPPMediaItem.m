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

- (UPPMediaItemResource *)firstPlayableResource
{
    __block UPPMediaItemResource *resource;
    [self.resources enumerateObjectsUsingBlock:^(UPPMediaItemResource *r, NSUInteger idx, BOOL *stop) {
        NSString *protocolInfo = r.protocolInfo;
        if ([protocolInfo rangeOfString:@"image"].location == NSNotFound) {
            resource = r;
            *stop = YES;
        }
    }];

    return resource;
}

- (void)setArtworkResources:(NSArray<UPPMediaItemArtwork *> *)artworkResources
{
    if ([_artworkResources isEqualToArray:artworkResources]) {
        return;
    }

    _artworkResources = artworkResources;

    if (artworkResources.count == 0) {
        _albumArtURLString = nil;
        return;
    }

    _albumArtURLString = [artworkResources firstObject].url.absoluteString;
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
        self.trackNumber = [decoder decodeObjectForKey:@"trackNumber"];
        self.parentID = [decoder decodeObjectForKey:@"parentID"];
        self.resources = [decoder decodeObjectForKey:@"resources"];
        self.itemTitle = [decoder decodeObjectForKey:@"itemTitle"];
        self.durationInSeconds = [[decoder decodeObjectForKey:@"durationInSeconds"] integerValue];
        NSArray *artwork = [decoder decodeObjectForKey:@"artworkResources"];
        self.artworkResources = artwork ?: @[];
        // If restoring a legacy object, artwork resources will be `NULL` but
        // there will an `albumArtURLString`. Decode this last to prevent
        // `setArtworkResources` from clearing the value of `albumArtURLString`.
        self.albumArtURLString = [decoder decodeObjectForKey:@"albumArtURLString"];

        // If restoring an object with a faulty object ID, handle it
        id objectID = [decoder decodeObjectForKey:@"objectID"];
        if ([objectID isKindOfClass:[NSString class]]) {
            self.objectID = objectID;
        } else if ([objectID isKindOfClass:[NSNumber class]]) {
            self.objectID = [objectID stringValue];
        } else {
            self.objectID = @"123";
        }
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
    [encoder encodeObject:@(self.durationInSeconds) forKey:@"durationInSeconds"];
    [encoder encodeObject:self.artworkResources forKey:@"artworkResources"];
}

- (id)copyWithZone:(NSZone *)zone
{
    UPPMediaItem *newItem = [[[self class] alloc] init];
    newItem->_albumTitle = [_albumTitle copyWithZone:zone];
    newItem->_artist = [_artist copyWithZone:zone];
    newItem->_date = [_date copyWithZone:zone];
    newItem->_genre = [_genre copyWithZone:zone];
    newItem->_isContainer = _isContainer;
    newItem->_childCount = [_childCount copyWithZone:zone];
    newItem->_objectClass = [_objectClass copyWithZone:zone];
    newItem->_objectID = [_objectID copyWithZone:zone];
    newItem->_trackNumber = [_trackNumber copyWithZone:zone];
    newItem->_parentID = [_parentID copyWithZone:zone];
    newItem->_resources = [_resources copyWithZone:zone];
    newItem->_itemTitle = [_itemTitle copyWithZone:zone];
    newItem->_albumArtURLString = [_albumArtURLString copyWithZone:zone];
    newItem->_durationInSeconds = _durationInSeconds;
    newItem->_artworkResources = [_artworkResources copyWithZone:zone];

    return newItem;
}

@end
