// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "UPPBasicService.h"
#import "UPPEventSubscription.h"
#import "NSArray+firstObjectMatchingPredicate.h"
#import "UPPError.h"

@interface UPPEventSubscriptionManager ()
@property (strong, nonatomic) NSMutableArray *activeSubscriptions;
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation UPPEventSubscriptionManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken = 0;

    __strong static id _sharedManager = nil;
    dispatch_once(&onceToken, ^{
        NSURLSession *session = [NSURLSession sharedSession];
        _sharedManager = [[self alloc] initWithSession:session];
    });

    return _sharedManager;
}

- (instancetype)initWithSession:(NSURLSession *)session
{
    if ((self = [super init])) {
        self.session = session;
        [self addNotificationObservers];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotificationObservers
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self
           selector:@selector(invalidateAllTimers)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];

    [nc addObserver:self
           selector:@selector(renewAllTimers)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)activeSubscriptions
{
    if (!_activeSubscriptions) {
        _activeSubscriptions = [NSMutableArray array];
    }

    return _activeSubscriptions;
}

- (UPPEventServer *)eventServer
{
    if (!_eventServer) {
        _eventServer = [[UPPEventServer alloc] init];
    }

    return _eventServer;
}

#pragma mark - Public Methods

- (void)subscribeObserver:(id<UPPEventSubscriptionDelegate>)observer toService:(UPPBasicService *)service completion:(void(^)(UPPEventSubscription *subscription, NSError *error))completion
{
    if (![self.eventServer isRunning]) {
        self.eventServer.eventDelegate = self;
        [self.eventServer startServer];
    }

    // If we already have an existing subscription, add the new observer then
    // bail out early.
    UPPEventSubscription *subscription = [self subscriptionWithURL:service.eventSubscriptionURL];
    if (subscription) {
        [subscription addEventObserver:observer];
        if (completion) {
            completion(subscription, nil);
        }
        return;
    }

    // Create a new subscription.
    NSURL *url = service.eventSubscriptionURL;
    subscription = [UPPEventSubscription subscriptionWithSubscriptionURL:url
                                                       serviceIdentifier:service.uniqueServiceName];
    [self subscribe:subscription completion:^(NSString *subscriptionID, NSDate *expiryDate, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            return;
        }
        [subscription updateSubscriptionID:subscriptionID expiryDate:expiryDate];
        [subscription addEventObserver:observer];
        [subscription setManager:self];
        [self.activeSubscriptions addObject:subscription];
        if (completion) {
            completion(subscription, nil);
        }
    }];
}

- (void)subscribe:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion
{
    if (!completion) { return; }

    NSURL *url = subscription.eventSubscriptionURL;
    NSURLRequest *request = [self subscriptionRequestWithEventSubscriptionURL:url];

    [self sendSubscriptionRequest:request completion:^(NSURLResponse *response, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code != 200) {
            if (self.activeSubscriptions.count == 0) {
                [self.eventServer stopServer];
            }
            completion(nil, nil, error);
            return;
        } else {
            NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
            NSString *subId = headers[@"SID"];
            NSDate *expiry = [self dateFromHeader:headers[@"TIMEOUT"]];
            completion(subId, expiry, nil);
        }
    }];
}

- (void)renewSubscription:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion
{
    if (!subscription.subscriptionID) {
        [self subscribe:subscription completion:^(NSString *subscriptionID, NSDate *expiryDate, NSError *error) {
            [subscription updateSubscriptionID:subscriptionID expiryDate:expiryDate];
        }];
        return;
    }
    NSURL *subscriptionURL = subscription.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"SID": [subscription subscriptionID],
                               @"TIMEOUT": @"Second-1800" };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"SUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code != 200) {
            NSError *e = error ?: UPPErrorWithCodeAndDescription(code, @"Renew subscription error");
            completion(nil, nil, e);
            return;
        }

        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        NSString *subscriptionID = headers[@"SID"];
        NSDate *expiryDate = [self dateFromHeader:headers[@"TIMEOUT"]];

        completion(subscriptionID, expiryDate, nil);
    }];

    [task resume];
}

- (void)subscriptionExpired:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion
{
    [self subscribe:subscription completion:completion];
}

