#import "Headers/SafeKVC.h"
#import <objc/runtime.h>

// The ivar lookup covers the private "_foo" names, the selector check covers keys that are
// really properties, and the @try is kept on top of both because KVC also reaches keys
// through accessors a superclass declares and there is no cheap way to predict every one.
static BOOL ytmu_hasKey(id object, NSString *key) {
    if (!object || key.length == 0) return NO;
    if ([object respondsToSelector:NSSelectorFromString(key)]) return YES;

    Class cls = [object class];
    if (class_getInstanceVariable(cls, key.UTF8String) != NULL) return YES;
    return class_getInstanceVariable(cls, [@"_" stringByAppendingString:key].UTF8String) != NULL;
}

id ytmu_safeValueForKey(id object, NSString *key) {
    if (!ytmu_hasKey(object, key)) return nil;
    @try {
        return [object valueForKey:key];
    } @catch (NSException *exception) {
        return nil;
    }
}

void ytmu_safeSetValue(id object, NSString *key, id value) {
    if (!ytmu_hasKey(object, key)) return;
    @try {
        [object setValue:value forKey:key];
    } @catch (NSException *exception) {}
}
