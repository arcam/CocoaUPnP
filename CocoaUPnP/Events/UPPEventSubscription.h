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
- (void)eventRecieved:(NSDictionary *)event;
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
@property (copy, nonatomic, readonly) NSString *subscriptionID;

/**
 The date at which the subscription is expired by the service.
 */
@property (strong, nonatomic, readonly) NSDate *expiryDate;

/**
 The URL where the service expects subscription calls to be made.
 */
@property (strong, nonatomic, readonly) NSURL *eventSubscriptionURL;

/**
 A timer which fires 30 seconds before the subscription is due to expire, which
 triggers the subscription's manager to resubscribe.
 */
@property (strong, nonatomic, readonly) NSTimer *renewTimer;

/**
 A timer which fires at the subscriptions expiration date, which triggers the
 subscription's manager to attempt to subscribe again or scrap the subscription.
 */
@property (strong, nonatomic, readonly) NSTimer *expirationTimer;

/**
 The manager responsible for making the subscription network calls.
 */
@property (weak, nonatomic) UPPEventSubscriptionManager *manager;


#pragma mark - Initialisation

///-----------------------------------------------------------------------------
/// @name Initialisation
///-----------------------------------------------------------------------------

/**
 Convenience initialiser which returns a new subscription object when passed in
 an event subscription URL.

 @param eventSubscriptionURL The full event subscription URL, which is used when
 resubscribing or unsubscribing from events.

 @return Returns a new subscription object.
 */
+ (instancetype)subscriptionWithSubscriptionURL:(NSURL *)eventSubscriptionURL;

/**
 Convenience initialiser which returns a new subscription object when given a
 subscription identifier, an expiry date and an event subscription URL.

 @param subscriptionID       The subscription identifier returned by the service.
 @param expiryDate           The date at which the subscription is expired by the
 service.
 @param eventSubscriptionURL The full event subscription URL, which is used when
 resubscribing or unsubscribing from events.

 @return Returns a new subscription object.
 */
+ (instancetype)subscriptionWithID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate eventSubscriptionURL:(NSURL *)eventSubscriptionURL;

/**
 Update the object after renewing a subscription.

 @param subscriptionID The subscription identifier returned by the service being
 subscribed to.
 @param expiryDate     The date which the subscription expires. Decided by the
 UPnP service currently being subscribed to.
 */
- (void)updateSubscriptionID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate;


#pragma mark - Events

///-----------------------------------------------------------------------------
/// @name Events
///-----------------------------------------------------------------------------

/**
 Add an observer you wish to be informed of UPnP events.

 @param observer An observer class conforming to `UPPEventSubscriptionDelegate`
 */
- (void)addEventObserver:(id <UPPEventSubscriptionDelegate>)observer;

/**
 Remove a previously added observer, once you no longer wish to be notified of
 new events.

 @param observer An observer class conforming to `UPPEventSubscriptionDelegate`
 */
- (void)removeEventObserver:(id <UPPEventSubscriptionDelegate>)observer;

/**
 An array of event observers.
 */
- (NSArray *)eventObservers;

/**
 Inform all observers of a new event.

 @param event A dictionary containing parsed XML related to the event.
 */
- (void)informObserversOfEvent:(NSDictionary *)event;


#pragma mark - Background Helpers

///-----------------------------------------------------------------------------
/// @name Events
///-----------------------------------------------------------------------------

/**
 Invalidate both expiration and renew subscription timers.
 */
- (void)invalidateTimers;

/**
 Renew both expiration and renew subscription timers after returning from
 background operation.
 */
- (void)renewTimers;

@end
