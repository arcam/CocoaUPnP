// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPSessionManager.h"
#import "UPPRequestSerializer.h"
#import "UPPResponseSerializer.h"

SpecBegin(UPPSessionManager)

describe(@"UPPSessionManager", ^{

    __block UPPSessionManager *manager;

    beforeEach(^{
        manager = [UPPSessionManager manager];
    });

    it(@"should be instantiated with a base URL", ^{
        NSURL *url = [NSURL URLWithString:@"http://www.google.com"];

        UPPSessionManager *manager = [[UPPSessionManager alloc]
                                      initWithBaseURL:url];

        expect(manager.baseURL).to.equal(url);
    });

    it(@"should have a request serialiser", ^{
        expect(manager.requestSerializer).to.beKindOf([UPPRequestSerializer class]);
    });

    it(@"should have a response serialiser", ^{
        expect(manager.responseSerializer).to.beKindOf([UPPResponseSerializer class]);
    });
});

SpecEnd
