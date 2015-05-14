// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "PlaybackManager.h"
#import "UPPMediaRendererDevice.h"
#import "UPPAVTransportService.h"
#import "UPPMediaItem.h"
#import "UPPMediaItemResource.h"

@implementation PlaybackManager

- (void)playItem:(UPPMediaItem *)item
{
    UPPMediaItemResource *resource = [item.resources firstObject];
    UPPAVTransportService *avTransport = [self.renderer avTransportService];
    NSString *instanceId = @"0";
    NSError *error = nil;
    
    [avTransport setAVTransportURI:resource.resourceURLString
                currentURIMetaData:@""
                        instanceID:instanceId
                             error:&error];
    
    NSLog(@"error: %@", error);
    
    [avTransport playWithInstanceID:instanceId
                              error:&error];
    
    NSLog(@"error: %@", error);
}

@end
