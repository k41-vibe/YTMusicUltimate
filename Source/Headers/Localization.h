#import <Foundation/Foundation.h>
#import <rootless.h>
#import "../Utils/NSBundle+YTMU.h"
#import "ABCSwitch.h"

// Never hand back nil: the settings controllers drop LOC() straight into dictionary
// literals, so a bundle that could not be found would crash the app instead of just
// showing untranslated keys.
#define LOC(key) ([NSBundle.ytmu_defaultBundle localizedStringForKey:(key) value:(key) table:nil] ?: (key))
