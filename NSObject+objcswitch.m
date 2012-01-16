//
//  NSObject+objcswitch.m
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSObject+objcswitch.h"
#import <objc/runtime.h>

static void objcswitch(ObjcSwitch * self, SEL _cmd, id arg,...);

/****************************************************************************/
#pragma mark -

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation ObjcSwitch
{
    @package
    id receiver;
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    NSString * selectorName = NSStringFromSelector(aSEL);
    NSString * nameTemplate = @"case::";

    if(selectorName.length % nameTemplate.length == 0)
    {
        NSUInteger numberOfCases = selectorName.length / nameTemplate.length;
        NSMutableString * expectedSelectorName = [NSMutableString string];
        for(int i=0;i<numberOfCases;i++)
            [expectedSelectorName appendString:nameTemplate];
        if([selectorName isEqualToString:expectedSelectorName])
        {
            NSMutableString * types = [@"v@:" mutableCopy];
            for(int i=0;i<numberOfCases;i++)
                [types appendString:@"@@"];
            class_addMethod([self class], aSEL, (IMP) objcswitch, [types cStringUsingEncoding:NSASCIIStringEncoding]);
            return YES;
        }
            
    }
    return NO;
}
@end

#pragma clang diagnostic pop

/****************************************************************************/
#pragma mark -

static void objcswitch(ObjcSwitch * self, SEL _cmd, id arg,...)
{
    id value;
    void (^block)(void);
	va_list args;
    
	va_start(args, arg);
    value = arg; // first value
    block = va_arg(args, id); // first block
    
	while (value && block) {
        if ([self->receiver isEqual:value])
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

/****************************************************************************/
#pragma mark -

@implementation NSObject (objcswitch)
- (ObjcSwitch *) switch
{
    ObjcSwitch * sw_ = [ObjcSwitch new];
    sw_->receiver = self;
    return sw_;
}
@end

