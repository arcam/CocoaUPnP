// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "UPPBasicService.h"
#import "UPPEventSubscription.h"
#import "NSArray+firstObjectMatchingPredicate.h"

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
    }

    return self;
}

- (void)subscribeObserver:(id<UPPEventSubscriptionDelegate>)observer toService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;
{
    if (![self.eventServer isRunning]) {
        self.eventServer.eventDelegate = self;
        [self.eventServer startServer];
    }

    UPPEventSubscription *subscripton = [self subscriptionWithURL:service.eventSubscriptionURL];
    if (subscripton) {
        [subscripton addEventObserver:observer];
        if (completion) {
            completion(YES); // This probably should return an error when NO
        }
        return;
    }

    NSURL *subscriptionURL = service.eventSubscriptionURL;
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

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"SUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger code = [(NSHTTPURLResponse *)response statusCode];

            if (code != 200) {
                if (self.activeSubscriptions.count == 0) {
                    [self.eventServer stopServer];
                }
                if (completion) {
                    completion(NO);
                }
                return;
            }

            NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
            UPPEventSubscription *subscription;
            subscription = [self subscriptionWithURL:subscriptionURL
                                             headers:headers
                                            observer:observer];
            [self.activeSubscriptions addObject:subscription];
            if (completion) {
                completion(YES);
            }
        });
    }];

    [task resume];
}

- (UPPEventSubscription *)subscriptionWithURL:(NSURL *)url
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventSubscriptionURL = %@", url];
    NSArray *matches = [self.activeSubscriptions filteredArrayUsingPredicate:predicate];

    return [matches firstObject];
}

- (void)renewSubscription:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion;
{
    NSURL *subscriptionURL = subscription.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"SID": [subscription subscriptionID],
                               @"TIMEOUT": @"Second-1800" };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"SUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            completion(nil, nil, error);
        }

        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        NSString *subscriptionID = headers[@"SID"];
        NSDate *expiryDate = [self dateFromHeader:headers[@"TIMEOUT"]];

        completion(subscriptionID, expiryDate, nil);
    }];

    [task resume];
}

- (void)subscriptionExpired:(UPPEventSubscription *)subscription completion:(void(^)(BOOL success))completion;
{

}

- (void)unsubscribe:(UPPEventSubscription *)subscription completion:(void(^)(BOOL success))completion;
{
    NSURL *subscriptionURL = subscription.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"SID": [subscription subscriptionID] };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"UNSUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code == 200) {
            [self.activeSubscriptions removeObject:subscription];

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
    [subscripton removeEventObserver:observer];

    if ([subscripton eventObservers].count == 0) {
        [self unsubscribe:subscripton completion:nil];
    }

    if (completion) {
        completion(NO);
    }
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

- (NSDate *)dateFromHeader:(NSString *)header
{
    if (!header) {
        return nil;
    }

    NSString *timeout = [header stringByReplacingOccurrencesOfString:@"Second-"
                                                          withString:@""];

    return [NSDate dateWithTimeIntervalSinceNow:[timeout doubleValue]];
}

- (UPPEventSubscription *)subscriptionWithURL:(NSURL *)subscriptionURL headers:(NSDictionary *)headers observer:(id<UPPEventSubscriptionDelegate>)observer
{
    UPPEventSubscription *subscription;
    subscription = [UPPEventSubscription subscriptionWithID:headers[@"SID"]
                                                 expiryDate:[self dateFromHeader:headers[@"TIMEOUT"]]
                                       eventSubscriptionURL:subscriptionURL];
    [subscription setManager:self];
    [subscription addEventObserver:observer];

    return subscription;
}

- (NSMutableURLRequest *)requestWithURL:(NSURL *)url method:(NSString *)method headers:(NSDictionary *)headers
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];

    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *header, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:header];
    }];

    return request;
}

@end
