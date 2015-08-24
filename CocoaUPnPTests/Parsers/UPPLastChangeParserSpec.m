// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPLastChangeParser.h"
#import "UPPError.h"
#import "UPPMediaItem.h"

NSData *(^StubEventWithTransportState)(NSString *) = ^NSData * (NSString *transportState) {

    NSString *string = [NSString stringWithFormat:
                        @"<Event xmlns=\"urn:schemas-upnp-org:metadata-1-0/AVT/\">"
                        @"<InstanceID val=\"0\">"
                        @"<TransportState val=\"%@\"/>"
                        @"</InstanceID>"
                        @"</Event>", transportState];

    return [string dataUsingEncoding:NSUTF8StringEncoding];
};

SpecBegin(UPPLastChangeParser)

describe(@"UPPLastChangeParser", ^{

    it(@"should parse last change xml", ^{
        NSData *data = LoadDataFromXML(@"LastChangeFull", [self class]);
        expect(data).toNot.beNil();

        waitUntil(^(DoneCallback done) {
            [UPPLastChangeParser parseData:data completion:^(NSDictionary *event, NSError *error) {
                expect(error).to.beNil();
                expect(event).toNot.beNil();
                expect(event[@"PlaybackStorageMedium"]).to.equal(@"NETWORK");
                expect(event[@"TransportState"]).to.equal(@"STOPPED");
                expect(event[@"CurrentTransportActions"]).to.equal(@"Play");
                expect(event[@"NumberOfTracks"]).to.equal(@"1");
                expect(event[@"CurrentTrack"]).to.equal(@"1");

                NSString *url = @"http://10.54.6.186:80/UPnP/Track/20390.WAV";
                expect(event[@"AVTransportURI"]).to.equal(url);
                expect(event[@"CurrentTrackURI"]).to.equal(url);

                NSString *duration = @"00:04:22";
                expect(event[@"CurrentMediaDuration"]).to.equal(duration);
                expect(event[@"CurrentTrackDuration"]).to.equal(duration);

                UPPMediaItem *currentTrack = event[@"CurrentTrackMetaData"];
                expect(currentTrack).toNot.beNil();
                expect(currentTrack.itemTitle).to.equal(@"Still Echoes");

                UPPMediaItem *transportMetadata = event[@"AVTransportURIMetaData"];
                expect(transportMetadata).toNot.beNil();
                expect(transportMetadata.itemTitle).to.equal(@"Still Echoes");
                done();
            }];
        });
    });

    it(@"should return an error when no data set", ^{
        waitUntil(^(DoneCallback done) {
            [UPPLastChangeParser parseData:nil completion:^(NSDictionary *event, NSError *error) {
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeEmptyData);
                expect(event).to.beNil();
                done();
            }];
        });
    });
});

SpecEnd
