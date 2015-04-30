// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "SSDPServiceBrowser.h"
#import "UPPDeviceParser.h"

@interface UPPDiscovery : NSObject <SSDPServiceBrowserDelegate>

@property (strong, nonatomic) UPPDeviceParser *parser;

+ (UPPDiscovery *)sharedInstance;
- (NSArray *)availableDevices;

@end
