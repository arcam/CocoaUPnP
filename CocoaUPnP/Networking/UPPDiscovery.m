// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDiscovery.h"
#import "SSDPService.h"
#import "UPPSessionManager.h"
#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"

@interface UPPDiscovery ()
@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) NSMutableArray *unparsedUUIDs;
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

- (void)startBrowsingForServices:(NSString *)services
{
    [self.browser startBrowsingForServiceTypes:services];
}

- (void)stopBrowsingForServices
{
    [self.browser stopBrowsingForServices];
    self.browser = nil;
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)devices
{
    if (!_devices) {
        _devices = [NSMutableArray array];
    }
    return _devices;
}

- (NSMutableArray *)unparsedUUIDs
{
    if (!_unparsedUUIDs) {
        _unparsedUUIDs = [NSMutableArray array];
    }
    return _unparsedUUIDs;
}

- (SSDPServiceBrowser *)browser
{
    if (!_browser) {
        _browser = [[SSDPServiceBrowser alloc] init];
        _browser.delegate = self;
    }
    return _browser;
}

#pragma mark - SSDPServiceBrowserDelegate

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service
{
    if ([self deviceKnown:[self udnForService:service]]) {
        return;
    }

    [self parseService:service];
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service
{
    NSString *uniqueDeviceName = [self udnForService:service];
    NSArray *devices = [self devicesMatchingName:uniqueDeviceName];

    for (UPPBasicDevice *device in devices) {
        [self.devices removeObject:device];
        if ([self.delegate respondsToSelector:@selector(discovery:didRemoveDevice:)]) {
            [self.delegate discovery:self didRemoveDevice:device];
        }
    }
}

- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error
{
    NSLog(@"Could not start browsing for services: %@", error);
}

#pragma mark - Private Methods

- (void)parseService:(SSDPService *)service
{
    NSString *udn = [self udnForService:service];

    if (!udn) {
        return;
    }

    [self.unparsedUUIDs addObject:udn];
    [UPPDeviceParser parseURL:service.xmlLocation withCompletion:^(UPPBasicDevice *device, NSError *error) {
        if (device) {
            [self addDevice:device];
        }
    }];
}

- (void)addDevice:(UPPBasicDevice *)device
{
    [self.devices addObject:device];

    if ([self.delegate respondsToSelector:@selector(discovery:didFindDevice:)]) {
        [self.delegate discovery:self didFindDevice:device];
    }
}

- (NSArray *)devicesMatchingName:(NSString *)uniqueDeviceName
{
    if (!uniqueDeviceName) {
        return nil;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"udn == %@",
                              uniqueDeviceName];
    return [self.devices filteredArrayUsingPredicate:predicate];
}

- (BOOL)deviceKnown:(NSString *)deviceIdentifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@",
                              deviceIdentifier];
    NSArray *results = [self.unparsedUUIDs filteredArrayUsingPredicate:predicate];

    if (results.count > 0) {
        return YES;
    }

    predicate = [NSPredicate predicateWithFormat:@"udn == %@", deviceIdentifier];
    results = [self.devices filteredArrayUsingPredicate:predicate];

    if (results.count > 0) {
        return YES;
    }

    return NO;
}

- (NSString *)udnForService:(SSDPService *)service
{
    NSString *usn = service.uniqueServiceName;
    NSArray *array = [usn componentsSeparatedByString:@"::"];
    return [array firstObject];
}

@end
