// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPServiceDescription.h"

@class UPPSessionManager;
@class UPPParameters;

NS_ASSUME_NONNULL_BEGIN

/** This class serves as a base class for all UPnP services
 */
@interface UPPBasicService : NSObject

/**
 A generic response block

 @param response The SOAP response as an `NSDictionary`
 @param error    An optional `NSError` which is returned in the event of parse
                 failure
 */
typedef void (^UPPResponseBlock)(NSDictionary * _Nullable response, NSError * _Nullable error);

/**
 A generic success / failure block

 @param success The success state of the network call
 @param error   If the call was unsucessful, an `NSError` is returned with more
 information
 */
typedef void (^UPPSuccessBlock)(BOOL success, NSError * _Nullable error);

#pragma mark - Properties

///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/**
 The session manager instance to perform the network requests with
 */
@property (strong, nonatomic) UPPSessionManager *sessionManager;

/**
 The service's control point URL
 */
@property (copy, nonatomic) NSURL *controlURL;

/**
 The service's event subscription URL
 */
@property (copy, nonatomic) NSURL *eventSubscriptionURL;

/**
 The service type of the control point
 */
@property (copy, nonatomic) NSString *serviceType;

#pragma mark - Methods

///-----------------------------------------------------------------------------
/// @name Methods
///-----------------------------------------------------------------------------

/**
 A convenience initialiser for creating a new service from a base URL and
 `UPPServiceDescription`

 @param baseURL          The base URL for the service
 @param description      The basic service description
 @param uniqueDeviceName The unique device name of the parent device

 @return A new basic service instance
 */
+ (nullable instancetype)serviceWithBaseURL:(NSURL *)baseURL description:(UPPServiceDescription *)description uniqueDeviceName:(NSString *)uniqueDeviceName;

/**
 Returns a unique service name, comprised of the parent devices unique device name,
 concatenated with the service type
 */

- (NSString *)uniqueServiceName;

/**
 Send a POST request, with a completion block that returns the success state of
 the call.

 @param parameters   The parameters for the call.
 @param action       The UPnP action.
 @param successBlock A completion block which returns a BOOL for whether the
 call was successful or not. If the call was unsuccessful, an error object is
 also returned.
 */
- (void)_sendPostRequestWithParameters:(nullable UPPParameters *)parameters action:(NSString *)action success:(UPPSuccessBlock)successBlock;

/**
 Send a POST request, with a completion block

 @param parameters The parameters for the call
 @param action     The UPnP action
 @param completion A completion block either returning a dictionary response, or
     an error if the call failed
 */
- (void)_sendPostRequestWithParameters:(nullable UPPParameters *)parameters action:(NSString *)action completion:(UPPResponseBlock)completion;

@end

NS_ASSUME_NONNULL_END
