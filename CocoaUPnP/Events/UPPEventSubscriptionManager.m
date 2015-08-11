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
        NSInteger code = [(NSHTTPURLResponse *)response statusCode];
        if (code == 200) {
            completion(YES);
        } else {
            completion(NO);
        }
    }];

    [task resume];
}

- (void)renewSubscription:(UPPEventSubscription *)subscription
{

}

- (void)subscriptionExpired:(UPPEventSubscription *)subscription
{

}

- (void)unsubscribe:(UPPEventSubscription *)subscription
{
    
}

@end
