// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventSubscriptionManager.h"
#import "UPPBasicService.h"

@implementation UPPEventSubscriptionManager

- (NSURL *)callbackURL
{
    return [NSURL URLWithString:@"http://123.123.123.123/Event"];
}

- (void)subscribeObject:(id<UPPEventSubscriptionDelegate>)object toService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *subscriptionURL = service.eventSubscriptionURL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:subscriptionURL];
    [request setHTTPMethod:@"SUBSCRIBE"];

    [request setValue:[subscriptionURL absoluteString] forHTTPHeaderField:@"HOST"];
    [request setValue:@"iOS/8.4 UPnP/1.1 Example/1.0" forHTTPHeaderField:@"USER-AGENT"];
    [request setValue:[[self callbackURL] absoluteString] forHTTPHeaderField:@"CALLBACK"];
    [request setValue:@"upnp:event" forHTTPHeaderField:@"NT"];
    [request setValue:@"Second-1800" forHTTPHeaderField:@"TIMEOUT"];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code == 200) {
            completion(YES);
        } else {
            completion(NO);
        }
    }];

    [task resume];
}

- (void)renewSubscription:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion;
{

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *subscriptionURL = subscription.eventSubscriptionURL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:subscriptionURL];
    [request setHTTPMethod:@"SUBSCRIBE"];

    [request setValue:[subscriptionURL absoluteString] forHTTPHeaderField:@"HOST"];
    [request setValue:[subscription subscriptionID] forHTTPHeaderField:@"SID"];
    [request setValue:@"Second-1800" forHTTPHeaderField:@"TIMEOUT"];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        if ([(NSHTTPURLResponse *)response statusCode] != 200) {
            completion(nil, nil, error);
        }

        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        completion(headers[@"SID"], [self dateFromHeader:headers[@"TIMEOUT"]], nil);
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:subscriptionURL];
    [request setHTTPMethod:@"UNSUBSCRIBE"];

    [request setValue:[subscriptionURL absoluteString] forHTTPHeaderField:@"HOST"];
    [request setValue:[subscription subscriptionID] forHTTPHeaderField:@"SID"];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!completion) { return; }

        NSInteger code = [(NSHTTPURLResponse *)response statusCode];

        if (code == 200) {
            completion(YES);
        } else {
            completion(NO);
        }
    }];

    [task resume];
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

@end
