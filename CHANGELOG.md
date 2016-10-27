# Changelog

## 1.1.0

- Add forgetAllKnownDevices method to UPPDiscovery
- Exit early if `setVolume:` called with `nil` volume
- Add additional safe guards against object IDs returning numbers

## 1.0.0

- Add tests for socket enableReusePort
- Fix spec warnings after updating CocoaAsyncSocket
- Update CocoaAsyncSocket dependency
- Ensure XML is escapes illegal characters
- Make albumArtist more important that artist.
- Adjust nullability of certain network calls
- Don't cache http requests
- Enable reuse port for SSDP discovery (@Jerrywyx)
- Adds missing nullability specifier to SSDPService
- Remove unused arguements from podfile
- Cleans up nullability warnings in specs.
- Adds missing nullability markers
- Adds Swift compatability to service classes
- Adds Swift compatability with parser classes
- Adds Swift compatability for SSDP classes
- Adds swift compatability to UPPDiscovery
- Adds Swift compatability with Models
- Adds Swift compatability to events
- Adds Swift compatability with UPPEventServer
- Adds better Swift compatability for UPPMediaItem
- Add nullable identifiers to av transport service
- Exit early from parsing if no device returned
- Allow pod warnings

### Breaking changes

- Remove deprecated UPPDiscovery delegate

## 0.2.2

- Don't attempt to parse services with no XML document

## 0.2.1

- Ignore example directory with slather
- Update travis and slather files
- Update travis file to use scan
- Use scan for tests
- Remove unused private method
- Remove subscriptions when removing device during discovery
- Return immutable copy of request URL
- Exit early from subscription if request is nil
- Only attempt to unsubscribe a non-nil subscription
- Invalidate timers when unsubscribing
- Facilitate removal of subscriptions
- Update test for callback URL
- Exit early when updating timers with nil expiry
- Store callback URL
- Add remove subscriptions for services method
- Add unique service name to subscription
- Add unique service name to BasicServices

## 0.2.0

- Ignore fastlane test output
- Skip fastlane doc generation
- Replace UPPDiscovery delegate methods with `-[addBrowserObserver:]` and `-[removeBrowserObserver:]`
- Update example project pods
- Change renew subscription behaviour

## 0.1.3

- Fix up tests
- Add more cautious logic to AV Transport Service
- Code cleanup
- Fix crash when unsubscribing with no completion

## 0.1.2

- Fix a potential crash in xml node helper category
- Prevent a possible crash with unsubscribing
- Implement NSCopying for Media Items
- Update Example Pods

## 0.1.1

- Prevent main app from launching during testing
- Fix an issue with subscriptions silently breaking after backgrounding

## 0.1.0

- Initial release
