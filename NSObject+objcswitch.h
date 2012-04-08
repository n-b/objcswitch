//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  This is an experimental switch/case construct for objective-C objects.
 *  Use it like that :
 *
 *  [[@"foo" switch]
 *   case:@"bar" :^{ success = NO; }
 *   case:@"baz" :^{ success = NO; }
 *   case:@"foo" :^{ success = YES; }
 *  ];
 */

@interface ObjcSwitch : NSObject

/*
 * The case::case:: methods are declared here, through recursive #includes
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
 */

/*
 * The exact count depends on how you #import this header :
 * the recursive #includes use __INCLUDE_LEVEL__, whose value is zero for
 * the current compilation unit. (the .m file).
 */
#define OBJCSWITCH_MAX_CASE_COUNT 	32

/*
 * declare "case::case::default:" methods
 */
#define OBJCSWITCH_DEFAULT_BLOCK TRUE
#include "objcswitch_switch.def.h"

/*
 * declare "case::case::" method
 */
#undef OBJCSWITCH_DEFAULT_BLOCK
#define OBJCSWITCH_DEFAULT_BLOCK FALSE
#include "objcswitch_switch.def.h"

@end

/*
 * Return the switch object, which implements the actual case::case:: methods
 */
@interface NSObject (objcswitch)
- (ObjcSwitch *) switch;
@end
