// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDiscovery.h"
#import "SSDPService.h"
#import "UPPSessionManager.h"
#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"
#import "UPPEventSubscriptionManager.h"

@interface UPPDiscovery ()
@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) NSMutableArray *unparsedUUIDs;
@property (strong, nonatomic) NSMutableSet *observers;
@property (strong, nonatomic) UPPDeviceParser *parser;
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

- (NSArray <UPPBasicDevice *>*)availableDevices
{
    return [self.devices copy];
}

- (void)forgetAllKnownDevices
{
    self.devices = [NSMutableArray array];
    self.unparsedUUIDs = [NSMutableArray array];
}

- (void)startBrowsingForServices:(NSString *)services
{
    [self.browser startBrowsingForServiceTypes:services];
}

- (void)stopBrowsingForServices
{
    [self.browser stopBrowsingForServices];
    // Setting browser to nil, causes Discovery to create a new browser when needed.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    self.browser = nil;
#pragma clang diagnostic pop
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

- (NSMutableSet *)observers
{
    if (!_observers) {
        _observers = [NSMutableSet set];
    }

    return _observers;
}

#pragma mark - Browser Discovery Delegate Methods

- (void)addBrowserObserver:(id<UPPDiscoveryDelegate>)observer
{
    [self.observers addObject:observer];
}

- (void)removeBrowserObserver:(id<UPPDiscoveryDelegate>)observer
{
    [self.observers removeObject:observer];
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
        NSArray *services = device.services;
        [[UPPEventSubscriptionManager sharedManager]
         removeSubscriptionsForServices:services
         deviceId:device.udn];

        [self.devices removeObject:device];

        for (id <UPPDiscoveryDelegate>delegate in [self.observers copy]) {
            if ([delegate respondsToSelector:@selector(discovery:didRemoveDevice:)]) {
                [delegate discovery:self didRemoveDevice:device];
            }
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

    NSURL *url = service.xmlLocation;

    if (!url) {
        return;
    }

    [self.unparsedUUIDs addObject:udn];

    if (_parser == nil) {
        _parser = [[UPPDeviceParser alloc] init];
    }

    [_parser parseURL:service.xmlLocation withCompletion:^(NSArray *devices, NSError *error) {
        [self.unparsedUUIDs removeObject:udn];
        if (devices) {
            for (UPPBasicDevice *device in devices) {
                [self addDevice:device];
            }
        }
    }];
}

- (void)addDevice:(UPPBasicDevice *)device
{
    if ([self deviceKnown:device.udn]) {
        return;
    }

    [self.devices addObject:device];

    for (id <UPPDiscoveryDelegate>delegate in [self.observers copy]) {
        if ([delegate respondsToSelector:@selector(discovery:didFindDevice:)]) {
            [delegate discovery:self didFindDevice:device];
        }
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
