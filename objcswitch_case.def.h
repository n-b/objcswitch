// This is a special include file that helps declaring
// method names for NSObject+objcswitch.
//
//
// It's a recursive include file (uses "__INCLUDE_LEVEL__" as a stop condition.)
// The number of lines will depend of the starting depth
// where this file is first included.


#if __INCLUDE_LEVEL__ < OBJCSWITCH_MAX_CASE_COUNT

case:(id)v :(void (^)(void))b			// single case line
#include "objcswitch_case.def.h"		// include myself for next line

#endif
