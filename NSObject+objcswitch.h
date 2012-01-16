//
//  NSObject+objcswitch.h
//  objcswitch
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Nicolas Bouilleaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjcSwitch;

@interface NSObject (objcswitch)
- (ObjcSwitch *) switch;
@end

@interface ObjcSwitch : NSObject
- (void) case:(id)v :(void (^)(void))b;
- (void) case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b;
- (void) case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b;
- (void) case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b
         case:(id)v :(void (^)(void))b;
@end
