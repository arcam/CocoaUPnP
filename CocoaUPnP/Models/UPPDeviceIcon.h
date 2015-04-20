// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class defines a device's icon object
 */
@interface UPPDeviceIcon : NSObject

/**
 The mime type of the icon
 */
@property (copy, nonatomic) NSString *mimetype;

/**
 The width in pixels of the icon
 */
@property (copy, nonatomic) NSNumber *width;

/**
 The height in pixels of the icon
 */
@property (copy, nonatomic) NSNumber *height;

/**
 The colour depth of the icon
 */
@property (copy, nonatomic) NSNumber *depth;

/**
 The URL of the icon
 */
@property (copy, nonatomic) NSString *url;

@end
