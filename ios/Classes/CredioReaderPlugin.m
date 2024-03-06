#import "CredioReaderPlugin.h"
#if __has_include(<credio_reader/credio_reader-Swift.h>)
#import <credio_reader/credio_reader-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "credio_reader-Swift.h"
#endif

@implementation CredioReaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCredioReaderPlugin registerWithRegistrar:registrar];
}
@end
