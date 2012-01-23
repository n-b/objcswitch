//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//
//  An experimental switch/case construct for objective-C objects.
//  Use it like that : 
//  
//  [[@"foo" switch]
//   case:@"bar" :^{ success = NO; }
//   case:@"baz" :^{ success = NO; }
//   case:@"foo" :^{ success = YES; }
//  ];
//

#import <Foundation/Foundation.h>

@class ObjcSwitch;

// Return the switch object, which implements the actual case::case:: methods
@interface NSObject (objcswitch)
- (ObjcSwitch *) switch;
@end

@interface ObjcSwitch : NSObject

/* The method's implementation is actually defined at runtime.
 * The bunch of methods is declared here, through recursive #includes
 *
 * The declared methods look like :

- (void) case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b
          ...
      default:(void (^)(void))b;
 
 * and :
 
- (void) case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b
          ...
 			;
 
 * with or without the default: case,
 * and with up to (a bit less than) OBJCSWITCH_MAX_CASE_COUNT cases.
 * The exact count depends on how you #import this header.
 */
#define OBJCSWITCH_MAX_CASE_COUNT 	32

#define OBJCSWITCH_FIRST_LINE	- (void) case:(id)v :(void (^)(void))b
#define OBJCSWITCH_CASE_LINE	         case:(id)v :(void (^)(void))b

#define OBJCSWITCH_LAST_LINE	      default:(void (^)(void))b;
	#include "objcswitch_switch.def.h"
#undef OBJCSWITCH_LAST_LINE
#define OBJCSWITCH_LAST_LINE	      ;
	#include "objcswitch_switch.def.h"

@end
