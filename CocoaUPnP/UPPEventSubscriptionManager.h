// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPEventSubscription.h"
#import "UPPEventServer.h"

@class UPPBasicService;

/**
 This class is responsible for managing service subscription objects.
 */
@interface UPPEventSubscriptionManager : NSObject <UPPEventServerDelegate>

/**
 An event server instance for service event callbacks.
 */
@property (strong, nonatomic, nullable) UPPEventServer *eventServer;

/**
 @return A shared event subscription manager instance, with the `NSURLSession`
 set to `[NSURLSession sharedSession]`.
 */
+ (nonnull instancetype)sharedManager;

/**
 Instantiate a new instance of event subscription manager with an NSURLSession.

 @param session The session to use during network calls.

 @return A newly allocated and initialised subscription manager instance.
 */
- (nonnull instancetype)initWithSession:(nonnull NSURLSession *)session;

/**
 Subscribe an observer to UPnP service events.

 @param observer   The observer object, which conforms to
 `UPPEventSubscriptionDelegate`.
 @param service    The service to subscribe to.
 @param completion A block to run when the subscription call finishes. Returns a
 BOOL corresponding to wether the call succeeded or failed.
 */
- (void)subscribeObserver:(nonnull id<UPPEventSubscriptionDelegate>)observer toService:(nonnull UPPBasicService *)service completion:(nullable void(^)(UPPEventSubscription * _Nullable subscription, NSError * _Nullable error))completion;

/**
 Renew a current subscription.

 @param subscription The subscription to renew.
 @param completion   A block which is run when the subscription call finishes.
 Returns the new subscription identifier, the new expiry date, or if renewing
 failed, an error object.
 */
- (void)renewSubscription:(nonnull UPPEventSubscription *)subscription completion:(nonnull void(^)(NSString * _Nullable subscriptionID, NSDate * _Nullable expiryDate, NSError * _Nullable error))completion;

/**
 Renew an expired subscription. This differs from renewing an existing
 subscription, as the service is essentially subscribed as if new. However, any
 existing observers are kept around and therefore do not need re-adding.

 @param subscription The subscription to renew.
 @param completion   A block which is run when the subscription call finishes.
 Returns the new subscription identifier, the new expiry date, or if renewing
 failed, an error object.
 */
- (void)subscriptionExpired:(nonnull UPPEventSubscription *)subscription completion:(nonnull void(^)(NSString * _Nullable subscriptionID, NSDate * _Nullable expiryDate, NSError * _Nullable error))completion;

/**
 Unsubscribe an observer from a service. If there are no more observers, then
 the subscription object unsubscribes from service notifications and the
 subscription object is destroyed.

 @param observer   The observer object to remove from subscription events.
 @param service    The service that the object is subscribed to.
 @param completion A block to run when the subscription call finishes. Returns a
 BOOL corresponding to whether the call succeeded or failed.
 */
- (void)removeObserver:(nonnull id<UPPEventSubscriptionDelegate>)observer fromService:(nonnull UPPBasicService *)service completion:(nullable void(^)(BOOL success))completion;

/**
 Unsubscribe a specific subscription. Used internally, but may be useful for
 batch unsubscribing all event subscribers.

 @param subscription The subscription to unsubscribe.
 @param completion A block to run when the subscription call finishes. Returns a
 BOOL corresponding to whether the call succeeded or failed.
 */
- (void)unsubscribe:(nonnull UPPEventSubscription *)subscription completion:(nullable void(^)(BOOL success))completion;

/**
 Remove all subscriptions for an array of services. This is run when discovery
 is removing a device to prevent stale subscriptions being kept around.

 @param services An array of `UPPBasicService` objects.
 @param deviceId The parent unique device name.
 */
- (void)removeSubscriptionsForServices:(nonnull NSArray *)services deviceId:(nonnull NSString *)deviceId;

@end
