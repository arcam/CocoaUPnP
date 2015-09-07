// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@interface NSArray (firstObjectMatchingPredicate)

/**
 Return the first object that matches the predicate.

 @param predicate The predicate to match objects against.

 @return Returns the first match or nil if no matching objects are found.
 */
- (id)upp_firstObjectMatchingPredicate:(NSPredicate *)predicate;

@end
