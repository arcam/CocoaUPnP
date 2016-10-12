// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaRendererDevice.h"
#import "UPPRenderingControlService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"
#import "UPPServiceDescription.h"

@interface UPPMediaRendererDevice ()
@property (strong, nonatomic) UPPRenderingControlService *renderingControlService;
@property (strong, nonatomic) UPPConnectionManagerService *connectionManagerService;
@property (strong, nonatomic) UPPAVTransportService *avTransportService;
@end

@implementation UPPMediaRendererDevice

+ (instancetype)mediaRendererWithURN:(NSString *)urn baseURL:(NSURL *)baseURL
{
    if (!urn || !baseURL) { return nil; }
    UPPMediaRendererDevice *device = [[UPPMediaRendererDevice alloc] init];
    device.deviceType = urn;
    device.baseURL = baseURL;

    return device;
}

- (UPPRenderingControlService *)renderingControlService
{
    if (!_renderingControlService) {

        NSString *namespace = @":service:RenderingControl:";
        UPPServiceDescription *service = [self serviceForType:namespace];

        if (!service) {
            return nil;
        }

        _renderingControlService = [UPPRenderingControlService
                                    serviceWithBaseURL:self.baseURL
                                    description:service
                                    uniqueDeviceName:self.udn];
    }

    return _renderingControlService;
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
