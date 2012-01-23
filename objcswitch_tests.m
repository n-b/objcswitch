//
//  objcswitch_tests.m
//  objcswitch_tests
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>
#import "NSObject+objcswitch.h"


@interface objcswitch_tests : SenTestCase

@end

@implementation objcswitch_tests

- (void)test_respondsToSelectorBasic
{
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::case::)], @"bad!");
}

- (void)test_respondsToSelectorDefault
{
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::default:)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::default:)], @"bad!");
    STAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::case::default:)], @"bad!");
}

- (void)test_respondsToSelectorMalformed
{
    STAssertFalse([[@"foo" switch] respondsToSelector:@selector(wrong)], @"bad!");
    STAssertFalse([[@"foo" switch] respondsToSelector:@selector(case::miss::case::default:)], @"bad!");
}

- (void)testBasicCall_1
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");
}

- (void)testBasicCall_2 // Checks that the implementation is called correctly the second time
{
    [self testBasicCall_1];
}

- (void)testCall_2
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    STAssertTrue(success,@"bad!");
}

- (void)testCallWithDefault_1
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     default:^{ success = YES;}
     ];
    STAssertTrue(success,@"bad!");
}

- (void)testCallWithDefault_2
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     default:^{ success = NO;}
     ];
    STAssertTrue(success,@"bad!");
}

@end

// Only needed to compile objcswitch_tests_build to use Xcode's "Generate Preprocessed File"
int main()
{
}