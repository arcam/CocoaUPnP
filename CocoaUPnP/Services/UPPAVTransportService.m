// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@implementation UPPAVTransportService


#pragma mark - Transport URI Methods

- (void)setAVTransportURIWithInstanceID:(NSString *)instanceId currentURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"CurrentURI": currentURI,
                                  @"CurrentURIMetaData": currentURIMetaData };
    
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetAVTransportURI"
                              parameters:parameters
                                   error:error];
}

- (void)setNextAVTransportURIWithInstanceID:(NSString *)instanceId nextURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"NextURI": nextURI,
                                  @"NextURIMetaData": nextURIMetaData };
    
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetNextAVTransportURI"
                              parameters:parameters
                                   error:error];
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

- (void)stopWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Stop"
                              parameters:nil
                                   error:error];
}

- (void)playWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self playWithInstanceID:instanceId speed:@"1" error:error];
}

- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed error:(NSError *__autoreleasing *)error
{
    NSDictionary *parameters = @{ @"Speed": speed };
    
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Play"
                              parameters:parameters
                                   error:error];
}

- (void)pauseWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Pause"
                              parameters:nil
                                   error:error];
}

- (void)recordWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Record"
                              parameters:nil
                                   error:error];
}

- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"Unit": unit,
                                  @"Target": target };
    
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Seek"
                              parameters:parameters
                                   error:error];
}

- (void)nextWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Next"
                              parameters:nil
                                   error:error];
}

- (void)previousWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"Previous"
                              parameters:nil
                                   error:error];
}


#pragma mark - Mode Setting

- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"NewPlayMode": newPlayMode };
    
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetPlayMode"
                              parameters:parameters
                                   error:error];
}

- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"NewRecordMode": newRecordMode };
    
    [self _sendPostRequestWithInstanceID:instanceId
                                  action:@"SetRecordMode"
                              parameters:parameters
                                   error:error];
}

#pragma mark - Private Methods

- (NSDictionary *)wrapParameters:(NSDictionary *)parameters withAction:(NSString *)action namespace:(NSString *)namespace
{
    return @{ UPPSOAPActionKey: action,
              UPPNameSpaceKey: namespace,
              UPPParametersKey: parameters };
}

- (void)_sendPostRequestWithParameters:(NSDictionary *)parameters error:(NSError * __autoreleasing *)error
{
    [_sessionManager POST:[_controlURL absoluteString] parameters:parameters success:nil failure:^(NSURLSessionDataTask *task, NSError *returnedError) {
        *error = returnedError;
    }];
}

- (void)_sendPostRequestWithInstanceID:(NSString *)instanceId action:(NSString *)action parameters:(NSDictionary *)parameters error:(NSError * __autoreleasing *)error
{
    NSMutableDictionary *mergedParameters = [NSMutableDictionary dictionary];
    [mergedParameters setObject:instanceId forKey:@"InstanceID"];
    
    if (parameters) {
        [mergedParameters addEntriesFromDictionary:parameters];
    }
    
    NSDictionary *wrapped = [self wrapParameters:mergedParameters
                                      withAction:action
                                       namespace:_nameSpace];
    
    [_sessionManager POST:[_controlURL absoluteString] parameters:wrapped success:nil failure:^(NSURLSessionDataTask *task, NSError *returnedError) {
        *error = returnedError;
    }];
}

- (void)_sendPostRequestWithInstanceID:(NSString *)instanceId action:(NSString *)action completion:(void (^)(NSDictionary *responseObject, NSError *error))completion
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:action
                                       namespace:_nameSpace];
    
    [_sessionManager POST:[_controlURL absoluteString] parameters:wrapped success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

@end
