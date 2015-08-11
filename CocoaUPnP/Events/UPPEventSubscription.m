// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscription.h"
#import "UPPEventSubscriptionManager.h"

@interface UPPEventSubscription ()
@property (strong, nonatomic) NSMutableArray *observers;
@property (copy, nonatomic, readwrite) NSString *subscriptionID;
@property (strong, nonatomic, readwrite) NSDate *expiryDate;
@property (strong, nonatomic, readwrite) NSURL *eventSubscriptionURL;
@property (strong, nonatomic, readwrite) NSTimer *renewTimer;
@property (strong, nonatomic, readwrite) NSTimer *expirationTimer;
@end

@implementation UPPEventSubscription

#pragma mark - Initialisation

+ (instancetype)subscriptionWithID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate eventSubscriptionURL:(NSURL *)eventSubscriptionURL
{
    return [[[self class] alloc] initWithSubscriptionID:subscriptionID
                                             expiryDate:expiryDate
                                   eventSubscriptionURL:eventSubscriptionURL];
}

- (instancetype)initWithSubscriptionID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate eventSubscriptionURL:(NSURL *)eventSubscriptionURL
{
    if ((self = [super init])) {
        self.subscriptionID = subscriptionID;
        self.expiryDate = expiryDate;
        self.eventSubscriptionURL = eventSubscriptionURL;
        [self updateTimersWithExpiryDate:expiryDate];
    }
    return self;
}

- (void)updateSubscriptionID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate
{
    if (![self.subscriptionID isEqualToString:subscriptionID]) {
        self.subscriptionID = subscriptionID;
    }
    [self updateTimersWithExpiryDate:expiryDate];
}

#pragma mark - Timers

- (void)updateTimersWithExpiryDate:(NSDate *)expiryDate
{
    self.expirationTimer = [self timerWithFireDate:expiryDate
                                          selector:@selector(subscriptionExpired)];

    self.renewTimer = [self timerWithFireDate:[expiryDate dateByAddingTimeInterval:-30]
                                     selector:@selector(renewSubscription)];
}

- (NSTimer *)timerWithFireDate:(NSDate *)date selector:(SEL)selector
{
    return [[NSTimer alloc] initWithFireDate:date
                                    interval:0
                                      target:self
                                    selector:selector
                                    userInfo:nil
                                     repeats:NO];
}

- (void)renewSubscription
{
    [self.manager renewSubscription:self];
}

- (void)subscriptionExpired
{
    [self.manager subscriptionExpired:self];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)observers
{
    if (!_observers) {
        _observers = [NSMutableArray array];
    }
    return _observers;
}

#pragma mark - Methods

- (NSArray *)eventObservers
{
    return [self.observers copy];
}

- (void)addEventObserver:(id<UPPEventSubscriptionDelegate>)observer
{
    if ([self.observers containsObject:observer]) {
        return;
    }

    if ([observer conformsToProtocol:@protocol(UPPEventSubscriptionDelegate)]) {
        [self.observers addObject:observer];
    }
}

- (void)removeEventObserver:(id<UPPEventSubscriptionDelegate>)observer
{
    if (![self.observers containsObject:observer]) {
        return;
    }

    [self.observers removeObject:observer];

    if (self.observers.count == 0) {
        [self.manager unsubscribe:self];
    }
}

- (void)informObserversOfEvent:(NSDictionary *)event
{
    for (id<UPPEventSubscriptionDelegate> observer in self.observers) {
        [observer eventRecieved:event];
    }
}

@end
