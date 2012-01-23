//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjcSwitch;

@interface NSObject (objcswitch)
- (ObjcSwitch *) switch;
@end


@interface ObjcSwitch : NSObject
#define OBJCSWITCH_BASE_INCLUDE_LEVEL __INCLUDE_LEVEL__
#define OBJCSWITCH_MAX_CASE_COUNT 10

#define OBJCSWITCH_FIRST_LINE		- (void) case:(id)v :(void (^)(void))b
#define OBJCSWITCH_CASE_LINE		         case:(id)v :(void (^)(void))b

#define OBJCSWITCH_LAST_LINE		      default:(void (^)(void))b;
	#include "objcswitch_switch.def.h"
#undef OBJCSWITCH_LAST_LINE
#define OBJCSWITCH_LAST_LINE		      ;
	#include "objcswitch_switch.def.h"

@end
