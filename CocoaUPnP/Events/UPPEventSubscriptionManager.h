// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPEventSubscription.h"

@class UPPBasicService;

@interface UPPEventSubscriptionManager : NSObject

- (NSURL *)callbackURL;
- (void)subscribeObject:(id<UPPEventSubscriptionDelegate>)object toService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;

- (void)renewSubscription:(UPPEventSubscription *)subscription;
- (void)subscriptionExpired:(UPPEventSubscription *)subscription;
- (void)unsubscribe:(UPPEventSubscription *)subscription;

@end
