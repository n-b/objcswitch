//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjcSwitch;

// Return the switch object, which implements the actual case::case:: methods
@interface NSObject (objcswitch)
- (ObjcSwitch *) switch;
@end

@interface ObjcSwitch : NSObject

// The method's implementation is actually defined at runtime.
// A bunch of method prototypes is actually define here.
#define OBJCSWITCH_MAX_DEPTH 	10 // Actually a bit less, depending on how you #import this file

#define OBJCSWITCH_FIRST_LINE	- (void) case:(id)v :(void (^)(void))b
#define OBJCSWITCH_CASE_LINE	         case:(id)v :(void (^)(void))b

#define OBJCSWITCH_LAST_LINE	      default:(void (^)(void))b;
	#include "objcswitch_switch.def.h"
#undef OBJCSWITCH_LAST_LINE
#define OBJCSWITCH_LAST_LINE	      ;
	#include "objcswitch_switch.def.h"

@end
