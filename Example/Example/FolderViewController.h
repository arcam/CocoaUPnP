// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <UIKit/UIKit.h>

@class UPPMediaServerDevice;
@class PlaybackManager;

@interface FolderViewController : UIViewController
@property (strong, nonatomic) UPPMediaServerDevice *device;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) PlaybackManager *playbackManager;
@end
