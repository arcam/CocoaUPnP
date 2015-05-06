// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaServerDevice.h"
#import "UPPContentDirectoryService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"

@interface UPPMediaServerDevice ()
@property (strong, nonatomic) UPPContentDirectoryService *contentDirectoryService;
@property (strong, nonatomic) UPPConnectionManagerService *connectionManagerService;
@property (strong, nonatomic) UPPAVTransportService *avTransportService;
@end

@implementation UPPMediaServerDevice

+ (instancetype)mediaServerWithURN:(NSString *)urn baseURL:(NSURL *)baseURL
{
    UPPMediaServerDevice *device = [[UPPMediaServerDevice alloc] init];
    device.deviceType = urn;
    device.baseURL = baseURL;
    
    return device;
}

- (UPPContentDirectoryService *)contentDirectoryService
{
    if (!_contentDirectoryService) {
        NSString *namespace = @":service:ContentDirectory:";
        UPPBasicService *service = [self serviceForNameSpace:namespace];
        
        if (!service) {
            return nil;
        }
        
        _contentDirectoryService = [[UPPContentDirectoryService alloc] init];
        _contentDirectoryService.controlURL = [self controlURLForService:service];
    }
    return _contentDirectoryService;
}

- (UPPConnectionManagerService *)connectionManagerService
{
    if (!_connectionManagerService) {
        NSString *namespace = @":service:ConnectionManager:";
        UPPBasicService *service = [self serviceForNameSpace:namespace];
        
        if (!service) {
            return nil;
        }
        
        _connectionManagerService = [[UPPConnectionManagerService alloc] init];
        _connectionManagerService.controlURL = [self controlURLForService:service];
    }
    return _connectionManagerService;
}

- (UPPAVTransportService *)avTransportService
{
    if (!_avTransportService) {
        NSString *namespace = @":service:AVTransport:";
        UPPBasicService *service = [self serviceForNameSpace:namespace];
        
        if (!service) {
            return nil;
        }
        
        _avTransportService = [[UPPAVTransportService alloc] init];
        _avTransportService.controlURL = [self controlURLForService:service];
    }
    return _avTransportService;
}

- (NSURL *)controlURLForService:(UPPBasicService *)service
{
    if (!service.controlURL) {
        return nil;
    }
    NSString *component = service.controlURL.absoluteString;
    return [self.baseURL URLByAppendingPathComponent:component];
}

- (UPPBasicService *)serviceForNameSpace:(NSString *)namespace
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameSpace contains %@", namespace];
    NSArray *filtered = [self.services filteredArrayUsingPredicate:predicate];
    
    if (filtered.count == 0) {
        return nil;
    }
    
    return [filtered firstObject];
}

@end
