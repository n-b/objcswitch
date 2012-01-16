# objcswitch

An experiment with blocks, objective-C, and adding features to a language.

The implementation lets you write stuff like that :

    [@"foo" switch:
     @"bar",^{ STFail(@"BAD"); },
     @"foo",^{ success = YES; },
     nil];

Another implementation would be to use an intermediate `$Case` object, to write thinks like that:

    [@"foo" switch:
     [$Case :@"bar" :^{ STFail(@"BAD"); }],
     [$Case :@"foo" :^{ success = YES; }],
     nil];

And yet another implementation would be to define many selectors, with every possible number of cases, to write stuff like that

    [@"foo" switch_case:@"bar" :^{ STFail(@"BAD"); },
                   case:@"foo" :^{ success = YES; }];
