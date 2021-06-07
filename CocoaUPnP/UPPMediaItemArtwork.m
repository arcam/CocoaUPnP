// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2016 Arcam. See LICENSE file.

#import "UPPMediaItemArtwork.h"

@implementation UPPMediaItemArtwork

- (instancetype _Nullable)initWithURL:(nonnull NSURL *)url profileId:(nullable NSString *)profileId
{
    if (self = [super init]) {
        self.url = url;
        self.profileId = profileId;
    }

    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.profileId = [decoder decodeObjectForKey:@"profileId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.profileId forKey:@"profileId"];
}

- (id)copyWithZone:(NSZone *)zone
{
    UPPMediaItemArtwork *newItem = [[[self class] alloc] init];
    newItem->_url = [_url copyWithZone:zone];
    newItem->_profileId = [_profileId copyWithZone:zone];

    return newItem;
}

@end
