// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPParameters.h"

@interface UPPParameters ()
@property (copy, nonatomic) NSArray *keys;
@property (copy, nonatomic) NSArray *values;
@end

@implementation UPPParameters

+ (instancetype)paramsWithKeys:(NSArray *)keys values:(NSArray *)values
{
    return [[[self class] alloc] initWithKeys:keys values:values];
}

- (instancetype)initWithKeys:(NSArray *)keys values:(NSArray *)values
{
    if ((self = [super init])) {
        if (keys.count != values.count) {
            NSString *name = @"Count mismatch";
            NSString *format = @"Key / value array counts do not match";
            [NSException raise:name format:@"%@", format];
        }

        self.keys = keys;
        self.values = values;
    }
    return self;
}

+ (instancetype)paramsWithKey:(NSString *)key value:(id)value
{
    return [self paramsWithKeys:@[key] values:@[value]];
}

- (void)enumerateKeysAndValuesUsingBlock:(void (^)(id key, id value, NSUInteger idx, BOOL *stop))block
{
    [self.keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        block(key, self.values[idx], idx, stop);
    }];
}

- (BOOL)isEqual:(UPPParameters *)object
{
    if (!object || ![object isKindOfClass:[UPPParameters class]]) {
        return NO;
    }

    if (![self.keys isEqualToArray:object.keys]) {
        return NO;
    }

    if (![self.values isEqualToArray:object.values]) {
        return NO;
    }

    return YES;
}

@end
