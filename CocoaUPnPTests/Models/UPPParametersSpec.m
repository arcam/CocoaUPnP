// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPParameters.h"

@interface UPPParameters ()
@property (copy, nonatomic) NSArray *keys;
@property (copy, nonatomic) NSArray *values;
@end

SpecBegin(UPPParameters)

describe(@"UPPParameters", ^{

    __block NSArray *keys;
    __block NSArray *values;

    beforeEach(^{
        keys = @[ @"a", @"b", @"c" ];
        values = @[ @1, @2, @3 ];
    });

    it(@"should return an instance when provided with keys and values", ^{
        expect([UPPParameters paramsWithKeys:keys values:values]).toNot.beNil();
    });

    it(@"should raise an exception when key and value counts don't match", ^{
        NSArray *wrongValues = @[ @1, @2 ];
        expect(^{
            [UPPParameters paramsWithKeys:keys values:wrongValues];
        }).to.raiseAny();
    });

    it(@"should allow adding single entry", ^{
        UPPParameters *p = [UPPParameters paramsWithKey:@"Hello" value:@"World"];
        expect(p).toNot.beNil();
        expect(p.keys).to.equal(@[@"Hello"]);
        expect(p.values).to.equal(@[@"World"]);
    });

    it(@"should enumerate based on the order of the keys", ^{
        UPPParameters *sut = [UPPParameters paramsWithKeys:keys values:values];
        [sut enumerateKeysAndValuesUsingBlock:^(id key, id value, NSUInteger idx, BOOL *stop) {
            expect(keys[idx]).to.beIdenticalTo(key);
            expect(values[idx]).to.beIdenticalTo(value);
        }];
    });

    describe(@"equality", ^{
        __block UPPParameters *sut;

        beforeEach(^{
            sut = [UPPParameters paramsWithKeys:keys values:values];
        });

        it(@"should not return equal with different keys", ^{
            UPPParameters *p = [UPPParameters paramsWithKeys:@[ @"c", @"b", @"a" ]
                                                      values:values];
            expect([sut isEqual:p]).to.beFalsy();
        });

        it(@"should not return equal with different values", ^{
            UPPParameters *p = [UPPParameters paramsWithKeys:keys
                                                      values:@[ @3, @2, @1 ]];

            expect([sut isEqual:p]).to.beFalsy();
        });

        it(@"should return equal with different instances", ^{
            UPPParameters *p = [UPPParameters paramsWithKeys:keys
                                                      values:values];
            expect([sut isEqual:p]).to.beTruthy();
        });
    });
});

SpecEnd
