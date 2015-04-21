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
    NSDictionary *parameters = @{ UPPSOAPActionKey: @"Stop",
                                  UPPNameSpaceKey: _nameSpace };
    
    [self _sendPostRequestWithParameters:parameters error:error];
}

- (void)playWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    [self playWithInstanceID:instanceId speed:@"1" error:error];
}

- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed error:(NSError *__autoreleasing *)error
{
    NSDictionary *wrapped = [self wrapParameters:@{ @"Speed": speed }
                                      withAction:@"Play"
                                       namespace:_nameSpace];
    
    [self _sendPostRequestWithParameters:wrapped error:error];
}

- (void)pauseWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ UPPSOAPActionKey: @"Pause",
                                  UPPNameSpaceKey: _nameSpace };
    
    [self _sendPostRequestWithParameters:parameters error:error];
}

- (void)recordWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ UPPSOAPActionKey: @"Record",
                                  UPPNameSpaceKey: _nameSpace };
    
    [self _sendPostRequestWithParameters:parameters error:error];
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
