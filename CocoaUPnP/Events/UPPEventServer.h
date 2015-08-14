// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "GCDWebServer.h"

extern const NSUInteger UPPEventServerPort;

@interface UPPEventServer : NSObject
@property (strong, nonatomic) GCDWebServer *webServer;

- (void)startServer;
- (NSURL *)eventServerCallbackURL;

@end
