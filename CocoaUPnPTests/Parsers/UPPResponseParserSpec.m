// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPResponseParser.h"
#import "UPPError.h"

SpecBegin(UPPResponseParser)

describe(@"UPPResponseParser", ^{
    
    __block UPPResponseParser *parser;
    
    it(@"should parse a basic response", ^{
        NSData *data =  LoadDataFromXML(@"GetConnectionID", [self class]);
        parser = [[UPPResponseParser alloc] initWithXMLData:data];
        waitUntil(^(DoneCallback done) {
            [parser parseWithResponse:^(NSDictionary *response, NSError *error) {
                expect(error).to.beNil();
                expect(response).toNot.beNil();
                expect(response.count).to.equal(1);
                expect(response[@"ConnectionIDs"]).to.equal(@"0");
                done();
            }];
        });
    });
    
    it(@"should return early with no data", ^{
        parser = [[UPPResponseParser alloc] initWithXMLData:nil];
        waitUntil(^(DoneCallback done) {
            [parser parseWithResponse:^(NSDictionary *response, NSError *error) {
                expect(response).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeEmptyData);
                done();
            }];
        });
    });
});

SpecEnd
