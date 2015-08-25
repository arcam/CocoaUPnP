// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPEventSubscription.h"
#import "UPPEventServer.h"

@class UPPBasicService;

@interface UPPEventSubscriptionManager : NSObject <UPPEventServerDelegate>

@property (strong, nonatomic) UPPEventServer *eventServer;

- (void)subscribeObserver:(id<UPPEventSubscriptionDelegate>)object toService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;
- (void)renewSubscription:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion;
- (void)subscriptionExpired:(UPPEventSubscription *)subscription completion:(void(^)(BOOL success))completion;
- (void)unsubscribe:(UPPEventSubscription *)subscription completion:(void(^)(BOOL success))completion;

@end
