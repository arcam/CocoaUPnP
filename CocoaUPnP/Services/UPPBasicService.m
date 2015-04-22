// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@implementation UPPBasicService

- (NSDictionary *)wrapParameters:(NSDictionary *)parameters withAction:(NSString *)action
{
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    
    if (action) {
        [wrapper setObject:action forKey:UPPSOAPActionKey];
    }
    
    if (self.nameSpace) {
        [wrapper setObject:self.nameSpace forKey:UPPNameSpaceKey];
    }
    
    if (parameters) {
        [wrapper setObject:parameters forKey:UPPParametersKey];
    }
    
    return [wrapper copy];
}

- (void)_sendPostRequestWithInstanceID:(NSString *)instanceId action:(NSString *)action parameters:(NSDictionary *)parameters error:(NSError * __autoreleasing *)error
{
    NSMutableDictionary *mergedParameters = [NSMutableDictionary dictionary];
    
    if (instanceId) {
        [mergedParameters setObject:instanceId forKey:@"InstanceID"];
    }
    
    if (parameters) {
        [mergedParameters addEntriesFromDictionary:parameters];
    }
    
    NSDictionary *wrapped = [self wrapParameters:mergedParameters
                                      withAction:action];
    
    [self.sessionManager POST:[self.controlURL absoluteString] parameters:wrapped success:nil failure:^(NSURLSessionDataTask *task, NSError *returnedError) {
        *error = returnedError;
    }];
}

- (void)_sendPostRequestWithInstanceID:(NSString *)instanceId action:(NSString *)action completion:(void (^)(NSDictionary *responseObject, NSError *error))completion
{
    NSDictionary *parameters = @{ @"InstanceID": instanceId };
    [self _sendPostRequestWithParameters:parameters action:action completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)_sendPostRequestWithParameters:(NSDictionary *)parameters action:(NSString *)action completion:(void (^)(NSDictionary *responseObject, NSError *error))completion
{
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:action];
    
    [self.sessionManager POST:[self.controlURL absoluteString] parameters:wrapped success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

@end
