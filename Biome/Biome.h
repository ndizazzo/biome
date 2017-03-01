//
//  Biome1.h
//  Biome1
//
//  Created by Nick DiZazzo on 2017-03-06.
//  Copyright © 2017 Nick DiZazzo. All rights reserved.
//

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE || TARGET_OS_TV || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for Biome1.
FOUNDATION_EXPORT double Biome1VersionNumber;

//! Project version string for Biome1.
FOUNDATION_EXPORT const unsigned char Biome1VersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Biome1/PublicHeader.h>


