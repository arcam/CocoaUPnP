// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@implementation UPPAVTransportService


#pragma mark - Transport URI Methods

- (void)setAVTransportURIWithInstanceID:(NSString *)instanceId currentURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"CurrentURI": currentURI,
                                  @"CurrentURIMetaData": currentURIMetaData };
    
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"SetAVTransportURI"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)setNextAVTransportURIWithInstanceID:(NSString *)instanceId nextURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"NextURI": nextURI,
                                  @"NextURIMetaData": nextURIMetaData };
    
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"SetNextAVTransportURI"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
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

#pragma mark - General Transport Controls

- (void)stopWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Stop"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)playWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self playWithInstanceID:instanceId speed:@"1" error:error];
}

- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed error:(NSError *__autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"Speed": speed };
    
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Play"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)pauseWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Pause"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)recordWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Record"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"Unit": unit,
                                  @"Target": target };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Seek"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)nextWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Next"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)previousWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"Previous"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}


#pragma mark - Mode Setting

- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"NewPlayMode": newPlayMode };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"SetPlayMode"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"NewRecordMode": newRecordMode };
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:@"SetRecordMode"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
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
