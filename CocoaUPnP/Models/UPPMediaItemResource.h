
#import <Foundation/Foundation.h>

@interface UPPMediaItemResource : NSObject

/**
 *  The number of audio channels
 */
@property (copy, nonatomic) NSString *numberOfAudioChannels;

/**
 *  The bitrate of the resource
 */
@property (copy, nonatomic) NSString *bitrate;

/**
 *  The duration of the item in HH:MM:SS
 */
@property (copy, nonatomic) NSString *duration;

/**
 *  The sample frequency of the media item
 */
@property (copy, nonatomic) NSString *sampleFrequency;

/**
 *  The protocol info string of the media item
 */
@property (copy, nonatomic) NSString *protocolInfo;

/**
 *  The size in bytes of the media item
 */
@property (copy, nonatomic) NSString *itemSize;

/**
 *  A string representation of the media item URL
 */
@property (copy, nonatomic) NSString *resourceURLString;

@end
