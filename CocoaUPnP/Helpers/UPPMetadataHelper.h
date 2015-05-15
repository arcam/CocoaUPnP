// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPMediaItem;

/**
 A simple function to create `DIDL-Lite` string representation of a media item.
 */
extern NSString * UPPMetadataForItem (UPPMediaItem *item);