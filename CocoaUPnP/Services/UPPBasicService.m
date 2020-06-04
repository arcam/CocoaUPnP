// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"
#import "UPPParameters.h"

@interface UPPBasicService ()
@property (strong, nonatomic) NSURL *baseURL;
@property (copy, nonatomic) NSString *usn;
@end

@implementation UPPBasicService

+ (instancetype)serviceWithBaseURL:(NSURL *)baseURL description:(UPPServiceDescription *)description uniqueDeviceName:(NSString *)uniqueDeviceName
{
    if (!baseURL || !description || !uniqueDeviceName) {
        return nil;
    }

    id service = [[[self class] alloc] init];
    [service setBaseURL:baseURL];
    [service populateFromServiceDescription:description];
    [service createUniqueServiceNameWithDeviceName:uniqueDeviceName];

    return service;
}

- (NSString *)uniqueServiceName
{
    return self.usn;
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

- (void)_sendPostRequestWithParameters:(UPPParameters *)parameters action:(NSString *)action success:(UPPSuccessBlock)successBlock
{
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:action];

    [self.sessionManager POST:[self.controlURL absoluteString] parameters:wrapped headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(YES, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (successBlock) {
            successBlock(NO, error);
        }
    }];
}

- (void)_sendPostRequestWithParameters:(UPPParameters *)parameters action:(NSString *)action completion:(UPPResponseBlock)completion
{
    NSDictionary *wrapped = [self wrapParameters:parameters
                                      withAction:action];

    [self.sessionManager POST:[self.controlURL absoluteString] parameters:wrapped headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)createUniqueServiceNameWithDeviceName:(NSString *)uniqueDeviceName
{
    self.usn = [NSString stringWithFormat:@"%@::%@", uniqueDeviceName, self.serviceType];
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
