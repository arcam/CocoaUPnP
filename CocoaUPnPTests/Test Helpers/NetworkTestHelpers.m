// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "NetworkTestHelpers.h"
#import <CocoaUPnP/CocoaUPnP.h>
#import <OCMock/OCMock.h>
#import <AFNetworking/AFNetworking.h>

UPPParameters * InstanceParams(void)
{
    return [UPPParameters paramsWithKey:@"InstanceID" value:@"0"];
};

void ExpectAndReturnErrorWithParams(NSDictionary *params, id sessionManager, NSString *url)
{

    // This is horrible. Much cleaner in Kiwi with KWCaptureSpy :(
    [[[sessionManager expect]
      andDo:^(NSInvocation *invocation) {
          void (^failureBlock)(NSURLSessionTask *task, NSError *error);
          [invocation getArgument:&failureBlock atIndex:6];
          failureBlock(nil, UPPErrorWithCode(UPPErrorCodeGeneric));
      }]
     POST:url
     parameters:params
     progress:nil
     success:[OCMArg any]
     failure:[OCMArg any]];
};

void ExpectGetWithParams(id sessionManager, NSDictionary *params, NSString *url)
{
    OCMExpect([sessionManager POST:url parameters:params progress:nil success:[OCMArg any] failure:[OCMArg any]]);
};

void RejectGetWithURL(id sessionManager, NSString *url)
{
    [[sessionManager reject] POST:url
                       parameters:[OCMArg any]
                         progress:nil
                          success:[OCMArg any]
                          failure:[OCMArg any]];
};