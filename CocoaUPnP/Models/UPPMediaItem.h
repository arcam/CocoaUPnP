#import <Foundation/Foundation.h>
#import "UPPMediaItemProtocol.h"

/**
 *  This class defines a universal media item object. The object may describe
 *  a music track, an album, a podcast etc. The UPnP class of the object can be
 *  queried by calling the `objectClass` property.
 */
@interface UPPMediaItem : NSObject <UPPMediaItemProtocol>

#pragma mark - Properties

/**
 *  The album title for the item
 */
@property (copy, nonatomic) NSString *albumTitle;

/**
 *  The artist of the item
 */
@property (copy, nonatomic) NSString *artist;

/**
 *  The number of audio channels
 */
@property (copy, nonatomic) NSString *numberOfAudioChannels;

/**
 *  The bitrate of the resource
 */
@property (copy, nonatomic) NSString *bitrate;

/**
 *  The date of the media item. E.g. the album release year
 */
@property (copy, nonatomic) NSString *date;

/**
 *  The duration of the item in HH:MM:SS
 */
@property (copy, nonatomic) NSString *duration;

/**
 *  The sample frequency of the media item
 */
@property (copy, nonatomic) NSString *sampleFrequency;

/**
 *  The genre of the media item
 */
@property (copy, nonatomic) NSString *genre;

/**
 *  A string representing the icon URL
 */
@property (copy, nonatomic) NSString *iconURLString;

/**
 *  If the media item is a container, e.g. a music album
 */
@property (nonatomic) BOOL isContainer;

/**
 *  The UPnP class of the media item, e.g. `object.container.album.musicAlbum`
 */
@property (copy, nonatomic) NSString *objectClass;

/**
 *  The object identifier of the media item
 */
@property (copy, nonatomic) NSString *objectID;

/**
 *  The original track number of the media item
 */
@property (copy, nonatomic) NSString *trackNumber;

/**
 *  The parents object identifier
 */
@property (copy, nonatomic) NSString *parentID;

/**
 *  The protocol info string of the media item
 */
@property (copy, nonatomic) NSString *protocolInfo;

/**
 *  An array of media resources
 */
@property (copy, nonatomic) NSArray *resources;

/**
 *  The size in bytes of the media item
 */
@property (copy, nonatomic) NSString *itemSize;

/**
 *  The media item title
 */
@property (copy, nonatomic) NSString *itemTitle;

/**
 *  A string representation of the album artwork URL
 */
@property (copy, nonatomic) NSString *albumArtURLString;

/**
 *  A string representation of the media item URL
 */
@property (copy, nonatomic) NSString *resourceURLString;

#pragma mark - Instance Methods

/**
 *  The media items icon URL
 *
 *  @return Returns an `NSURL` for the icon
 */
- (NSURL *)iconURL;

/**
 *  The album artwork URL
 *
 *  @return Returns an `NSURL` for the album or song artwork
 */
- (NSURL *)albumArtURL;

/**
 *  The URL for the media item resource
 *
 *  @return Returns an `NSURL` for the item
 */
- (NSURL *)resourceURL;

@end
