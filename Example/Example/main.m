// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if (NSClassFromString(@"XCTestCase") != nil) {
            return UIApplicationMain(argc, argv, nil, @"UPPTestAppDelegate");
        }

        return UIApplicationMain(argc, argv, nil, @"AppDelegate");
    }
}
