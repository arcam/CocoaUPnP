// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDiscovery.h"

@interface UPPDiscovery ()
@property (strong, nonatomic) NSMutableArray *devices;
@end

@implementation UPPDiscovery

+ (UPPDiscovery *)sharedInstance
{
    static UPPDiscovery *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UPPDiscovery alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray *)availableDevices
{
    return [self.devices copy];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)devices
{
    if (!_devices) {
        _devices = [NSMutableArray array];
    }
    return _devices;
}

#pragma mark - SSDPServiceBrowserDelegate

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service
{
    [self.devices addObject:service];
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service
{
    [self.devices removeObject:service];
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error
{
    NSLog(@"Could not start browsing for services: %@", error);
}

@end
