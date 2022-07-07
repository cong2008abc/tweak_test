/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

#import <substrate.h>
#import <string.h>
#import <Foundation/Foundation.h>

void (*old__ZN8CPPClass11CPPFunctionEPKc)(void *, const char *);
void new__ZN8CPPClass11CPPFunctionEPKc(void *hiddenThis, const char *arg0)
{
	if (strcmp(arg0, "This is a short C function!") == 0) 
		old__ZN8CPPClass11CPPFunctionEPKc(hiddenThis, "This is a hijacked short C function from new__ZN8CPPClass11CPPFunctionEPKc!");
	else
		old__ZN8CPPClass11CPPFunctionEPKc(hiddenThis, "This is a hijacked C++ function!");
}

void (*old_CFunction) (const char *);
void new_CFunction(const char *arg0)
{
	old_CFunction("This is a hijacked C function!"); // Call the original CFunction
}

void (*old_ShortCFunction)(const char *);
void new_ShortCFunction(const char *arg0)
{
	old_ShortCFunction("This is a hijacked short C function from new_ShortCFunction!"); // Call the orign ShortCFunction
}

%ctor
{
	@autoreleasepool
	{
		//MSGetImageByName的参数是：Symbol函数实现所在的二进制路径文件全路径
		MSImageRef image = MSGetImageByName("/Applications/iOSRETargetApp.app/iOSRETargetApp");

		void* __ZN8CPPClass11CPPFunctionEPKc = MSFindSymbol(image, "__ZN8CPPClass11CPPFunctionEPKc");
		if (__ZN8CPPClass11CPPFunctionEPKc) {
			NSLog(@"-----iOSRE: Found C++ Function!");
			//MSHookFunction的三个参数分别是： 替换的原函数， 替换的新函数，及被mobileHook保存的原函数
			MSHookFunction((void*)__ZN8CPPClass11CPPFunctionEPKc, (void *)&new__ZN8CPPClass11CPPFunctionEPKc, (void **)&old__ZN8CPPClass11CPPFunctionEPKc);
		} else
			NSLog(@"-----iOSRE: not Found C++ Function");

		void* _CFunction = MSFindSymbol(image, "_CFunction");
		if (_CFunction) {
			NSLog(@"-----iOSRE: Found C Function!");
			MSHookFunction((void*)_CFunction, (void *)&new_CFunction, (void **)&old_CFunction);
		} else
			NSLog(@"-----iOSRE: not found short Function.");

		void* _ShortCFunction = MSFindSymbol(image, "_ShortCFunction");
		if (_ShortCFunction) {
			NSLog(@"-----iOSRE: Found Short Function");
			MSHookFunction((void*)_ShortCFunction, (void *)&new_ShortCFunction, (void **)&old_ShortCFunction);
		} else
			NSLog(@"-----iOSRE: not found short Function.");
	}
}