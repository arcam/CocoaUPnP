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
@property (copy, nonatomic, readwrite) NSString *uniqueServiceName;
@end

@implementation UPPEventSubscription

#pragma mark - Initialisation

+ (instancetype)subscriptionWithSubscriptionURL:(NSURL *)eventSubscriptionURL serviceIdentifier:(NSString *)uniqueServiceName
{
    return [[[self class] alloc] initWithSubscriptionID:nil
                                             expiryDate:nil
                                   eventSubscriptionURL:eventSubscriptionURL
                                      serviceIdentifier:uniqueServiceName];
}

+ (instancetype)subscriptionWithID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate eventSubscriptionURL:(NSURL *)eventSubscriptionURL serviceIdentifier:(NSString *)uniqueServiceName
{
    return [[[self class] alloc] initWithSubscriptionID:subscriptionID
                                             expiryDate:expiryDate
                                   eventSubscriptionURL:eventSubscriptionURL
                                      serviceIdentifier:uniqueServiceName];
}

- (instancetype)initWithSubscriptionID:(NSString *)subscriptionID expiryDate:(NSDate *)expiryDate eventSubscriptionURL:(NSURL *)eventSubscriptionURL serviceIdentifier:(NSString *)uniqueServiceName
{
    if ((self = [super init])) {
        self.subscriptionID = subscriptionID;
        self.eventSubscriptionURL = eventSubscriptionURL;
        [self updateTimersWithExpiryDate:expiryDate];
        self.uniqueServiceName = uniqueServiceName;
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

- (void)invalidateTimers
{
    [self.expirationTimer invalidate];
    [self.renewTimer invalidate];

    self.expirationTimer = nil;
    self.renewTimer = nil;
}

- (void)updateTimersWithExpiryDate:(NSDate *)expiryDate
{
    [self invalidateTimers];
    self.expiryDate = expiryDate;

    self.expirationTimer = [self timerWithInterval:[expiryDate timeIntervalSinceNow]
                                          selector:@selector(subscriptionExpired)];

    NSDate *renewTime = [expiryDate dateByAddingTimeInterval:-30];
    self.renewTimer = [self timerWithInterval:[renewTime timeIntervalSinceNow]
                                     selector:@selector(renewSubscription)];
}

- (NSTimer *)timerWithInterval:(NSTimeInterval)interval selector:(SEL)selector
{
    return [NSTimer scheduledTimerWithTimeInterval:interval
                                            target:self
                                          selector:selector
                                          userInfo:nil
                                           repeats:NO];
}

- (void)renewSubscription
{
    // It seems some devices have issues with renewing subscriptions. After
    // sending renew subscription, AV Transport will return 705 - Access Denied.
    // Easiest way round this is to just fully renew the subscription each time.
    [self subscriptionExpired];
}

- (void)subscriptionExpired
{
    [self.manager subscriptionExpired:self completion:^(NSString *subscriptionID, NSDate *expiryDate, NSError *error) {
        self.subscriptionID = subscriptionID;
        self.expiryDate = expiryDate;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateTimersWithExpiryDate:expiryDate];
        });
    }];
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
        [self.manager unsubscribe:self completion:nil];
    }
}

- (void)informObserversOfEvent:(NSDictionary *)event
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<UPPEventSubscriptionDelegate> observer in self.observers) {
            [observer eventRecieved:event];
        }
    });
}

@end
