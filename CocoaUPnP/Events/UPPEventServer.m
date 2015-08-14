// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventServer.h"
#import "GCDWebServerDataResponse.h"

const NSInteger UPPEventServerPort = 54123;

@implementation UPPEventServer

- (void)startServer
{
    [self.webServer addHandlerForMethod:@"NOTIFY" path:@"/Event" requestClass:[GCDWebServerDataResponse class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {

        return nil;
    }];
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
