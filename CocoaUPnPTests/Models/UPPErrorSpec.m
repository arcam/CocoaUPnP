// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(UPPError)

describe(@"UPPError", ^{

    it(@"should return an error for empty data", ^{
        NSError *error = UPPErrorWithCode(UPPErrorCodeEmptyData);
        expect(error.code).to.equal(UPPErrorCodeEmptyData);
    });

    it(@"should return an error for no device element", ^{
        NSError *error = UPPErrorWithCode(UPPErrorCodeNoDeviceElementFound);
        expect(error.code).to.equal(UPPErrorCodeNoDeviceElementFound);
    });

    it(@"should return an error for unknown code", ^{
        NSError *error = UPPErrorWithCode(666);
        expect(error.code).to.equal(UPPErrorCodeGeneric);
    });

});

SpecEnd
