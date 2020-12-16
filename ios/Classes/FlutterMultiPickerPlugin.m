#import "FlutterMultiPickerPlugin.h"
#if __has_include(<flutter_multi_picker/flutter_multi_picker-Swift.h>)
#import <flutter_multi_picker/flutter_multi_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_multi_picker-Swift.h"
#endif

@implementation FlutterMultiPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMultiPickerPlugin registerWithRegistrar:registrar];
}
@end
