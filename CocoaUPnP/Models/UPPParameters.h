// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This model is representative of UPnP call parameters. It is essentially a
 minimal ordered dictionary, and is used purely to ensure the UPnP call
 parameters are sent in the order outlined in the UPnP service documentation.

 Note: this is all because Windows Sharing follows the spec explicitly. Most
 other services, quite rightly, don't care what order the parameters occur.
 */
@interface UPPParameters : NSObject

/**
 Instantiate a new model using keys and values.

 @param keys   An array of parameter keys.
 @param values An array of parameter values.

 @return A newly instantiated parameter model with stored keys and values.
 */
+ (instancetype)paramsWithKeys:(NSArray *)keys values:(NSArray *)values;

/**
 Instantiate a new model containing a single item

 @param key   The key
 @param value The value

 @return A newly instantiated parameter model with stored keys and values.
 */
+ (instancetype)paramsWithKey:(NSString *)key value:(id)value;

/**
 Enumerate through the parameters key and value pairs, ordered by the original
 keys array order.

 @param block A block which is called during each enumeration.
 */
- (void)enumerateKeysAndValuesUsingBlock:(void (^)(id key, id value, NSUInteger idx, BOOL *stop))block;

@end
