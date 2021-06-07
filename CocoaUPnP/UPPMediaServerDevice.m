// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaServerDevice.h"
#import "UPPContentDirectoryService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"
#import "UPPServiceDescription.h"

@interface UPPMediaServerDevice ()
@property (strong, nonatomic) UPPContentDirectoryService *contentDirectoryService;
@property (strong, nonatomic) UPPConnectionManagerService *connectionManagerService;
@property (strong, nonatomic) UPPAVTransportService *avTransportService;
@end

@implementation UPPMediaServerDevice

+ (instancetype)mediaServerWithURN:(NSString *)urn baseURL:(NSURL *)baseURL
{
    if (!urn || !baseURL) { return nil; }
    UPPMediaServerDevice *device = [[UPPMediaServerDevice alloc] init];
    device.deviceType = urn;
    device.baseURL = baseURL;

    return device;
}

- (UPPContentDirectoryService *)contentDirectoryService
{
    if (!_contentDirectoryService) {
        NSString *namespace = @":service:ContentDirectory:";
        UPPServiceDescription *service = [self serviceForType:namespace];

        if (!service) {
            return nil;
        }

        _contentDirectoryService = [UPPContentDirectoryService
                                    serviceWithBaseURL:self.baseURL
                                    description:service
                                    uniqueDeviceName:self.udn];
    }
    return _contentDirectoryService;
}

- (UPPConnectionManagerService *)connectionManagerService
{
    if (!_connectionManagerService) {
        NSString *namespace = @":service:ConnectionManager:";
        UPPServiceDescription *service = [self serviceForType:namespace];

        if (!service) {
            return nil;
        }

        _connectionManagerService = [UPPConnectionManagerService
                                     serviceWithBaseURL:self.baseURL
                                     description:service
                                     uniqueDeviceName:self.udn];
    }
    return _connectionManagerService;
}

- (UPPAVTransportService *)avTransportService
{
    if (!_avTransportService) {
        NSString *namespace = @":service:AVTransport:";
        UPPServiceDescription *service = [self serviceForType:namespace];

        if (!service) {
            return nil;
        }

        _avTransportService = [UPPAVTransportService
                               serviceWithBaseURL:self.baseURL
                               description:service
                               uniqueDeviceName:self.udn];
    }
    return _avTransportService;
}

@end
