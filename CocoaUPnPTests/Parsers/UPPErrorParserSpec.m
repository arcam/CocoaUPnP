
#import "UPPErrorParser.h"
#import "UPPError.h"

SpecBegin(UPPErrorParser)

describe(@"UPPErrorParser", ^{
    
    it(@"should return an NSError object when given an error XML", ^{
        
        NSData *data = LoadDataFromXML(@"Error", [self class]);
        expect(data).toNot.beNil();
        
        NSError *error = [UPPErrorParser parseErrorXML:data];
        expect(error).toNot.beNil();
        expect(error.domain).to.equal(UPPErrorDomain);
        expect(error.code).to.equal(UPPErrorCodeUPnPErrorReturned);
        expect(error.localizedDescription).to.equal(@"718 - Invalid instance ID");

    });
    
    it(@"should return nil when no data passed in", ^{
        
        NSError *error = [UPPErrorParser parseErrorXML:nil];
        expect(error).to.beNil();
        
    });
    
});

SpecEnd
