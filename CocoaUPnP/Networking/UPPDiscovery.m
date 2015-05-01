// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDiscovery.h"
#import "SSDPService.h"
#import "UPPSessionManager.h"
#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"

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
    NSArray *devices = [self devicesMatchingService:service];
    
    if (devices.count > 0) { return; }
    
    [self parseService:service];
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service
{
    NSArray *devices = [self devicesMatchingService:service];
    [self.devices removeObjectsInArray:devices];
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error
{
    NSLog(@"Could not start browsing for services: %@", error);
}

#pragma mark - Private Methods

- (void)parseService:(SSDPService *)service
{
    [UPPDeviceParser parseURL:service.location withCompletion:^(UPPBasicDevice *device, NSError *error) {
        if (device) {
            [self addDevice:device];
        }
    }];
}

- (void)addDevice:(UPPBasicDevice *)device
{
    [self.devices addObject:device];
}

- (NSArray *)devicesMatchingService:(SSDPService *)service
{
    NSString *udn = service.uniqueServiceName;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"udn == %@", udn];
    return [self.devices filteredArrayUsingPredicate:predicate];
}

@end
