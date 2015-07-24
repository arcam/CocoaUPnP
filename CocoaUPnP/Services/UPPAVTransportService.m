// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@implementation UPPAVTransportService


#pragma mark - Transport URI Methods

- (void)setAVTransportURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData instanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    NSDictionary *parameters = @{ @"CurrentURI": currentURI,
                                  @"CurrentURIMetaData": currentURIMetaData ?: @"" };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetAVTransportURI"
                              parameters:parameters
                                 success:successBlock];
}

- (void)setNextAVTransportURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData instanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    NSDictionary *parameters = @{ @"NextURI": nextURI,
                                  @"NextURIMetaData": nextURIMetaData ?: @"" };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetNextAVTransportURI"
                              parameters:parameters
                                 success:successBlock];
}


#pragma mark - Getting Information

- (void)mediaInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *mediaInfo, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithInstanceID:instanceId action:@"GetMediaInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)transportInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportInfo, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithInstanceID:instanceId action:@"GetTransportInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)positionInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *positionInfo,  NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithInstanceID:instanceId action:@"GetPositionInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)deviceCapabilitiesWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *deviceCapabilities, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithInstanceID:instanceId action:@"GetDeviceCapabilities" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)transportSettingsWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportSettings, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithInstanceID:instanceId action:@"GetTransportSettings" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)transportActionsWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportActions, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithInstanceID:instanceId action:@"GetTransportActions" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

#pragma mark - General Transport Controls

- (void)stopWithInstanceID:(NSString *)instanceId success:(void (^)(BOOL, NSError *))successBlock
{
    [self _sendPostRequestWithInstanceID:instanceId action:@"Stop" parameters:nil success:successBlock];
}

- (void)playWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    [self playWithInstanceID:instanceId speed:@"1" success:successBlock];
}

- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed success:(void(^)(BOOL success, NSError *error))successBlock;
{
    NSDictionary *parameters = @{ @"Speed": speed };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Play"
                              parameters:parameters
                                 success:successBlock];
}

- (void)pauseWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Pause"
                              parameters:nil
                                 success:successBlock];
}

- (void)recordWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Record"
                              parameters:nil
                                 success:successBlock];
}

- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSDictionary *parameters = @{ @"Unit": unit,
                                  @"Target": target };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Seek"
                              parameters:parameters
                                 success:successBlock];
}

- (void)nextWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Next"
                              parameters:nil
                                 success:successBlock];
}

- (void)previousWithInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Previous"
                              parameters:nil
                                 success:successBlock];
}


#pragma mark - Mode Setting

- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSDictionary *parameters = @{ @"NewPlayMode": newPlayMode };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetPlayMode"
                              parameters:parameters
                                 success:successBlock];
}

- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSDictionary *parameters = @{ @"NewRecordMode": newRecordMode };

    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetRecordMode"
                              parameters:parameters
                                 success:successBlock];
}

@end
