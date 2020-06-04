// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "MockFailSessionManager.h"

const NSInteger MockFailSessionErrorCode = 666;

@implementation MockFailSessionManager

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failureBlock
{
    failureBlock(nil, [self error]);
    return nil;
}

- (NSError *)error
{
    return [NSError errorWithDomain:@"com.arcam.cocoaupnp.unittests"
                               code:MockFailSessionErrorCode
                           userInfo:nil];
}

@end
