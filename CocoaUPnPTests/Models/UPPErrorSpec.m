
#import "UPPError.h"

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
