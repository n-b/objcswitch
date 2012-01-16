//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (objcswitch)
- (void) switch:(id)firstValue, ... NS_REQUIRES_NIL_TERMINATION;
@end
