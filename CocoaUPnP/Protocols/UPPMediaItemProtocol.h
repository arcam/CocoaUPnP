
/**
 *  This protocol defines a series of methods that descibes a generic UPnP media
 *  item. The protocol definition allows you to pass in your own objects to the
 *  item parser.
 */
@protocol UPPMediaItemProtocol <NSObject>

/**
 *  The album title for the item
 */
- (NSString *)albumTitle;

/**
 *  The artist of the item
 */
- (NSString *)artist;

/**
 *  The number of audio channels
 */
- (NSString *)numberOfAudioChannels;

/**
 *  The bitrate of the resource
 */
- (NSString *)bitrate;

/**
 *  The date of the media item. E.g. the album release year
 */
- (NSString *)date;

/**
 *  The duration of the item in HH:MM:SS
 */
- (NSString *)duration;

/**
 *  The sample frequency of the media item
 */
- (NSString *)sampleFrequency;

/**
 *  The genre of the media item
 */
- (NSString *)genre;

/**
 *  The media items icon URL
 *
 *  @return Returns an `NSURL` for the icon
 */
- (NSURL *)iconURL;

/**
 *  If the media item is a container, e.g. a music album
 */
- (BOOL)isContainer;

/**
 *  The UPnP class of the media item, e.g. `object.container.album.musicAlbum`
 */
- (NSString *)objectClass;

/**
 *  The object identifier of the media item
 */
- (NSString *)objectID;

/**
 *  The original track number of the media item
 */
- (NSString *)trackNumber;

/**
 *  The parents object identifier
 */
- (NSString *)parentID;

/**
 *  The protocol info string of the media item
 */
- (NSString *)protocolInfo;

/**
 *  An array of media resources
 */
- (NSArray *)resources;

/**
 *  The size in bytes of the media item
 */
- (NSString *)itemSize;

/**
 *  The media item title - this could be the song title, or album title etc
 */
- (NSString *)itemTitle;

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