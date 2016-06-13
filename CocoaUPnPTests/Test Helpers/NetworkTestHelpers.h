// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPParameters;

/**
 Stub a parameters object containing a single instance ID key and value.

 @return Returns a UPPParamaters object containing `InstanceID: 0`.
 */
UPPParameters * InstanceParams(void);

/**
 Setup an expectation for a failed network call, and return stubbed error

 @param NSDictionary The parameters passed into the method
 @param id           The session manager to set the expectation on
 @param NSString     The URL the message is posted to
 */
void ExpectAndReturnErrorWithParams(NSDictionary *params, id sessionManager, NSString *url);

/**
 Setup an expectation for a successful network call, passing in a session
 manager, a dictionary of parameters, and a URL.
 */
void ExpectGetWithParams(id sessionManager, NSDictionary *params, NSString *url);

/**
 Reject any network call, passing in a session manager and a URL.
 */
void RejectGetWithURL(id sessionManager, NSString *url);
