// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"
#import "UPPParameters.h"

@implementation UPPAVTransportService


#pragma mark - Transport URI Methods

- (void)setAVTransportURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData instanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    NSArray *keys = @[ @"InstanceID", @"CurrentURI", @"CurrentURIMetaData" ];
    NSString *c = currentURIMetaData ?: @"";
    NSArray *values = @[ instanceId, currentURI, c ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetAVTransportURI"
                                 success:successBlock];
}

- (void)setNextAVTransportURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData instanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    NSArray *keys = @[ @"InstanceID", @"NextURI", @"NextURIMetaData" ];
    NSString *n = nextURIMetaData ?: @"";
    NSArray *values = @[ instanceId, nextURI, n ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetNextAVTransportURI"
                                 success:successBlock];
}


#pragma mark - Getting Information

- (void)mediaInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *mediaInfo, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetMediaInfo"
                              completion:completion];
}

- (void)transportInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportInfo, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetTransportInfo"
                              completion:completion];
}

- (void)positionInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *positionInfo,  NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetPositionInfo"
                              completion:completion];
}

- (void)deviceCapabilitiesWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *deviceCapabilities, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetDeviceCapabilities"
                              completion:completion];
}

- (void)transportSettingsWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportSettings, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetTransportSettings"
                              completion:completion];
}

- (void)transportActionsWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportActions, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetTransportActions"
                              completion:completion];
}

#pragma mark - General Transport Controls

- (void)stopWithInstanceID:(NSString *)instanceId success:(void (^)(BOOL, NSError *))successBlock
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Stop"
                                 success:successBlock];
}

- (void)playWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    [self playWithInstanceID:instanceId speed:@"1" success:successBlock];
}

- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed success:(void(^)(BOOL success, NSError *error))successBlock;
{
    NSArray *keys = @[ @"InstanceID", @"Speed" ];
    NSArray *values = @[ instanceId, speed ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"Play"
                                 success:successBlock];
}

- (void)pauseWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Pause"
                                 success:successBlock];
}

- (void)recordWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Record"
                                 success:successBlock];
}

- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSArray *keys = @[ @"InstanceID", @"Unit", @"Target" ];
    NSArray *values = @[ instanceId, unit, target ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"Seek"
                                 success:successBlock];
}

- (void)nextWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Next"
                                 success:successBlock];
}

- (void)previousWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Previous"
                                 success:successBlock];
}


#pragma mark - Mode Setting

- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSArray *keys = @[ @"InstanceID", @"NewPlayMode" ];
    NSArray *values = @[ instanceId, newPlayMode ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetPlayMode"
                                 success:successBlock];
}

- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSArray *keys = @[ @"InstanceID", @"NewRecordMode" ];
    NSArray *values = @[ instanceId, newRecordMode ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetRecordMode"
                                 success:successBlock];
}

#pragma mark - Private Methods

- (UPPParameters *)paramsWithInstanceID:(NSString *)iid
{
    return [UPPParameters paramsWithKey:@"InstanceID" value:iid];
}

@end
