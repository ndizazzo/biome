<img src="./Images/biome.png" width="300">

## Current Status
[![Version](https://img.shields.io/cocoapods/v/Biome.svg?style=flat)](http://cocoapods.org/pods/Biome)
[![Downloads](https://img.shields.io/github/downloads/biome/biome/total.svg)](http://cocoapods.org/pods/Biome)
![Supported Platforms](https://img.shields.io/cocoapods/p/Biome.svg)
[![License](https://img.shields.io/cocoapods/l/Biome.svg?style=flat)](http://cocoapods.org/pods/Biome)
[![Platform](https://img.shields.io/cocoapods/p/Biome.svg?style=flat)](http://cocoapods.org/pods/Biome)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58befdc41bb76b0100b9579f&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58befdc41bb76b0100b9579f/build/latest?branch=master)

## What is Biome?

Biome is a simple way to manage sets of variables between environments you might need to work with when developing your application.

One problem developers face, is the need to create multiple builds in order to test how their application functions in different environments. Biome aims to reduce the amount of re-building that needs to occur, by providing a mechanism to switch configurations during run-time.

## Bio-me? Bi-om-ee?

Nope. Bi-ohm.

## What *is* a Biome?

By definition:

_noun_ `ECOLOGY`

> A biome /ˈbaɪoʊm/ is a formation of plants and animals that have common characteristics due to similar climates and can be found over a range of continents.

Applied for our purposes:

> A biome is a collection of variables and settings that have common characteristics due to similar environments and can be found across a range of applications. 

## Concept

A manager organizes similarly-typed Biomes into groups, where each group can have at most 1 "active" Biome. You can instruct the `BiomeManager` to switch to a different `Biome` within the same `BiomeGroup`, and the manager notifies the provided delegate.

### Biome

The smallest conceptual unit in the framework - this object defines a set of properties whose values will be swapped out at any time with a different set of values.

### BiomeGroup

A container that manages similarly-typed Biome objects. A Biome group provides functionality to store Biomes, as well as maintain one "currently active" Biome in that group. You do not need to create or manage groups yourself - the `BiomeManager` takes care of that automatically.

### BiomeManager

A common interface to register and track Biome objects.

## Support
* Xcode 8.0 / Swift 4.0
* iOS >= 8.0 (Use as an **Embedded** Framework)
* tvOS >= 9.0
* macOS >= 10.10

## Having trouble running the demo?

* `BiomeDemo/BiomeDemo.xcodeproj` is the demo project for iOS
* Make sure you are running a supported version of Xcode.
* Make sure that your project supports Swift 4.0

# Installation

## Manual Installation

In order to correctly compile the project:

1. Drag the `Biome.xcodeproj` to your project  
2. Go to your target's settings, hit the "+" under the "Embedded Binaries" section, and select the Biome.framework  
3. `@import Biome`  
4.  When using Swift in an ObjC project:
   - You need to import your Bridging Header. Usually it is "*YourProject-Swift.h*".
   - (Xcode 8.1 and earlier) Under "Build Options", mark "Embedded Content Contains Swift Code"
   - (Xcode 8.2+) Under "Build Options", mark "Always Embed Swift Standard Libraries"

## CocoaPods Install

Add the following to your Podfile: 

```
pod 'Biome'
```

and run `pod install`

## Carthage Install

Biome includes Carthage prebuilt binaries.

```carthage
github "ndizazzo/Biome" == 2.0.0
github "ndizazzo/Biome" ~> 2.0.0
```

In order to build the binaries for a new release, use `carthage build --no-skip-current && carthage archive Biome`.

# Usage

## Implementing Biome in your Project
To implement Biome, first `import Biome` into the relevant files where you want to use it. 

Then, create a Biome by defining a `struct` that conforms to the `Biome` protocol. Add as many fields as you like to your object, and implement the `keyCount` property to return the number of properties on the object.

Once you have `Biome` objects, use `BiomeManager.register(...)` to register them. This does a couple things:
1. Adds it to a managed group of similarly-typed Biomes. One uniquely identified Biome is allowed per group.
1. Sets it as the `current` Biome of the `BiomeGroup` managing it. This `current` property tells you which Biome is currently active.

Finally, extend one of your classes to receive events when the Biome is switched:

```swift
extension MyClass: BiomeManagerDelegate {
  func switched(to biome: Biome?) {
    print("The active biome has been switched to '\(to.name)'")
  }
}
```

Use that delegate method to do anything: clear a database and reload data into it from a different environment, re-query an API for new data, refresh a view controller's appearance, etc.

# Feature Roadmap

#### Display Biome Key names / values
* [SR-7897](https://bugs.swift.org/browse/SR-7897) suggests that synthesized `Codable` conformance should also optionally generate `CaseIterable` conformance. This would allow every `Biome` to have the `keyCount` automatically generated, and `allItems` reflect the actual properties of the Biome. 

If this improvement moves to the proposal phase, Biome.framework could add support for it, allowing developers to do more powerful things with the library; where they might be listed out for display in some type of UICollectionView / UITableView.

#### Run-time Property Modification
* Sometimes a developer might need to modify a property at run-time instead of providing it before compile-time. This feature would allow developers to do things like tweak animation timings, for instance.

# Troubleshooting

### Can't compile?

* Please note the difference between installing a compiled framework from CocoaPods or Carthage, and copying the source code.
* Please re-read the usage section.
* Search issues.
* Politely ask in the issues section.

### Other problems / Feature requests

* Search issues.
* Politely ask in the issues section.

# Other

## 3rd party software

Biome does not depend on any 3rd party libraries. It's designed to be lightweight and not add tons of overhead to your project.

## Contributing

If you have ideas or like what you see here and want to support the project, you could:
* Let people know this library exists (🚀 spread the word 🚀)
* Contribute code, issues and pull requests

## Questions & Issues

If you are having questions or problems, you should:

 - Make sure you are using the latest version of the library. Check the [**release-section**](https://github.com/ndizazzo/Biome/releases).
 - Search or open questions on [**stackoverflow**](http://stackoverflow.com/questions/tagged/ios-biome) with the `ios-biome` tag
 - Search [**known issues**](https://github.com/ndizazzo/Biome/issues) for your problem (open and closed)
 - Create new issues (please **search known issues beforehand** and avoid creating duplicate issues)

## Documentation
Documentation exists in the form of Xcode quick-help. Please refer to [**Apple's Documentation**](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html) for writing quick help documentation.

Or you can study the [**BiomeDemo**](https://github.com/ndizazzo/biome/tree/master/BiomeDemo) project to learn by example.

## License

Biome is available under the MIT license. See the LICENSE file for more information.
