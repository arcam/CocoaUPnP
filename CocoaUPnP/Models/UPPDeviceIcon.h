// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class defines a device's icon object
 */
@interface UPPDeviceIcon : NSObject <NSCoding>

/**
 The mime type of the icon
 */
@property (copy, nonatomic, nonnull) NSString *mimetype;

/**
 The width in pixels of the icon
 */
@property (copy, nonatomic, nonnull) NSNumber *width;

/**
 The height in pixels of the icon
 */
@property (copy, nonatomic, nonnull) NSNumber *height;

/**
 The colour depth of the icon
 */
@property (copy, nonatomic, nonnull) NSNumber *depth;

/**
 The URL of the icon
 */
@property (copy, nonatomic, nonnull) NSString *url;

@end
