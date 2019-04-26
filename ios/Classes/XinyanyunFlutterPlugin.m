#import "XinyanyunFlutterPlugin.h"
#import <xinyanyun_flutter/xinyanyun_flutter-Swift.h>

@implementation XinyanyunFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftXinyanyunFlutterPlugin registerWithRegistrar:registrar];
}
@end
