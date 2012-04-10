//
//  main.m
//  objcswitch_ios_tests
//
//  Created by Nicolas Bouilleaud on 10/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

int main(int argc, char *argv[])
{
#if TARGET_OS_IPHONE
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, nil);
    }
#endif
}
