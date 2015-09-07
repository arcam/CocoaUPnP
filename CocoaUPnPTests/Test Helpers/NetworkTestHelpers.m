// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "NetworkTestHelpers.h"
#import "UPPError.h"

NSDictionary *(^InstanceDict)(void) = ^NSDictionary*(void) {
    return @{ @"InstanceID": @"0" };
};

void (^VerifyPostWithParams)(NSDictionary *, id, NSString *) = ^void (NSDictionary *params, id manager, NSString *url) {
    [[manager expect] POST:url parameters:[OCMArg checkWithBlock:^BOOL(NSDictionary *parameters) {
        return [parameters isEqualToDictionary:params];
    }] success:[OCMArg any] failure:[OCMArg any]];
};

void (^VerifyGetPostWithParams)(NSDictionary *, id, NSString *) = ^void (NSDictionary *params, id manager, NSString *url) {

    // This is horrible. Much cleaner in Kiwi with KWCaptureSpy :(
    [[[manager expect] andDo:^(NSInvocation *invocation) {
          void (^successBlock)(NSURLSessionTask *task, id responseObject);
          [invocation getArgument:&successBlock atIndex:4];
          successBlock(nil, @{ @"Hello": @"World" });
      }]
     POST:url
     parameters:params
     success:[OCMArg any]
     failure:[OCMArg any]];
};

void (^VerifyFailedGetPostWithParams)(NSDictionary *, id, NSString *) = ^void (NSDictionary *params, id manager, NSString *url) {

    // This is horrible. Much cleaner in Kiwi with KWCaptureSpy :(
    [[[manager expect]
      andDo:^(NSInvocation *invocation) {
          void (^successBlock)(NSURLSessionTask *task, NSError *error);
          [invocation getArgument:&successBlock atIndex:5];
          successBlock(nil, UPPErrorWithCode(UPPErrorCodeGeneric));
      }]
     POST:url
     parameters:params
     success:[OCMArg any]
     failure:[OCMArg any]];
};
