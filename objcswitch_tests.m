//
//  objcswitch_tests.m
//  objcswitch_tests
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import "NSObject+objcswitch.h"
#import <SenTestingKit/SenTestingKit.h>

@interface objcswitch_tests : SenTestCase

@end

@implementation objcswitch_tests

- (void)testTest
{
    BOOL __block success = NO;
    [@"foo" switch:
     [$Case :@"bar" :^{ STFail(@"foo must be different from bar!"); }],
     [$Case :@"foo" :^{ success = YES; }],
     nil];
    STAssertTrue(success, @"foo must equal foo");
}

@end
