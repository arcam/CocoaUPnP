# CocoaUPnP

[![Build Status](https://travis-ci.org/arcam/CocoaUPnP.svg)](https://travis-ci.org/arcam/CocoaUPnP)

CocoaUPnP is a logical progression of [upnpx](https://github.com/fkuehne/upnpx) - designed to be easy, modern and block-based. It is written in Objective-C and is available for both iOS and Mac OS X.

## Warning: here be dragons...

CocoaUPnP is currently in the very early stages of development. At this stage it is not recommended for use in projects. Want to speed up development? Why not tackle one of the project's [issues](https://github.com/arcam/CocoaUPnP/issues).

## Project timeline

Initially, this project will focus on the Audio/Video [Device Control Protocols](http://upnp.org/sdcps-and-certification/standards/sdcps/). Once these protocols have been properly implemented and tested, then the rest of the protocols will be added.

## Testing

CocoaUPnP will be test-driven as much as possible to ensure the library works as intended. When submitting a Pull Request, you should run the suite of unit tests to ensure your patch does not break existing functionality. Please ensure you add a test for the new feature you have added. You can look at the existing tests to get an idea of how to do this.

### Writing tests

When creating a new class, create a test class at the same time. Tests are written with [Specta](https://github.com/specta/specta), with accompanying [Expecta](https://github.com/specta/expecta) matchers.

Both the [Specta](https://github.com/specta/specta) and [Expecta](https://github.com/specta/expecta) imports are declared in the [ExampleTests-Prefix.pch](https://github.com/arcam/CocoaUPnP/blob/master/Example/ExampleTests-Prefix.pch) file, so no need to import them in each spec. 

## Contributing

Pull requests are always welcome. If you feel like getting stuck into the project, there are a multitude of ways you can help out.

- Update documentation
- Design a neat icon for the library
- Tackle one of the project's [issues](https://github.com/arcam/CocoaUPnP/issues)
- Submit a new [issue or feature request](https://github.com/arcam/CocoaUPnP/issues/new)

### Submitting a Pull Request

New features should always be added in a seperate topic branch on your fork.

Fork, then clone the repo:

    git clone git@github.com:your-username/CocoaUPnP.git

Change your directory to your `CocoaUPnP` folder

    cd CocoaUPnP

Run the tests to make sure nothing is broken

    make tests

Create and checkout a feature branch

    git checkout -b awesomeNewFeature

Make your changes, then re-run the tests

    make tests

Commit and push to your fork then [submit a Pull Request](https://github.com/arcam/CocoaUPnP/compare/).

