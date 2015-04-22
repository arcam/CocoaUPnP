// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPContentDirectoryService.h"
#import "UPPConstants.h"
#import "UPPSessionManager.h"
#import "NetworkTestHelpers.h"

SpecBegin(UPPContentDirectoryService)

describe(@"UPPContentDirectoryService", ^{
    
    __block UPPContentDirectoryService *service;
    __block id sessionManager;
    __block NSString *url;
    
    beforeEach(^{
        service = [[UPPContentDirectoryService alloc] init];
        service.nameSpace = @"urn:schemas-upnp-org:service:ContentDirectory:1";
        
        sessionManager = OCMClassMock([UPPSessionManager class]);
        service.sessionManager = sessionManager;
        
        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;
    });
    
    describe(@"when getting search capabilities", ^{
        it(@"should send required parameters", ^{
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"GetSearchCapabilities",
                                              UPPNameSpaceKey: service.nameSpace };
            
            VerifyGetPostWithParams(expectedParams, sessionManager, url);
            
            [service searchCapabilitiesWithCompletion:^(NSDictionary *response, NSError *error) {
                expect(response[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];
            
            [sessionManager verify];
        });
    });
    
    describe(@"when getting sort capabilities", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when getting system update id", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when browsing directory", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when searching directory", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when creating object", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when destroying object", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when updating object", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when importing resource", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when exporting resource", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when stopping transfer resource", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when getting transfer progress", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when deleting resource", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
    describe(@"when creating reference", ^{
        xit(@"should send required parameters", ^{
        });
    });
    
});

SpecEnd
