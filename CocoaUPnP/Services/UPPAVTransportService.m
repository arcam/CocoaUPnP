// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"

@implementation UPPAVTransportService

- (void)setAVTransportURIWithInstanceID:(NSString *)instanceId currentURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"CurrentURI": currentURI,
                                  @"CurrentURIMetaData": currentURIMetaData };
    [self _sendPostRequestWithParameters:parameters error:error];
}

- (void)setNextAVTransportURIWithInstanceID:(NSString *)instanceId nextURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData error:(NSError * __autoreleasing *)error
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId,
                                  @"NextURI": nextURI,
                                  @"NextURIMetaData": nextURIMetaData };
    [self _sendPostRequestWithParameters:parameters error:error];
}

#pragma mark - Private Methods

- (void)_sendPostRequestWithParameters:(NSDictionary *)parameters error:(NSError * __autoreleasing *)error
{
    [_sessionManager POST:[_controlURL absoluteString] parameters:parameters success:nil failure:^(NSURLSessionDataTask *task, NSError *returnedError) {
        *error = returnedError;
    }];
}

@end
