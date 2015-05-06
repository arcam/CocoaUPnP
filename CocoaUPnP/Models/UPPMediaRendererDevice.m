// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaRendererDevice.h"
#import "UPPRenderingControlService.h"
#import "UPPConnectionManagerService.h"
#import "UPPAVTransportService.h"

@interface UPPMediaRendererDevice ()
@property (strong, nonatomic) UPPRenderingControlService *renderingControlService;
@property (strong, nonatomic) UPPConnectionManagerService *connectionManagerService;
@property (strong, nonatomic) UPPAVTransportService *avTransportService;
@end

@implementation UPPMediaRendererDevice

+ (instancetype)mediaRendererWithURN:(NSString *)urn baseURL:(NSURL *)baseURL
{
    UPPMediaRendererDevice *device = [[UPPMediaRendererDevice alloc] init];
    device.deviceType = urn;
    device.baseURL = baseURL;
    
    return device;
}

- (UPPRenderingControlService *)renderingControlService
{
    if (!_renderingControlService) {
        
        NSString *namespace = @":service:RenderingControl:";
        UPPBasicService *service = [self serviceForNameSpace:namespace];
        
        if (!service) {
            return nil;
        }
        
        _renderingControlService = [[UPPRenderingControlService alloc] init];
        _renderingControlService.controlURL = [self controlURLForService:service];
    }
    return _renderingControlService;
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

@end
