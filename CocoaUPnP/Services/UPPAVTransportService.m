// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"
#import "UPPParameters.h"
#import "UPPError.h"

@implementation UPPAVTransportService

#pragma mark - Transport URI Methods

- (void)setAVTransportURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData instanceID:(NSString *)instanceId success:(UPPSuccessBlock)success;
{
    if (!currentURI) {
        if (success) {
            NSError *e = UPPErrorWithMethodAndParam(NSStringFromSelector(_cmd), @"CurrentURI");
            success(NO, e);
        }
        return;
    }

    NSArray *keys = @[ @"InstanceID", @"CurrentURI", @"CurrentURIMetaData" ];
    NSString *metadata = currentURIMetaData ?: @"";
    NSString *iid = instanceId ?: @"0";
    NSArray *values = @[ iid, currentURI, metadata ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetAVTransportURI"
                                 success:success];
}

- (void)setNextAVTransportURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData instanceID:(NSString *)instanceId success:(UPPSuccessBlock)success;
{
    if (!nextURI) {
        if (success) {
            NSError *e = UPPErrorWithMethodAndParam(NSStringFromSelector(_cmd), @"NextURI");
            success(NO, e);
        }
        return;
    }

    NSArray *keys = @[ @"InstanceID", @"NextURI", @"NextURIMetaData" ];
    NSString *metadata = nextURIMetaData ?: @"";
    NSString *iid = instanceId ?: @"0";
    NSArray *values = @[ iid, nextURI, metadata ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetNextAVTransportURI"
                                 success:success];
}


#pragma mark - Getting Information

- (void)mediaInfoWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetMediaInfo"
                              completion:completion];
}

- (void)transportInfoWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetTransportInfo"
                              completion:completion];
}

- (void)positionInfoWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetPositionInfo"
                              completion:completion];
}

- (void)deviceCapabilitiesWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetDeviceCapabilities"
                              completion:completion];
}

- (void)transportSettingsWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetTransportSettings"
                              completion:completion];
}

- (void)transportActionsWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"GetTransportActions"
                              completion:completion];
}

#pragma mark - General Transport Controls

- (void)stopWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Stop"
                                 success:success];
}

- (void)playWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success;
{
    [self playWithInstanceID:instanceId speed:nil success:success];
}

- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed success:(UPPSuccessBlock)success;
{
    NSArray *keys = @[ @"InstanceID", @"Speed" ];
    NSString *iid = instanceId ?: @"0";
    NSString *spd = speed ?: @"1";
    NSArray *values = @[ iid, spd ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"Play"
                                 success:success];
}

- (void)pauseWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Pause"
                                 success:success];
}

- (void)recordWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Record"
                                 success:success];
}

- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target success:(UPPSuccessBlock)success
{
    if (!unit) {
        if (success) {
            NSError *e = UPPErrorWithMethodAndParam(NSStringFromSelector(_cmd), @"Unit");
            success(NO, e);
        }
        return;
    }

    if (!target) {
        if (success) {
            NSError *e = UPPErrorWithMethodAndParam(NSStringFromSelector(_cmd), @"Target");
            success(NO, e);
        }
        return;
    }

    NSArray *keys = @[ @"InstanceID", @"Unit", @"Target" ];
    NSString *iid = instanceId ?: @"0";
    NSArray *values = @[ iid, unit, target ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"Seek"
                                 success:success];
}

- (void)nextWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Next"
                                 success:success];
}

- (void)previousWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    [self _sendPostRequestWithParameters:[self paramsWithInstanceID:instanceId]
                                  action:@"Previous"
                                 success:success];
}


#pragma mark - Mode Setting

- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    if (!newPlayMode) {
        if (success) {
            NSError *e = UPPErrorWithMethodAndParam(NSStringFromSelector(_cmd), @"NewPlayMode");
            success(NO, e);
        }
        return;
    }

    NSArray *keys = @[ @"InstanceID", @"NewPlayMode" ];
    NSString *iid = instanceId ?: @"0";
    NSArray *values = @[ iid, newPlayMode ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetPlayMode"
                                 success:success];
}

- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)success
{
    if (!newRecordMode) {
        if (success) {
            NSError *e = UPPErrorWithMethodAndParam(NSStringFromSelector(_cmd),
                                                        @"NewRecordMode");
            success(NO, e);
        }
        return; }

    NSArray *keys = @[ @"InstanceID", @"NewRecordMode" ];
    NSArray *values = @[ instanceId, newRecordMode ];
    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params
                                  action:@"SetRecordMode"
                                 success:success];
}

#pragma mark - Private Methods

- (UPPParameters *)paramsWithInstanceID:(NSString *)iid
{
    NSString *value = iid ?: @"0";
    return [UPPParameters paramsWithKey:@"InstanceID" value:value];
}

@end
