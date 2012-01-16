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
     @"bar",^{
         STFail(@"BAD");
     },
     @"foo",^{
         success = YES;
     },
     nil];
    STAssertTrue(success, @"foo must equal foo");
}

@end
