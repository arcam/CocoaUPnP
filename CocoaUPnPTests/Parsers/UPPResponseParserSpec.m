// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>

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

    it(@"should parse any metadata blocks", ^{
        NSData *data =  LoadDataFromXML(@"GetPositionInfoResponse", [self class]);
        parser = [[UPPResponseParser alloc] initWithXMLData:data];
        waitUntil(^(DoneCallback done) {
            [parser parseWithResponse:^(NSDictionary *response, NSError *error) {
                expect(error).to.beNil();
                expect(response).toNot.beNil();
                expect(response[@"Track"]).to.equal(@"1");
                expect(response[@"TrackDuration"]).to.equal(@"0:01:49.440");
                expect(response[@"TrackURI"]).to.equal(@"http://10.54.6.197:9790/minimserver/*/music/FLAC/Eluveitie/Slania/01*20Samon.flac");
                expect(response[@"RelTime"]).to.equal(@"00:00:05");
                expect(response[@"AbsTime"]).to.equal(@"00:00:05");
                expect(response[@"RelCount"]).to.equal(@"2147483647");
                expect(response[@"AbsCount"]).to.equal(@"2147483647");

                UPPMediaItem *item = response[@"TrackMetaData"];
                expect(item).toNot.beNil();
                expect(item).to.beKindOf([UPPMediaItem class]);
                expect(item.objectID).to.equal(@"0$=Genre$4768$albums$*a411$*i4386");

                done();
            }];
        });
    });
});

SpecEnd
