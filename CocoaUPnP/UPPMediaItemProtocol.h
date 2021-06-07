// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

/**
 This protocol defines a series of methods that descibes a generic UPnP media
 item. The protocol definition allows you to pass in your own objects to the
 item parser.
 */
@protocol UPPMediaItemProtocol <NSObject>

/**
 The album title for the item
 */
- (NSString *)albumTitle;

/**
 The artist of the item
 */
- (NSString *)artist;

/**
 The date of the media item. E.g. the album release year
 */
- (NSString *)date;

/**
 The genre of the media item
 */
- (NSString *)genre;

/**
 If the media item is a container, e.g. a music album
 */
- (BOOL)isContainer;

/**
 The UPnP class of the media item, e.g. `object.container.album.musicAlbum`
 */
- (NSString *)objectClass;

/**
 The object identifier of the media item
 */
- (NSString *)objectID;

/**
 The original track number of the media item
 */
- (NSString *)trackNumber;

/**
 The parents object identifier
 */
- (NSString *)parentID;

/**
 An array of media resources
 */
- (NSArray *)resources;

/**
 The media item title - this could be the song title, or album title etc
 */
- (NSString *)itemTitle;

/**
 The album artwork URL

 @return Returns an `NSURL` for the album or song artwork
 */
- (NSURL *)albumArtURL;

@end