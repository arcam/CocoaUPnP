// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPParameters;

/**
 Stub a parameters object containing a single instance ID key and value.

 @return Returns a UPPParamaters object containing `InstanceID: 0`.
 */
extern UPPParameters *(^InstanceParams)(void);

/**
 Setup an expectation for a failed network call, and return stubbed error

 @param NSDictionary The parameters passed into the method
 @param id           The session manager to set the expectation on
 @param NSString     The URL the message is posted to
 */
extern void (^ExpectAndReturnErrorWithParams)(NSDictionary *, id, NSString *);

/**
 Setup an expectation for a successful network call, passing in a session
 manager, a dictionary of parameters, and a URL.
 */
extern void (^ExpectGetWithParams)(id, NSDictionary *, NSString *);

/**
 Reject any network call, passing in a session manager and a URL.
 */
extern void (^RejectGetWithURL)(id, NSString *);
