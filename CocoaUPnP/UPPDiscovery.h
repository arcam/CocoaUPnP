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
- (void)discovery:(nonnull UPPDiscovery *)discovery didFindDevice:(nonnull UPPBasicDevice *)device;

/**
 Inform delegate that a UPnP device was removed, usually by the device sending a
 `byebye` message.

 @param discovery The discovery instance calling the protocol method.
 @param device    The device that was removed.
 */
- (void)discovery:(nonnull UPPDiscovery *)discovery didRemoveDevice:(nonnull UPPBasicDevice *)device;
@end

/**
 This class is responsible for searching for devices over SSDP. It also watches
 for any `NOTIFY` messages sent by unknown devices.
 */
@interface UPPDiscovery : NSObject <SSDPServiceBrowserDelegate>

/**
 An instance of `SSDPServiceBrowser`. Lazily instantiated for better testing.
 */
@property (strong, nonatomic, nonnull) SSDPServiceBrowser *browser;

/**
 Creates and returns a common shared instance.
 */
+ (nonnull UPPDiscovery *)sharedInstance;

/**
 Start searching for services matching the service type

 @param services The service type to search for. For example, `ssdp:all`
 */
- (void)startBrowsingForServices:(nullable NSString *)services;

/**
 Leave SSDP group and shut down discovery service
 */
- (void)stopBrowsingForServices;

/**
 Return an array of all currently known devices.
 */
- (nonnull NSArray <UPPBasicDevice *> *)availableDevices;

/**
 Clear the cache of known devices
 */
- (void)forgetAllKnownDevices;

/**
 Add an observer to be notified as devices are discovered or removed.

 @param observer An observer conforming to `UPPDiscoveryDelegate`.
 */
- (void)addBrowserObserver:(nonnull id<UPPDiscoveryDelegate>)observer;

/**
 Remove an observer from being notified as devices are discovered or removed.

 @param observer An observer conforming to `UPPDiscoveryDelegate`.
 */
- (void)removeBrowserObserver:(nonnull id<UPPDiscoveryDelegate>)observer;

@end
