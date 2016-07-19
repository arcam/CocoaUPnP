// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <OCMock/OCMock.h>
#import "EXPMatchers+beWithinAMillisecondOf.h"
#import <CocoaUPnP/CocoaUPnP.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(UPPEventSubscription)

describe(@"UPPEventSubscription", ^{

    __block UPPEventSubscription *sut;
    __block NSString *subscriptionID;
    __block NSDate *expiryDate;
    __block NSURL *subscriptionURL;
    __block NSString *serviceUDN;

    beforeEach(^{
        subscriptionID = @"uuid:123456";
        expiryDate = [NSDate date];
        serviceUDN = @"udn:1234:abcd";
        subscriptionURL = [NSURL URLWithString:@"http://127.0.0.1/Event/"];
        sut = [UPPEventSubscription subscriptionWithID:subscriptionID
                                            expiryDate:expiryDate
                                  eventSubscriptionURL:subscriptionURL
                                     serviceIdentifier:serviceUDN];
        expect(sut).toNot.beNil();
    });

    it(@"should store a connection ID", ^{
        expect([sut subscriptionID]).to.equal(subscriptionID);
    });

    it(@"should store the expiry time", ^{
        expect([sut expiryDate]).to.equal(expiryDate);
    });

    it(@"should store event subscription URL", ^{
        expect([sut eventSubscriptionURL]).to.equal(subscriptionURL);
    });

    it(@"should store unique service name", ^{
        expect(sut.uniqueServiceName).to.equal(serviceUDN);
    });

    it(@"should have a basic initialiser", ^{
        sut = [UPPEventSubscription subscriptionWithSubscriptionURL:subscriptionURL
                                                  serviceIdentifier:serviceUDN];
        expect([sut subscriptionID]).to.beNil();
        expect([sut expiryDate]).to.beNil();
        expect([sut eventSubscriptionURL]).to.equal(subscriptionURL);
        expect(sut.uniqueServiceName).to.equal(serviceUDN);
    });

    describe(@"when storing observers", ^{

        __block id mockObserver;

        beforeEach(^{
            expect([[sut eventObservers] count]).to.equal(0);
            mockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
            [sut addEventObserver:mockObserver];
        });

        it(@"should store new observers", ^{
            expect([[sut eventObservers] count]).to.equal(1);
        });

        it(@"should not duplicate known observers", ^{
            [sut addEventObserver:mockObserver];
            expect([[sut eventObservers] count]).to.equal(1);
        });
    });

    describe(@"when removing observers", ^{

        __block id mockObserver;

        beforeEach(^{
            expect([[sut eventObservers] count]).to.equal(0);
            mockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
            [sut addEventObserver:mockObserver];
        });

        it(@"should remove known observers", ^{
            [sut removeEventObserver:mockObserver];
            expect([[sut eventObservers] count]).to.equal(0);
        });

        it(@"should not attempt to remove unknown observers", ^{
            id anotherMockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
            [sut removeEventObserver:anotherMockObserver];
            expect([[sut eventObservers] count]).to.equal(1);
        });

        it(@"should tell manager to unsubscribe when no observers are left", ^{
            id mockManager = OCMClassMock([UPPEventSubscriptionManager class]);
            OCMExpect([mockManager unsubscribe:sut completion:[OCMArg any]]);
            sut.manager = mockManager;

            [sut removeEventObserver:mockObserver];

            OCMVerifyAll(mockManager);
        });
    });

    describe(@"renewal timer", ^{

        __block NSTimer *timer;

        beforeEach(^{
            timer = [sut renewTimer];
            expect(timer).toNot.beNil();
        });

        it(@"should fire 30 seconds before expiration", ^{
            expect([timer fireDate]).to.beWithinAMillisecondOf([expiryDate dateByAddingTimeInterval:-30]);
        });

        it(@"should tell manager when firing", ^{
            id mockManager = OCMClassMock([UPPEventSubscriptionManager class]);
            OCMExpect([mockManager subscriptionExpired:sut completion:[OCMArg any]]);
            sut.manager = mockManager;

            [timer fire];

            OCMVerifyAll(mockManager);
        });
    });

    describe(@"expiration timer", ^{

        __block NSTimer *timer;

        beforeEach(^{
            timer = [sut expirationTimer];
            expect(timer).toNot.beNil();
        });

        it(@"should fire at expiration date", ^{
            expect([timer fireDate]).to.beWithinAMillisecondOf(expiryDate);
        });

        it(@"should tell manager when firing", ^{
            id mockManager = OCMClassMock([UPPEventSubscriptionManager class]);
            OCMExpect([mockManager subscriptionExpired:sut completion:[OCMArg any]]);
            sut.manager = mockManager;

            [timer fire];

            OCMVerifyAll(mockManager);
        });
    });

    describe(@"updating after renewal", ^{

        __block NSDate *newDate;

        beforeEach(^{
            newDate = [NSDate dateWithTimeIntervalSinceNow:1800];
        });

        it(@"should update renew timer", ^{
            NSDate *oldDate = [[sut renewTimer] fireDate];

            [sut updateSubscriptionID:subscriptionID expiryDate:newDate];

            NSDate *renewDate = [[sut renewTimer] fireDate];
            expect(renewDate).toNot.equal(oldDate);
            expect(renewDate).to.beWithinAMillisecondOf([newDate dateByAddingTimeInterval:-30]);
        });

        it(@"should update expiration timer", ^{
            NSDate *oldDate = [[sut expirationTimer] fireDate];

            [sut updateSubscriptionID:subscriptionID expiryDate:newDate];

            NSDate *expirationDate = [[sut expirationTimer] fireDate];
            expect(expirationDate).toNot.equal(oldDate);
            expect(expirationDate).to.beWithinAMillisecondOf(newDate);

        });

        it(@"should update subscription ID", ^{
            NSString *oldID = sut.subscriptionID;
            NSString *newID = @"uuid:654321";

            [sut updateSubscriptionID:newID expiryDate:newDate];

            expect(newID).toNot.equal(oldID);
            expect(newID).to.equal(sut.subscriptionID);
        });
    });

    it(@"should inform observers of an event", ^{
        id mockObserver = OCMProtocolMock(@protocol(UPPEventSubscriptionDelegate));
        [sut addEventObserver:mockObserver];
        expect([sut eventObservers]).to.contain(mockObserver);

        NSDictionary *event = @{ @"transportState": @"stopped" };
        OCMExpect([mockObserver eventRecieved:event]);

        [sut informObserversOfEvent:event];

        OCMVerifyAllWithDelay(mockObserver, 5.0);
    });

    it(@"should invalidate all timers", ^{
        expect([sut.expirationTimer isValid]).to.beTruthy();
        expect([sut.renewTimer isValid]).to.beTruthy();

        [sut invalidateTimers];

        expect(sut.expirationTimer).to.beNil();
        expect(sut.renewTimer).to.beNil();
    });
});

SpecEnd
