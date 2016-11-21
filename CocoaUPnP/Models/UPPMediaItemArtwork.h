// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2016 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@interface UPPMediaItemArtwork : NSObject <NSCoding, NSCopying>

#pragma mark - Properties

/**
 The DLNA profile for the artwork.
 @see http://gupnp-av.sourcearchive.com/documentation/0.4.1/gupnp-dlna_8c-source.html
 */
@property (copy, nonatomic, nullable) NSString *profileId;

/**
 The URL of the artwork.
 */
@property (copy, nonatomic, nonnull) NSURL *url;

/**
 A convenience intialiser for `UPPMediaItemArtwork` objects.

 @param url       The URL of the artwork
 @param profileId An optional DLNA profile identifier

 @return A newly instantiated artwork model.
 */
- (instancetype _Nullable)initWithURL:(nonnull NSURL *)url profileId:(nullable NSString *)profileId;

@end
