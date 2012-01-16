//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface $Case : NSObject
+ (id) :(id)value_ :(void (^)(void))block;
@end


@interface NSObject (objcswitch)
- (void) switch:($Case*)firstCase, ... NS_REQUIRES_NIL_TERMINATION;
 @end
