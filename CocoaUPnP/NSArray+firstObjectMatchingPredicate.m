// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "NSArray+firstObjectMatchingPredicate.h"

@implementation NSArray (firstObjectMatchingPredicate)

- (id)upp_firstObjectMatchingPredicate:(NSPredicate *)predicate
{
    return [[self filteredArrayUsingPredicate:predicate] firstObject];
}

@end
