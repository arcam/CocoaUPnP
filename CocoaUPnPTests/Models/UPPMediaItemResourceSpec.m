// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(UPPMediaItemResource)

describe(@"UPPMediaItemResource", ^{

    __block UPPMediaItemResource *res;

    beforeEach(^{
        res = [[UPPMediaItemResource alloc] init];
        res.numberOfAudioChannels = @"2";
        res.bitrate = @"40000";
        res.duration = @"01:59:21.0000";
        res.sampleFrequency = @"44100";
        res.protocolInfo = @"protocol";
        res.itemSize = @"123456789";
        res.resourceURLString = @"http://127.0.0.1";
    });

    it(@"should allow setting number of channels", ^{
        expect(res.numberOfAudioChannels).to.equal(@"2");
    });

    it(@"should allow setting bitrate", ^{
        expect(res.bitrate).to.equal(@"40000");
    });

    it(@"should allow setting duration", ^{
        expect(res.duration).to.equal(@"01:59:21.0000");
    });

    it(@"should allow setting sample frequency", ^{
        expect(res.sampleFrequency).to.equal(@"44100");
    });

    it(@"should allow setting protocol info", ^{
        expect(res.protocolInfo).to.equal(@"protocol");
    });

    it(@"should allow setting item size", ^{
        expect(res.itemSize).to.equal(@"123456789");
    });

    it(@"should allow setting resource url string", ^{
        expect(res.resourceURLString).to.equal(@"http://127.0.0.1");
    });

    describe(@"NSCopying", ^{
        it(@"should conform to NSCopying", ^{
            expect(res).to.conformTo(@protocol(NSCopying));
        });

        it(@"should implement copyWithZone", ^{
            UPPMediaItemResource *newRes = [res copy];
            expect(newRes).toNot.beIdenticalTo(res);
            expect(newRes.numberOfAudioChannels).to.equal(res.numberOfAudioChannels);
            expect(newRes.bitrate).to.equal(res.bitrate);
            expect(newRes.duration).to.equal(res.duration);
            expect(newRes.sampleFrequency).to.equal(res.sampleFrequency);
            expect(newRes.protocolInfo).to.equal(res.protocolInfo);
            expect(newRes.itemSize).to.equal(res.itemSize);
            expect(newRes.resourceURLString).to.equal(res.resourceURLString);
        });
    });
});

SpecEnd
