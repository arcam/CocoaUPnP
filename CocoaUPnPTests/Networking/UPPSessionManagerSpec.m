// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPSessionManager.h"

SpecBegin(UPPSessionManager)

describe(@"UPPSessionManager", ^{
    
    it(@"should be instantiated with a base URL", ^{
        NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
        
        UPPSessionManager *manager = [[UPPSessionManager alloc]
                                      initWithBaseURL:url];
        
        expect(manager.baseURL).to.equal(url);
    });
    
});

SpecEnd
