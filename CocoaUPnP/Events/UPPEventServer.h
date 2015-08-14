// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "GCDWebServer.h"

extern const NSInteger UPPEventServerPort;

@interface UPPEventServer : NSObject
@property (strong, nonatomic) GCDWebServer *webServer;

- (void)startServer;

@end
