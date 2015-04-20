// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPMediaItemProtocol.h"

/**
 This class defines a universal media item object. The object may describe
 a music track, an album, a podcast etc. The UPnP class of the object can be
 queried by calling the `objectClass` property.
 */
@interface UPPMediaItem : NSObject <UPPMediaItemProtocol>

#pragma mark - Properties

/**
 The album title for the item
 */
@property (copy, nonatomic) NSString *albumTitle;

/**
 The artist of the item
 */
@property (copy, nonatomic) NSString *artist;

/**
 The date of the media item. E.g. the album release year
 */
@property (copy, nonatomic) NSString *date;

/**
 The genre of the media item
 */
@property (copy, nonatomic) NSString *genre;

/**
 If the media item is a container, e.g. a music album
 */
@property (nonatomic) BOOL isContainer;

/**
 Number of items in container
 */
@property (copy, nonatomic) NSString *childCount;

/**
 The UPnP class of the media item, e.g. `object.container.album.musicAlbum`
 */
@property (copy, nonatomic) NSString *objectClass;

/**
 The object identifier of the media item
 */
@property (copy, nonatomic) NSString *objectID;

/**
 The original track number of the media item
 */
@property (copy, nonatomic) NSString *trackNumber;

/**
 The parents object identifier
 */
@property (copy, nonatomic) NSString *parentID;

/**
 An array of media resources
 */
@property (copy, nonatomic) NSArray *resources;

/**
 The media item title
 */
@property (copy, nonatomic) NSString *itemTitle;

/**
 A string representation of the album artwork URL
 */
@property (copy, nonatomic) NSString *albumArtURLString;

#pragma mark - Instance Methods

/**
 The album artwork URL
 
 @return Returns an `NSURL` for the album or song artwork
 */
- (NSURL *)albumArtURL;

@end