- (NSURLRequest *)subscriptionRequestWithEventSubscriptionURL:(NSURL *)url
{
    NSURL *subscriptionURL = url;
    NSString *host = [NSString stringWithFormat:@"%@:%@",
                      [subscriptionURL host],
                      [subscriptionURL port]];

    NSURL *callbackURL = [self.eventServer eventServerCallbackURL];
    NSString *callback = [NSString stringWithFormat:@"<%@>",
                          [callbackURL absoluteString]];

    NSDictionary *headers = @{ @"HOST": host,
                               @"USER-AGENT": @"iOS/8.4 UPnP/1.1 Example/1.0",
                               @"CALLBACK": callback,
                               @"NT": @"upnp:event",
                               @"TIMEOUT": @"Second-1800" };


    return [self requestWithURL:url method:@"SUBSCRIBE" headers:headers];
}

- (void)unsubscribe:(UPPEventSubscription *)subscription completion:(void(^)(BOOL success))completion;
{
    [subscription invalidateTimers];
    [self.activeSubscriptions removeObject:subscription];

    if (!subscription.eventSubscriptionURL || !subscription.subscriptionID) {
        if (completion) { completion(NO); }
        return;
    }

    NSURL *subscriptionURL = subscription.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"SID": [subscription subscriptionID] };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"UNSUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code == 200) {

            if (self.activeSubscriptions.count == 0) {
                [self.eventServer stopServer];
                self.eventServer = nil;
            }
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];

    [task resume];
}

- (void)removeObserver:(id<UPPEventSubscriptionDelegate>)observer fromService:(UPPBasicService *)service completion:(void (^)(BOOL))completion
{
    UPPEventSubscription *subscripton = [self subscriptionWithURL:service.eventSubscriptionURL];

    if (subscripton) {
        [subscripton removeEventObserver:observer];
    }

    if (completion) {
        completion(NO);
    }
}

- (void)removeSubscriptionsForServices:(NSArray *)services deviceId:(NSString *)deviceId
{
    NSMutableArray *subscriptions = [NSMutableArray array];

    for (UPPServiceDescription *service in services) {
        NSString *identifier = [NSString stringWithFormat:@"%@::%@",
                                deviceId, service.serviceType];
        NSArray *objects = [self subscriptionsForServiceIdentifier:identifier];
        [subscriptions addObjectsFromArray:objects];
    }

    if (subscriptions.count == 0) {
        return;
    }

    for (UPPEventSubscription *subscription in subscriptions) {
        [subscription invalidateTimers];
        [self.activeSubscriptions removeObject:subscription];
    }
}

#pragma mark - UPPEventServerDelegate

- (void)eventReceived:(NSDictionary *)event
{
    NSString *sid = event[UPPEventServerSIDKey];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"subscriptionID == %@", sid];
    UPPEventSubscription *subscription = [self.activeSubscriptions upp_firstObjectMatchingPredicate:predicate];

    if (!subscription) {
        return;
    }

    [subscription informObserversOfEvent:event];
}

#pragma mark - Private Methods

- (void)invalidateAllTimers
{
    for (UPPEventSubscription *subscription in [self.activeSubscriptions copy]) {
        [subscription invalidateTimers];
    }
}

- (void)renewAllTimers
{
    for (UPPEventSubscription *subscription in [self.activeSubscriptions copy]) {
        [subscription renewSubscription];
    }
}

- (UPPEventSubscription *)subscriptionWithURL:(NSURL *)url
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventSubscriptionURL = %@", url];
    NSArray *matches = [self.activeSubscriptions filteredArrayUsingPredicate:predicate];

    return [matches firstObject];
}

- (NSArray *)subscriptionsForServiceIdentifier:(NSString *)serviceIdentifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueServiceName = %@", serviceIdentifier];
    return [self.activeSubscriptions filteredArrayUsingPredicate:predicate];
}

- (NSDate *)dateFromHeader:(NSString *)header
{
    if (!header) {
        return nil;
    }

    NSString *timeout = [header stringByReplacingOccurrencesOfString:@"Second-"
                                                          withString:@""];

    return [NSDate dateWithTimeIntervalSinceNow:[timeout doubleValue]];
}

- (void)sendSubscriptionRequest:(NSURLRequest *)request completion:(void (^)(NSURLResponse *response, NSError *error))completion
{
    if (!completion) { return; }
    if (!request) { return; }

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response, error);
        });
    }];

    [task resume];
}

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url method:(NSString *)method headers:(NSDictionary *)headers
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];

    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *header, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:header];
    }];

    return [request copy];
}

@end
