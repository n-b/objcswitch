//
//  NSObject+objcswitch.m
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import "NSObject+objcswitch.h"
#import <objc/runtime.h>

// Implementation function declaration
static void objcswitch(ObjcSwitch * self, SEL _cmd, ...);

// Selector name templates
#define CASE__ "case::"
#define DEFAULT_ "default:"

// Of course, ObjcSwitch does not define implementation for all
// the selectors declared in the .h.
// Shut up that warning.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation ObjcSwitch
{
    // The ObjcSwitch object acts as a trampoline for the object it was created with.
    // Make the receiver ivar public so that everyone in the implementation can use it.
    @public
    id receiver;
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    const char* selector = sel_getName(aSEL);

    // Check selector has a valid length,
    // count the probable number of args and
    // find whether there's a default block.
    BOOL hasDefaultBlock = (strlen(selector) % strlen(CASE__)) != 0;
    if(hasDefaultBlock &&
       strlen(selector)%strlen(CASE__) != strlen(DEFAULT_)-strlen(CASE__) )
        return NO;
    size_t caseCount = (strlen(selector)-(hasDefaultBlock?strlen(DEFAULT_):0)) / strlen(CASE__);
    
    // Check selector looks like "case::case::"...
    for(size_t i=0;i<caseCount;i++)
        if(memcmp(selector + i*strlen(CASE__), CASE__, strlen(CASE__)))
            return NO;

    // Check it ends with "default:"
    if(hasDefaultBlock &&
       memcmp(selector + caseCount*strlen(CASE__), DEFAULT_, strlen(DEFAULT_)))
            return NO;
    
    // Selector string is what we expect. Construct types encoding string.
    //
    // types looks like : v@:@@?@@?@@?@
    // where :
    //  - v is for the (void) return
    //  - @: are for the self and _cmd hidden params
    //  - @@: is for each case
    //   - @ for the object
    //   - @? for the block
    //  - @? is for the last ("default") block
    NSMutableString * types = [NSMutableString stringWithFormat:@"%s%s%s",
                               @encode(void),@encode(id),@encode(SEL)];

    for(size_t i=0;i<caseCount;i++)
        [types appendFormat:@"%s%s",@encode(id),@encode(void(^)(void))];

    if(hasDefaultBlock)
        [types appendFormat:@"%s",@encode(void(^)(void))];

    class_addMethod(self, aSEL, (IMP) objcswitch, [types cStringUsingEncoding:NSASCIIStringEncoding]);
    return YES;
}

@end

#pragma clang diagnostic pop

// Actual implementation for all the methods
// 
// Although there's no variadic in the public interface, we use one for the implementation.
// We use the length of the selector to count the number of cases
// and find if there's a "default" block.
static void objcswitch(ObjcSwitch * self, SEL _cmd, ...)
{
	va_list args;
	va_start(args, _cmd);

    // Find out number of arguments in our va_list
    const char* selector = sel_getName(_cmd);
    BOOL hasDefaultBlock = (strlen(selector) % strlen(CASE__)) != 0;
    size_t caseCount = (strlen(selector)-(hasDefaultBlock?strlen(DEFAULT_):0)) / strlen(CASE__);
    assert( (strlen(selector)-(hasDefaultBlock?strlen(DEFAULT_):0)) / caseCount == strlen(CASE__) );

    // loop for each "case"
    // (object,block) pair of arguments
    for (size_t i=0; i<caseCount; i++)
    {
        id value = va_arg(args, id);
        void (^block)(void) = va_arg(args, void (^)(void));

        if ([self->receiver isEqual:value])
        {
            block();
            goto cleanup;
       }
	}

    // "default:" block
    if(hasDefaultBlock)
    {
        void (^block)(void) = va_arg(args, void (^)(void));
        block();
    }
    
cleanup:
	va_end(args); 
}

// Our NSObject category to create the ObjcSwitch, simply used as a trampoline object.
// 
// We could also define the case:: methods on NSObject itself, but that would require
// implementing - (BOOL) resolveInstanceMethod: in an NSObject category, which
// would be quite dangerous.
@implementation NSObject (objcswitch)
- (ObjcSwitch *) switch
{
    ObjcSwitch * sw_ = [ObjcSwitch new];
    sw_->receiver = self;
    return sw_;
}
@end
