// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPBasicService;

@interface UPPEventSubscriptionManager : NSObject

- (NSURL *)callbackURL;
- (void)subscribeObject:(id)object toService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;

@end
