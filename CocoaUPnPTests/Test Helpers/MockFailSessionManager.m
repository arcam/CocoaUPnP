// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "MockFailSessionManager.h"

const NSInteger MockFailSessionErrorCode = 666;

@implementation MockFailSessionManager

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock
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
