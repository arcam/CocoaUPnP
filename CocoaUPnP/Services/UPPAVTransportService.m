// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@implementation UPPAVTransportService

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

- (void)seekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target error:(NSError * __autoreleasing *)error
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

@end
