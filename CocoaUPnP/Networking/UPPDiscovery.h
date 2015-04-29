// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "SSDPServiceBrowser.h"

@interface UPPDiscovery : NSObject <SSDPServiceBrowserDelegate>

+ (UPPDiscovery *)sharedInstance;
- (NSArray *)availableDevices;

@end
