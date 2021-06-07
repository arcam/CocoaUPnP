// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPEventSubscriptionManager;

/**
 This protocol describes a required subscription notification method which
 conforming objects are expected to implement.
 */
@protocol UPPEventSubscriptionDelegate <NSObject>

/**
 A method which is called whenever an incoming event is detected.

 @param event A dictionary representation of the XML sent by the subscribed
 service.
 */
- (void)eventReceived:(nonnull NSDictionary *)event;
@end


/**
 This class models a UPnP subscription. It retains information passed back in
 the header of a `SUBSCRIBE` call. Additionally, it keeps an array of observers
 which in turn are informed of any UPnP event passed in from the manager.
 */
@interface UPPEventSubscription : NSObject

#pragma mark - Properties

///-----------------------------------------------------------------------------
/// @name Properties
///-----------------------------------------------------------------------------

/**
 The subscription identifier returned by the service.
 */
@property (copy, nonatomic, readonly, nullable) NSString *subscriptionID;

/**
 The date at which the subscription is expired by the service.
 */
@property (strong, nonatomic, readonly, nullable) NSDate *expiryDate;

/**
 The URL where the service expects subscription calls to be made.
 */
@property (strong, nonatomic, readonly, nonnull) NSURL *eventSubscriptionURL;

/**
 A timer which fires 30 seconds before the subscription is due to expire, which
 triggers the subscription's manager to resubscribe.
 */
@property (strong, nonatomic, readonly, nullable) NSTimer *renewTimer;

/**
 A timer which fires at the subscriptions expiration date, which triggers the
 subscription's manager to attempt to subscribe again or scrap the subscription.
 */
@property (strong, nonatomic, readonly, nullable) NSTimer *expirationTimer;

/**
 The manager responsible for making the subscription network calls.
 */
@property (weak, nonatomic, nullable) UPPEventSubscriptionManager *manager;

/**
 The unique name of the service that the subscription applies to
 */
@property (copy, nonatomic, readonly, nonnull) NSString *uniqueServiceName;


#pragma mark - Initialisation

///-----------------------------------------------------------------------------
/// @name Initialisation
///-----------------------------------------------------------------------------

/**
 Convenience initialiser which returns a new subscription object when passed in
 an event subscription URL.

 @param eventSubscriptionURL The full event subscription URL, which is used when
 resubscribing or unsubscribing from events.
 @param serviceIdentifier    The unique name of the service the subscription
 relates to

 @return Returns a new subscription object.
 */
+ (nonnull instancetype)subscriptionWithSubscriptionURL:(nonnull NSURL *)eventSubscriptionURL serviceIdentifier:(nonnull NSString *)serviceIdentifier;

/**
 Convenience initialiser which returns a new subscription object when given a
 subscription identifier, an expiry date and an event subscription URL.

 @param subscriptionID       The subscription identifier returned by the service.
 @param expiryDate           The date at which the subscription is expired by the
 service.
 @param eventSubscriptionURL The full event subscription URL, which is used when
 resubscribing or unsubscribing from events.
 @param serviceIdentifier    The unique name of the service the subscription.

 @return Returns a new subscription object.
 */
+ (nonnull instancetype)subscriptionWithID:(nullable NSString *)subscriptionID expiryDate:(nonnull NSDate *)expiryDate eventSubscriptionURL:(nonnull NSURL *)eventSubscriptionURL serviceIdentifier:(nonnull NSString *)serviceIdentifier;

/**
 Update the object after renewing a subscription.

 @param subscriptionID The subscription identifier returned by the service being
 subscribed to.
 @param expiryDate     The date which the subscription expires. Decided by the
 UPnP service currently being subscribed to.
 */
- (void)updateSubscriptionID:(nonnull NSString *)subscriptionID expiryDate:(nonnull NSDate *)expiryDate;


#pragma mark - Events

///-----------------------------------------------------------------------------
/// @name Events
///-----------------------------------------------------------------------------

/**
 Add an observer you wish to be informed of UPnP events.

 @param observer An observer class conforming to `UPPEventSubscriptionDelegate`
 */
- (void)addEventObserver:(nonnull id <UPPEventSubscriptionDelegate>)observer;

/**
 Remove a previously added observer, once you no longer wish to be notified of
 new events.

 @param observer An observer class conforming to `UPPEventSubscriptionDelegate`
 */
- (void)removeEventObserver:(nonnull id <UPPEventSubscriptionDelegate>)observer;

/**
 An array of event observers.
 */
- (nonnull NSArray *)eventObservers;

/**
 Inform all observers of a new event.

 @param event A dictionary containing parsed XML related to the event.
 */
- (void)informObserversOfEvent:(nonnull NSDictionary *)event;


#pragma mark - Background Helpers

///-----------------------------------------------------------------------------
/// @name Events
///-----------------------------------------------------------------------------

/**
 Invalidate both expiration and renew subscription timers.
 */
- (void)invalidateTimers;

/**
 Renew subscription after returning from background operation.
 */
- (void)renewSubscription;

@end
