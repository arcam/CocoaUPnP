// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "EXPMatchers+beWithinAMillisecondOf.h"

EXPMatcherImplementationBegin(beWithinAMillisecondOf, (NSDate *expected)) {

    prerequisite(^BOOL {
        return [actual isKindOfClass:[NSDate class]] &&
               [expected isKindOfClass:[NSDate class]];
    });

    match(^BOOL {
        NSTimeInterval interval = [expected timeIntervalSinceDate:actual];
        return interval < 0.01;
    });

    failureMessageForTo(^NSString * {
        if (actual == nil)
            return @"the actual value is nil/null";
        if (expected == nil)
            return @"the expected value is nil/null";
        return [NSString
                stringWithFormat:@"expected %@ to be within a millisecond of %@, got within %@",
                expected, actual, @([expected timeIntervalSinceDate:actual])];
        // Return the message to be displayed when the match function returns `YES`.
    });
}

EXPMatcherImplementationEnd;
