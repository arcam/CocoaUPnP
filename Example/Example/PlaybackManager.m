// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "PlaybackManager.h"

#import <CocoaUPnP/CocoaUPnP.h>

@implementation PlaybackManager

- (void)playItem:(UPPMediaItem *)item
{
    UPPMediaItemResource *resource = [item.resources firstObject];
    UPPAVTransportService *avTransport = [self.renderer avTransportService];
    NSString *instanceId = @"0";

    [avTransport setAVTransportURI:resource.resourceURLString currentURIMetaData:UPPMetadataForItem(item) instanceID:instanceId success:^(BOOL success, NSError *error) {
        if (success) {
            [self sendPlayCommandWithInstanceID:instanceId];
        } else {
            NSLog(@"%s: Error setting transport URI: %@", __PRETTY_FUNCTION__, error);
        }
    }];
}

- (void)sendPlayCommandWithInstanceID:(NSString *)instanceId
{
    UPPAVTransportService *avTransport = [self.renderer avTransportService];
    [avTransport playWithInstanceID:instanceId success:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"%s: Error sending play command: %@", __PRETTY_FUNCTION__, error);
        }
    }];
}

@end
