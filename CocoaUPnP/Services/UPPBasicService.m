// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"
#import "UPPParameters.h"

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

- (NSDictionary *)wrapParameters:(UPPParameters *)parameters withAction:(NSString *)action
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

- (void)_sendPostRequestWithParameters:(UPPParameters *)parameters action:(NSString *)action success:(void(^)(BOOL success, NSError *error))successBlock
{
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:action];

    [self.sessionManager POST:[self.controlURL absoluteString] parameters:wrapped success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successBlock) {
            successBlock(YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *returnedError) {
        if (successBlock) {
            successBlock(NO, returnedError);
        }
    }];
}

- (void)_sendPostRequestWithParameters:(UPPParameters *)parameters action:(NSString *)action completion:(void (^)(NSDictionary *responseObject, NSError *error))completion
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
