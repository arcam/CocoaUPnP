// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

/**
 A delegate protocol for recieving parsed UPnP events.
 */
@protocol UPPEventServerDelegate <NSObject>
/**
 This method is called once the event server has received and parsed a new event.

 @param event A dictionary representation of an event. It contains two key/value
 pairs: one for the subscription ID, and one for the event body.
 */
- (void)eventReceived:(nonnull NSDictionary *)event;
@end

/**
 The event server port number.
 */
extern const NSUInteger UPPEventServerPort;

/**
 The dictionary key to be used with the events subscription ID value.
 */
extern NSString * _Nonnull const UPPEventServerSIDKey;

/**
 The dictionary key to be used with the events body value.
 */
extern NSString * _Nonnull const UPPEventServerBodyKey;

/**
 This class is responsible for running a lightweight web server for the purpose
 of recieving NOTIFY calls from subscribed services.
 */
@interface UPPEventServer : NSObject

/**
 An instance of GCDWebServer which handles incoming notifications.
 */
@property (strong, nonatomic, nonnull) GCDWebServer *webServer;

/**
 The delegate which should recieve parsed notifications.
 */
@property (weak, nonatomic, nullable) id <UPPEventServerDelegate> eventDelegate;

/**
 Start the event server.
 */
- (void)startServer;

/**
 Stop the event server.
 */
- (void)stopServer;

/**
 @return The event servers callback URL.
 */
- (nullable NSURL *)eventServerCallbackURL;

/**
 @return Return the running status of the web server.
 */
- (BOOL)isRunning;

@end
