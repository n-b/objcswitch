# objcswitch

An experiment with blocks, objective-C, and adding features to the language.

The implementation lets you write stuff like that :

	[[@"foo" switch]
	 case:@"bar" :^{ success = NO; }
	 case:@"baz" :^{ success = NO; }
	 case:@"foo" :^{ success = YES; }
	 ];