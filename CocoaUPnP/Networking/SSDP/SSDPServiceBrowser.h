//
//  Copyright (c) 2014 Stephane Boisson
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Expanded for CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
//  Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

@class SSDPServiceBrowser;
@class SSDPService;

#pragma mark - SSDPServiceBrowserDelegate

///-----------------------------------------------------------------------------
/// @name SSDPServiceBrowserDelegate
///-----------------------------------------------------------------------------

/**
 The `SSDPServiceBrowserDelegate` protocol is adopted by an object that wishes
 to be informed of devices that are found or removed during a browsers search
 cycle.
 */
@protocol SSDPServiceBrowserDelegate

/**
 Report the browser failed to start browsing for services.

 @param browser The current browser instance.
 @param error   An `NSError` detailing the error which occured.
 */
- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didNotStartBrowsingForServices:(NSError *)error;

/**
 Report a found `SSDPService`.

 @param browser The current browser instance.
 @param service The service which was found.
 */
- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didFindService:(SSDPService *)service;

/**
 Report a removed `SSDPService`.

 @param browser The current browser instance.
 @param service The service which was found.
 */
- (void)ssdpBrowser:(SSDPServiceBrowser *)browser didRemoveService:(SSDPService *)service;

@end


#pragma mark - Constants

///-----------------------------------------------------------------------------
/// @name Constants
///-----------------------------------------------------------------------------

/**
 The SSDP multicast group address
 */
extern NSString *const SSDPMulticastGroupAddress;

/**
 The SSDP multicast port
 */
extern const UInt16 SSDPMulticastUDPPort;


#pragma mark - SSDPServiceBrowser

///-----------------------------------------------------------------------------
/// @name SSDPServiceBrowser
///-----------------------------------------------------------------------------

/**
 This class allows searching of UPnP devices over SSDP
 */
@interface SSDPServiceBrowser : NSObject <GCDAsyncUdpSocketDelegate>

/**
 A `GCDAsyncUdpSocket` instance which is connected to the multicast address
 */
@property (strong, nonatomic) GCDAsyncUdpSocket *multicastSocket;

/**
 A `GCDAsyncUdpSocket` instance which is connected to the multicast address, and
 tied to a specific port
 */
@property (strong, nonatomic) GCDAsyncUdpSocket *unicastSocket;

/**
 The current network interface
 */
@property(readonly, nonatomic) NSString *networkInterface;

/**
 A delegate to inform of browse events.
 */
@property(assign, nonatomic) id<SSDPServiceBrowserDelegate> delegate;

/**
 Start browsing for UPnP services matching the browsers service type.

 @param serviceType The UPnP service type to search for.
 */
- (void)startBrowsingForServiceTypes:(NSString *)serviceType;

/**
 Stop browsing for UPnP services.
 */
- (void)stopBrowsingForServices;

@end
