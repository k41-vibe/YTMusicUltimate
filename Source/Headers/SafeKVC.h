#import <Foundation/Foundation.h>

// KVC against YouTube Music's private ivars. A name the current build no longer has does
// not come back nil from -valueForKey:, it raises NSUndefinedKeyException, so these check
// the key really exists before touching it and hand back nil / do nothing when it does not.
extern id ytmu_safeValueForKey(id object, NSString *key);
extern void ytmu_safeSetValue(id object, NSString *key, id value);
