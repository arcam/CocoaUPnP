// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "UPPBasicService.h"
#import "UPPEventSubscription.h"

@interface UPPEventSubscriptionManager ()
@property (strong, nonatomic) NSMutableArray *activeSubscriptions;
@end

@implementation UPPEventSubscriptionManager

- (NSURL *)callbackURL
{
    return [NSURL URLWithString:@"http://123.123.123.123/Event"];
}

- (void)subscribeObserver:(id<UPPEventSubscriptionDelegate>)observer toService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;
{
    UPPEventSubscription *subscripton = [self subscriptionWithURL:service.eventSubscriptionURL];
    if (subscripton) {
        [subscripton addEventObserver:observer];
        if (completion) {
            completion(YES); // This probably should return an error when NO
        }
        return;
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *subscriptionURL = service.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"USER-AGENT": @"iOS/8.4 UPnP/1.1 Example/1.0",
                               @"CALLBACK": [[self callbackURL] absoluteString],
                               @"NT": @"upnp:event",
                               @"TIMEOUT": @"Second-1800" };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"SUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code != 200) {
            completion(NO);
        }

        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        UPPEventSubscription *subscription;
        subscription = [self subscriptionWithURL:subscriptionURL
                                         headers:headers
                                        observer:observer];
        [self.activeSubscriptions addObject:subscription];
        completion(YES);
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

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *subscriptionURL = subscription.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"SID": [subscription subscriptionID],
                               @"TIMEOUT": @"Second-1800" };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"SUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

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
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *subscriptionURL = subscription.eventSubscriptionURL;

    NSDictionary *headers = @{ @"HOST": [subscriptionURL absoluteString],
                               @"SID": [subscription subscriptionID] };

    NSMutableURLRequest *request = [self requestWithURL:subscriptionURL
                                                 method:@"UNSUBSCRIBE"
                                                headers:headers];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code == 200) {
            [self.activeSubscriptions removeObject:subscription];
            completion(YES);
        } else {
            completion(NO);
        }
    }];

    [task resume];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)activeSubscriptions
{
    if (!_activeSubscriptions) {
        _activeSubscriptions = [NSMutableArray array];
    }

    return _activeSubscriptions;
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
