<img src="./Images/biome.png" width="300">

## Current Status
[![Version](https://img.shields.io/cocoapods/v/Biome.svg?style=flat)](http://cocoapods.org/pods/Biome)
[![Downloads](https://img.shields.io/github/downloads/biome/biome/total.svg)](http://cocoapods.org/pods/Biome)
![Supported Platforms](https://img.shields.io/cocoapods/p/Biome.svg)
[![CI Status](http://img.shields.io/travis/ndizazzo/Biome.svg?style=flat)](https://travis-ci.org/ndizazzo/Biome)
[![License](https://img.shields.io/cocoapods/l/Biome.svg?style=flat)](http://cocoapods.org/pods/Biome)
[![Platform](https://img.shields.io/cocoapods/p/Biome.svg?style=flat)](http://cocoapods.org/pods/Biome)

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

### Biome

The smallest conceptual unit - this object holds simple key / value pairs that define an environment.

### BiomeProvider

A protocol that allows mappings from various types of data sets into Biome objects. Conformance to this protocol implies that Biomes will be able to be created from a given provider.

### BiomeManager

A centralized place to manage many Biomes.

## Support
* Xcode 8.0 / Swift 3.0
* iOS >= 8.0 (Use as an **Embedded** Framework)
* tvOS >= 9.0
* macOS >= 10.10 (untested, but should still work in theory)

## Having trouble running the demo?

* `BiomeDemo/BiomeDemo.xcodeproj` is the demo project for iOS
* Make sure you are running a supported version of Xcode.
* Make sure that your project supports Swift 3.0

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
github "ndizazzo/Biome" == 1.0.0
github "ndizazzo/Biome" ~> 1.0.0
```

In order to build the binaries for a new release, use `carthage build --no-skip-current && carthage archive Biome`.

# Usage

## Implementing Biome in your Project
To implement Biome, first `import Biome` into the relevant files where you want to use it. 

Then, create a Biome by calling the `Biome()` constructor, or using the `PlistBiomeProvider(bundle: Bundle, filename: String)`. You can also write a `BiomeProvider` that will return a Biome object out of the provided data. Consider forking and 🔨 contributing back 🔨 to this project. Don't forget to update this README!

Once you have a `Biome` object, use `BiomeManager.register()` to register it. This does a couple things:
1. Adds it to the set of available Biomes. One uniquely named Biome is allowed per manager.
1. Sets it as the `current` object on `BiomeManager`. This is a property tells you which tells you what Biome is currently active.

Finally, extend one of your classes:

```swift
extension MyClass: BiomeManagerDelegate {
  func switched(to: Biome) {
    print("The active biome has been switched to '\(to.name)'")
  }
}
```

Use that delegate method to do anything, like clear a CoreData database and reload data into it from a different environment, re-query an API for new data, refresh a view controller's appearance, etc.

In order to take full advantage of Biome, you'll want to follow the pattern:
```swift
  
  if let biome = BiomeManager.shared.current, let apiEndpoint = biome.get("api_url") as? String {
    myAPIClient.get(apiEndpoint) { response in 
      // ...
    }
  }
```
to gate your application's properties behind Biome so that when you switch environments, the most up-to-date values are always used.

*NOTE* You are _not_ required to use the shared `BiomeManager`. You can create numerious instances of the class and store them where you wish.

## Class Descriptions
Implementation of Biome is straightforward. Biome provides several classes and protocols for you to use or customize:
* `class BiomeManager` - A singleton manager object that maintains a list of active 'Biomes' created in your application.

* `class Biome` - A simple wrapper object that dictates how to access values for keys. You are responsible for knowing the type of data going in, and coming out of a Biome.

* `protocol BiomeProvider` - A protocol that defines how 'providers' should map keys and values to a Biome. Examples might include: plist files, JSON, XML, user defaults.

* `class PlistBiomeProvider` - A biome provider that knows how to obtain values from a Plist file.

# Feature Roadmap

#### Biome Groups
* You may want to have multiple Biomes active at a given time, or mix and match combinations of variables. Groups would allow the developer to do something like:
  * Have a set of variables for API endpoints
  * Have a set of style colours to use for UI elements
  * Have a set of logging levels

  All without having to make `n!` distinct Biomes to switch between to achieve all possible permutations of variable configurations.

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

 - Make sure you are using the latest version of the library. Check the [**release-section**](https://github.com/danielgindi/Biome/releases).
 - Search or open questions on [**stackoverflow**](http://stackoverflow.com/questions/tagged/ios-biome) with the `ios-biome` tag
 - Search [**known issues**](https://github.com/danielgindi/Biome/issues) for your problem (open and closed)
 - Create new issues (please **search known issues beforehand** and avoid creating duplicate issues)

## Documentation
Documentation exists in the form of Xcode quick-help. Please refer to [**Apple's Documentation**](https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html) for writing quick help documentation.

Or you can study the [**BiomeDemo**](https://github.com/ndizazzo/biome/tree/master/BiomeDemo) project to learn by example.

## License

Biome is available under the MIT license. See the LICENSE file for more information.
