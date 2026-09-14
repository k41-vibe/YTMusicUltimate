#import <Foundation/Foundation.h>
#import <rootless.h>
#import "../Utils/NSBundle+YTMU.h"
#import "ABCSwitch.h"

// Never hand back nil: the settings controllers drop LOC() straight into dictionary
// literals, so a bundle that could not be found would crash the app instead of just
// showing untranslated keys.
//
// This has to be a function, not a macro that can fold down to the key literal: several
// call sites pass the result to +stringWithFormat:, and clang would then read the key as
// the format string and reject the arguments (-Wformat-extra-args).
static inline NSString *YTMULocalizedString(NSString *key) {
    NSString *value = [NSBundle.ytmu_defaultBundle localizedStringForKey:key value:key table:nil];
    return value ?: key;
}
#define LOC(key) YTMULocalizedString(key)
