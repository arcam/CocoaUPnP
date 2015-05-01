// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "SSDPServiceBrowser.h"
#import "UPPDeviceParser.h"

@class UPPDiscovery;

@protocol UPPDiscoveryDelegate <NSObject>
@optional
- (void)discovery:(UPPDiscovery *)discovery didFindDevice:(UPPBasicDevice *)device;
- (void)discovery:(UPPDiscovery *)discovery didRemoveDevice:(UPPBasicDevice *)device;
@end

@interface UPPDiscovery : NSObject <SSDPServiceBrowserDelegate>

@property (strong, nonatomic) UPPDeviceParser *parser;
@property (weak, nonatomic) id <UPPDiscoveryDelegate> delegate;

+ (UPPDiscovery *)sharedInstance;
- (NSArray *)availableDevices;

@end
