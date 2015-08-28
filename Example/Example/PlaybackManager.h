// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPMediaRendererDevice;
@class UPPMediaItem;

@interface PlaybackManager : NSObject
@property (strong, nonatomic) UPPMediaRendererDevice *renderer;

- (void)playItem:(UPPMediaItem *)item;

@end
