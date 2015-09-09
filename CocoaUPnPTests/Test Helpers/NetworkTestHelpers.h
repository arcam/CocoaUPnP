// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class UPPParameters;

/**
 Stub an InstanceID dictionary

 @return Returns an NSDictionary containing `InstanceID: 0`
 */
NSDictionary *(^InstanceDict)(void);

/**
 Verify parameters passed into a POST request

 @param NSDictionary The parameters
 @param id           The session manager
 @param NSString     The URL the request is POSTed to
 */
void (^VerifyPostWithParams)(NSDictionary *, id, NSString *);;

/**
 Setup an expectation for a network call, and return stubbed data

 @param NSDictionary The parameters passed into the method
 @param id           The session manager to set the expectation on
 @param NSString     The URL the message is posted to
 */
void (^VerifyGetPostWithParams)(NSDictionary *, id, NSString *);

/**
 Setup an expectation for a failed network call, and return stubbed error

 @param NSDictionary The parameters passed into the method
 @param id           The session manager to set the expectation on
 @param NSString     The URL the message is posted to
 */
void (^VerifyFailedGetPostWithParams)(NSDictionary *, id, NSString *);

/**
 Setup an expectation for a successful network call, passing in a session
 manager, a dictionary of parameters, and a URL.
 */
void (^ExpectGetWithParams)(id, NSDictionary *, NSString *);

/**
 Reject any network call, passing in a session manager and a URL.
 */
void (^RejectGetWithURL)(id, NSString *);