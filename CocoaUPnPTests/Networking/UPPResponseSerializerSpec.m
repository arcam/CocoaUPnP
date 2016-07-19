// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <AFNetworking/AFNetworking.h>
#import <CocoaUPnP/CocoaUPnP.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import "TestHelpers.h"

SpecBegin(UPPResponseSerializer)

describe(@"UPPResponseSerializer", ^{

    __block UPPResponseSerializer *serialiser;

    beforeEach(^{
        serialiser = [[UPPResponseSerializer alloc] init];
    });

    // We should really insert a mock for the parser
    it(@"should partially parse the response", ^{
        NSData *data = LoadDataFromXML(@"GetConnectionID", [self class]);

        NSError *error = nil;
        id response = [serialiser responseObjectForResponse:nil data:data error:&error];

        expect(error).to.beNil();
        expect(response).toNot.beNil();
        expect(response[@"ConnectionIDs"]).to.equal(@"0");
    });

    it(@"should parse errors", ^{
        NSData *data = LoadDataFromXML(@"Error", [self class]);
        NSHTTPURLResponse *httpResponse;
        httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://127.0.0.1"]
                                                   statusCode:500
                                                  HTTPVersion:nil
                                                 headerFields:nil];

        NSError *error = nil;
        id response = [serialiser responseObjectForResponse:httpResponse data:data error:&error];

        expect(error).toNot.beNil();
        expect(response).to.beNil();
    });

});

SpecEnd
