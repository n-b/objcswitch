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
#define CASE__ "case::"
#define DEFAULT_ "default:"

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
    size_t sel_name_length = strlen(selector_name);

    // Check selector is of the form name::name::(etc)(default:)
    size_t suffix_length = sel_name_length % strlen(CASE__);
    if(suffix_length!=0)
    {
        if(sel_name_length>=strlen(CASE__)+strlen(DEFAULT_))
            suffix_length += strlen(CASE__);
        if(suffix_length!=strlen(DEFAULT_))
            return NO;
    }
    
    size_t case_count = (sel_name_length-suffix_length)/strlen(CASE__);
    for(size_t i=0;i<case_count;i++)
        if(memcmp(&selector_name[i*strlen(CASE__)], CASE__, strlen(CASE__)))
            return NO;
    if(suffix_length)
        if(memcmp(&selector_name[case_count*strlen(CASE__)], DEFAULT_, strlen(DEFAULT_)))
            return NO;
    
    // Valid selector. Construct types encoding string.
    //
    // types looks like : v@:@@?@@?@@?@
    // where :
    //  - v is for the (void) return
    //  - @: are for the self and _cmd hidden params
    //  - @@: is for each case
    //   - @ for the object
    //   - @? for the block
    //  - @? is for the last ("default") block --> bug?
    char types[3+case_count*3+suffix_length?1:0+1];
    memcpy(types,"v@:",3);
    for(size_t i=0;i<case_count;i++)
        memcpy(&types[3+i*3],"@@?",3);
    if(suffix_length)
        types[3+case_count*3] = '@';
    types[3+case_count*3+suffix_length?1:0] = 0;
    
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
    size_t sel_name_length = strlen(selector_name);
    size_t suffix_length = sel_name_length % strlen(CASE__);
    if(suffix_length!=0)
    {
        if(sel_name_length>=strlen(CASE__)+strlen(DEFAULT_))
            suffix_length += strlen(CASE__);
    }
    size_t case_count = (sel_name_length-suffix_length)/strlen(CASE__);
    
    assert(suffix_length==0 || suffix_length==strlen(DEFAULT_));
    
    id value;
    void (^block)(void);
	va_list args;
    
	va_start(args, arg);
    value = arg; // first value <- remove line
    
    for (size_t i=0; i<case_count; i++)
    {
        if(i==0)
            value = arg;
        else
            value = va_arg(args, id);
        block = va_arg(args, void (^)(void));

        if ([self->receiver isEqual:value])
        {
            block();
            goto cleanup;
        }
	}

    if(suffix_length) // "default" case
    {
        block = va_arg(args, void (^)(void));
        block();
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
