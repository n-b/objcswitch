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
#define SEL_NAME_TEMPLATE "case::"
#define SEL_NAME_TEMPLATE_LENGTH strlen(SEL_NAME_TEMPLATE)

#define TYPES_PREFIX "v@:"
#define TYPES_PREFIX_LENGTH strlen(TYPES_PREFIX)
#define TYPES_TEMPLATE "@@?"
#define TYPES_TEMPLATE_LENGTH strlen(TYPES_TEMPLATE)

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
    const char* selector_name = sel_getName(aSEL);

    // Check selector is of the form name::name::(etc) 
    if(strlen(selector_name) % SEL_NAME_TEMPLATE_LENGTH != 0)
        return NO;

    size_t case_count = strlen(selector_name)/SEL_NAME_TEMPLATE_LENGTH;
    for(size_t i=0;i<case_count;i++)
    {
        if(memcmp(&selector_name[i*SEL_NAME_TEMPLATE_LENGTH], SEL_NAME_TEMPLATE, SEL_NAME_TEMPLATE_LENGTH))
            return NO;
    }

    // Valid selector. Construct types encoding string.
    char types[TYPES_PREFIX_LENGTH+case_count*TYPES_TEMPLATE_LENGTH+1];
    memcpy(types,TYPES_PREFIX,TYPES_PREFIX_LENGTH);
    for(size_t i=0;i<case_count;i++)
        memcpy(&types[TYPES_PREFIX_LENGTH+i*TYPES_TEMPLATE_LENGTH],TYPES_TEMPLATE,TYPES_TEMPLATE_LENGTH);
    types[TYPES_PREFIX_LENGTH+case_count*TYPES_TEMPLATE_LENGTH] = 0;
    

    class_addMethod([self class], aSEL, (IMP) objcswitch, types);
    return YES;
}
@end

#pragma clang diagnostic pop

/****************************************************************************/
#pragma mark -

static void objcswitch(ObjcSwitch * self, SEL _cmd, id arg,...)
{
    const char* selector_name = sel_getName(_cmd);
    size_t case_count = strlen(selector_name)/strlen(SEL_NAME_TEMPLATE);
    
    id value;
    void (^block)(void);
	va_list args;
    
	va_start(args, arg);
    value = arg; // first value
    block = va_arg(args, void (^)(void)); // first block
    
    for (size_t i=0; i<case_count; i++)
    {
        if ([self->receiver isEqual:value])
        {
            block();
            goto cleanup;
        }
        
        value = va_arg(args, id); // next value
        block = va_arg(args, void (^)(void)); // next block
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

