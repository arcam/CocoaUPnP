
#import "UPPService.h"

SpecBegin(UPPService)

describe(@"UPPService", ^{
    
    __block UPPService *service;
    
    beforeEach(^{
        service = [[UPPService alloc] init];
        service.serviceType = @"serviceType";
        service.serviceId = @"id";
        service.descriptionURL = @"http://127.0.0.1";
        service.controlURL = @"/Control";
        service.eventSubURL = @"/EventSub";
    });
    
    it(@"should allow setting service type", ^{
        expect(service.serviceType).to.equal(@"serviceType");
    });  
    
    it(@"should allow setting service id", ^{
        expect(service.serviceId).to.equal(@"id");
    });  
    
    it(@"should allow setting description url", ^{
        expect(service.descriptionURL).to.equal(@"http://127.0.0.1");
    });  
    
    it(@"should allow setting control url", ^{
        expect(service.controlURL).to.equal(@"/Control");
    });  
    
    it(@"should allow setting event sub url", ^{
        expect(service.eventSubURL).to.equal(@"/EventSub");
    });  
    
});

SpecEnd
