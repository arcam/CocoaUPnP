// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPLastChangeParser.h"
#import "UPPError.h"

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

        NSData *data = LoadDataFromXML(@"LastChangeTransport", [self class]);
        expect(data).toNot.beNil();

        UPPLastChangeParser *parser = [[UPPLastChangeParser alloc] initWithXMLData:data];

        waitUntil(^(DoneCallback done) {
            [parser parseWithCompletion:^(UPPTransportState transportState, NSString *transportActions, NSError *error) {
                expect(error).to.beNil();
                expect(transportState).to.equal(UPPTransportStatePlaying);
                expect(transportActions).to.equal(@"Pause,Stop,Next,Previous,Seek,X_DLNA_SeekTime");
                done();
            }];

        });

    });

    it(@"should return an error when no data set", ^{

        UPPLastChangeParser *parser = [[UPPLastChangeParser alloc] init];

        waitUntil(^(DoneCallback done) {

            [parser parseWithCompletion:^(UPPTransportState transportState, NSString *transportActions, NSError *error) {
                expect(transportState).to.equal(UPPTransportStateUnknown);
                expect(transportActions).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeEmptyData);
                done();
            }];

        });

    });

    void (^TestStateEquality)(NSString *, UPPTransportState) = ^void(NSString *string, UPPTransportState state) {
        NSData *data = StubEventWithTransportState(string);
        UPPLastChangeParser *parser = [[UPPLastChangeParser alloc] initWithXMLData:data];
        waitUntil(^(DoneCallback done) {
            [parser parseWithCompletion:^(UPPTransportState transportState, NSString *transportActions, NSError *error) {
                expect(transportState).to.equal(state);
                done();
            }];
        });
    };

    it(@"should parse stopped playing state", ^{
        TestStateEquality(@"STOPPED", UPPTransportStateStopped);
    });

    it(@"should parse transitioning state", ^{
        TestStateEquality(@"TRANSITIONING", UPPTransportStateTransitioning);
    });

    it(@"should parse paused state", ^{
        TestStateEquality(@"PAUSED_PLAYBACK", UPPTransportStatePaused);
    });

    it(@"should parse no media present state", ^{
        TestStateEquality(@"NO_MEDIA_PRESENT", UPPTransportStateNoMediaPresent);
    });

    it(@"should parse unknown transport state", ^{
        TestStateEquality(@"RECORDING", UPPTransportStateUnknown);
    });

});

SpecEnd
