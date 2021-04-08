#import "ImageOverlayEditPlugin.h"
#if __has_include(<image_overlay_edit/image_overlay_edit-Swift.h>)
#import <image_overlay_edit/image_overlay_edit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "image_overlay_edit-Swift.h"
#endif

@implementation ImageOverlayEditPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImageOverlayEditPlugin registerWithRegistrar:registrar];
}
@end
