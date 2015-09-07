// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        Class appDelegateClass = NSClassFromString(@"UPPTestAppDelegate");
        if (appDelegateClass == nil) {
            appDelegateClass = [AppDelegate class];
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
