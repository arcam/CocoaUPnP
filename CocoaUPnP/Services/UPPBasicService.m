// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@interface UPPBasicService ()
@property (strong, nonatomic) NSURL *baseURL;
@end

@implementation UPPBasicService

+ (instancetype)serviceWithBaseURL:(NSURL *)baseURL description:(UPPServiceDescription *)description
{
    id service = [[[self class] alloc] init];
    [service setBaseURL:baseURL];
    [service populateFromServiceDescription:description];
    
    return service;
}

- (NSDictionary *)wrapParameters:(NSDictionary *)parameters withAction:(NSString *)action
{
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    
    if (action) {
        [wrapper setObject:action forKey:UPPSOAPActionKey];
    }
    
    if (self.serviceType) {
        [wrapper setObject:self.serviceType forKey:UPPNameSpaceKey];
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

#pragma mark - Private Methods

- (void)populateFromServiceDescription:(UPPServiceDescription *)description
{
    self.serviceType = description.serviceType;
    self.controlURL = [self urlForComponent:description.controlURL];
    self.eventSubscriptionURL = [self urlForComponent:description.eventSubURL];
}

- (NSURL *)urlForComponent:(NSString *)component
{
    if (!component) {
        return nil;
    }
    
    return [NSURL URLWithString:component relativeToURL:self.baseURL];
}


- (UPPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [[UPPSessionManager alloc] initWithBaseURL:nil];
    }
    
    return _sessionManager;
}


#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, serviceType: %@, controlURL: %@>",
            NSStringFromClass([self class]), self, self.serviceType, self.controlURL];
}

@end
