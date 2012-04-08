// This is a special include file that helps declaring
// method names for NSObject+objcswitch.
//
// There's a number of hacks here :
//
// It's a recursive include file (uses "__INCLUDE_LEVEL__" as a stop condition.)
// A new method is declared everytime this file is included.
//
// This method prototype is written on several lines :
// * the first and last lines of the method prototype are declared here,
// * the middle lines are declared in "objcswitch_case.def.h".
//
// It's also a "parameterized include" :
// the "default:" line will be added depending
// of the value of the "OBJCSWITCH_DEFAULT_BLOCK" macro.
//

#if __INCLUDE_LEVEL__ < OBJCSWITCH_MAX_CASE_COUNT

- (void) case:(id)v :(void (^)(void))b	// first method declaration line
#include "objcswitch_case.def.h"			// all lines : "case:(id)v :(void (^)(void))b"
#if OBJCSWITCH_DEFAULT_BLOCK				// last line :
default:(void (^)(void))b;					//	  "default:(void (^)(void))b;"
#else										//	 or just
;											//	  ";"
#endif

#include "objcswitch_switch.def.h"			// include myself to define next method (shorter by one line)

#endif
