//
//  NSObject+objcswitch.m
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSObject+objcswitch.h"

@implementation $Case
{
@package
    id value;
    void (^block)(void) ;
}
+ (id) :(id)value_ :(void (^)(void))block_
{
    $Case * c = [self new];
    c->value = value_;
    c->block = block_;
    return c;
}

@end

@implementation NSObject (objcswitch)

- (void) switch:($Case*)case_, ... 
{
	va_list cases;
	va_start(cases, case_);
	while (case_) {
        if ([self isEqual:case_->value])
        {
            case_->block();
            goto cleanup;
        }

		case_ = va_arg(cases, id);
	}
    
cleanup:
	va_end(cases); 
    return;
}
@end
