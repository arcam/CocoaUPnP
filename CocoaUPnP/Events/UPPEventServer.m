// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventServer.h"
#import "GCDWebServerDataRequest.h"

const NSUInteger UPPEventServerPort = 54123;

@implementation UPPEventServer

- (void)startServer
{
    [self.webServer addHandlerForMethod:@"NOTIFY" path:@"/Event" requestClass:[GCDWebServerDataRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {

        return [[GCDWebServerResponse alloc] init];
    }];

    [self.webServer startWithPort:UPPEventServerPort bonjourName:nil];
}

- (NSURL *)eventServerCallbackURL
{
    if (!self.webServer.isRunning) {
        return nil;
    }
    NSURL *baseURL = self.webServer.serverURL;
    return [baseURL URLByAppendingPathComponent:@"Event"];
}

#pragma mark - Lazy Instantiation

- (GCDWebServer *)webServer
{
    if (!_webServer) {
        _webServer = [[GCDWebServer alloc] init];
    }
    return _webServer;
}

@end
