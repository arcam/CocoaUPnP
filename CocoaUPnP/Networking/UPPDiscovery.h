// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "SSDPServiceBrowser.h"
#import "UPPDeviceParser.h"

@class UPPDiscovery;

/**
 By confirming to `UPPDiscoveryDelegate`, a class can be informed whenever a
 UPnP device is found or removed.
 */
@protocol UPPDiscoveryDelegate <NSObject>
@optional

/**
 Inform class that a new UPnP device was found: either through responding to an
 `M-SEARCH` request or from periodic `NOTIFY` messaging to the multicast address.
 
 @param discovery The discovery instance calling the protocol method.
 @param device    The device that was found.
 */
- (void)discovery:(UPPDiscovery *)discovery didFindDevice:(UPPBasicDevice *)device;

/**
 Inform delegate that a UPnP device was removed, usually by the device sending a
 `byebye` message.
 
 @param discovery The discovery instance calling the protocol method.
 @param device    The device that was removed.
 */
- (void)discovery:(UPPDiscovery *)discovery didRemoveDevice:(UPPBasicDevice *)device;
@end

/**
 This class is responsible for searching for devices over SSDP. It also watches
 for any `NOTIFY` messages sent by unknown devices.
 */
@interface UPPDiscovery : NSObject <SSDPServiceBrowserDelegate>

/**
 A parser which will parse headers as they come in.
 */
@property (strong, nonatomic) UPPDeviceParser *parser;

/**
 The object who wished to be informed of add/remove device notices.
 */
@property (weak, nonatomic) id <UPPDiscoveryDelegate> delegate;

/**
 An instance of `SSDPServiceBrowser`. Lazily instantiated for better testing.
 */
@property (strong, nonatomic) SSDPServiceBrowser *browser;

/**
 Creates and returns a common shared instance.
 */
+ (UPPDiscovery *)sharedInstance;

/**
 Start searching for services matching the service type
 
 @param services The service type to search for. For example, `ssdp:all`
 */
- (void)startBrowsingForServices:(NSString *)services;

/**
 Return an array of all currently known devices.
 */
- (NSArray *)availableDevices;

@end
