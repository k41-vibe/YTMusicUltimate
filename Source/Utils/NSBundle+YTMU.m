#import "NSBundle+YTMU.h"
#import <dlfcn.h>

// Only used to find out where this dylib was loaded from (dladdr needs an address
// that belongs to this image).
__attribute__((used)) static void ytmu_anchor(void) {}

@implementation NSBundle (YTMusicUltimate)

+ (NSBundle *)ytmu_defaultBundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSMutableArray<NSString *> *candidates = [NSMutableArray array];

        // 1. Inside the host app (merged ipa)
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"YTMusicUltimate" ofType:@"bundle"];
        if (tweakBundlePath) [candidates addObject:tweakBundlePath];

        // 2. Where a jailbreak puts it
        [candidates addObject:ROOT_PATH_NS(@"/Library/Application Support/YTMusicUltimate.bundle")];

        // 3. Next to this dylib. In LiveContainer the tweak is loaded out of a tweak
        //    folder and there is no jailbreak root, so the two paths above both miss.
        //    Without this the settings screens crash: LOC() hands nil to the first
        //    @{@"title": ...} literal they build.
        Dl_info info;
        if (dladdr((const void *)&ytmu_anchor, &info) && info.dli_fname) {
            NSString *dir = [[NSString stringWithUTF8String:info.dli_fname] stringByDeletingLastPathComponent];
            [candidates addObject:[dir stringByAppendingPathComponent:@"YTMusicUltimate.bundle"]];
            [candidates addObject:[dir stringByAppendingPathComponent:@"Application Support/YTMusicUltimate.bundle"]];
        }

        for (NSString *path in candidates) {
            if (![fm fileExistsAtPath:path]) continue;
            bundle = [NSBundle bundleWithPath:path];
            if (bundle) break;
        }
    });

    return bundle;
}

@end
