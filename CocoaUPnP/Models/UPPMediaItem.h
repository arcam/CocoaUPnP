// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPMediaItemArtwork.h"
#import "UPPMediaItemProtocol.h"

@class UPPMediaItemResource;

/**
 This class defines a universal media item object. The object may describe
 a music track, an album, a podcast etc. The UPnP class of the object can be
 queried by calling the `objectClass` property.
 */
@interface UPPMediaItem : NSObject <NSCoding, NSCopying, UPPMediaItemProtocol>

#pragma mark - Properties

/**
 The album title for the item
 */
@property (copy, nonatomic, nullable) NSString *albumTitle;

/**
 The artist of the item
 */
@property (copy, nonatomic, nullable) NSString *artist;

/**
 Any additional artists supplied by the server
 */
@property (copy, nonatomic, nullable) NSDictionary<NSString *, NSString *> *artistRoles;

/**
 The date of the media item. E.g. the album release year
 */
@property (copy, nonatomic, nullable) NSString *date;

/**
 The genre of the media item
 */
@property (copy, nonatomic, nullable) NSString *genre;

/**
 If the media item is a container, e.g. a music album
 */
@property (nonatomic) BOOL isContainer;

/**
 Number of items in container
 */
@property (copy, nonatomic, nullable) NSString *childCount;

/**
 The UPnP class of the media item, e.g. `object.container.album.musicAlbum`
 */
@property (copy, nonatomic, nonnull) NSString *objectClass;

/**
 The object identifier of the media item
 */
@property (copy, nonatomic, nonnull) NSString *objectID;

/**
 The original track number of the media item
 */
@property (copy, nonatomic, nullable) NSString *trackNumber;

/**
 The parents object identifier
 */
@property (copy, nonatomic, nonnull) NSString *parentID;

/**
 An array of media resources
 */
@property (copy, nonatomic, nullable) NSArray <UPPMediaItemResource *> *resources;

/**
 The media item title
 */
@property (copy, nonatomic, nonnull) NSString *itemTitle;

/**
 A string representation of the album artwork URL
 @warning This is a legacy property - it will be set to the first URL in the
 `artworkResources` array.
 */
@property (copy, nonatomic, nullable) NSString *albumArtURLString;

/**
 A collection of album artwork resources
 */
@property (copy, nonatomic, nonnull) NSArray <UPPMediaItemArtwork *> *artworkResources;

/**
 An integer describing the tracks total duration in seconds.
 @warning This value is scraped from the duration of the Media Item's resources.
 This should be accurate enough for the simple display of data.
 */
@property (assign, nonatomic) NSInteger durationInSeconds;

#pragma mark - Instance Methods

/**
 The album artwork URL

 @return Returns an `NSURL` for the album or song artwork
 */
- (nullable NSURL *)albumArtURL;

/**
 Return the first resource `duration` value that is not nil
 */
- (nullable NSString *)duration;

/**
 Return the first media item resource that is not an image.
 */
- (nullable UPPMediaItemResource *)firstPlayableResource;

@end
