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

- (void)testSwitch
{
    BOOL __block success = NO;

    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");

    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");

    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");
}

@end
