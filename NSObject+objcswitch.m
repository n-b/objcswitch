//
//  NSObject+objcswitch.m
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSObject+objcswitch.h"

@implementation NSObject (objcswitch)

- (void) switch:(id)arg, ... 
{
    id value;
    void (^block)(void);
	va_list args;
    
	va_start(args, arg);
    value = arg; // first value
    block = va_arg(args, id); // first block
    
	while (value && block) {
        if ([self isEqual:value])
        {
            block();
            goto cleanup;
        }

        value = va_arg(args, void (^)(void)); // next value
        if(value)
            block = va_arg(args, id); // next block
	}
    
cleanup:
	va_end(args); 
    return;
}
@end
