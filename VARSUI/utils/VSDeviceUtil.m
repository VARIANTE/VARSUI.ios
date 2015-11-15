/**
 *  VARSUI
 *  (c) VARIANTE <http://variante.io>
 *
 *  Utility for device-specific helper methods.
 *
 *  This software is released under the MIT License:
 *  http://www.opensource.org/licenses/mit-license.php
 */

#import <sys/utsname.h>

#import "VSDeviceUtil.h"

@implementation VSDeviceUtil

+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceModelName {
    NSString *model = [VSDeviceUtil deviceModel];

    if ([model isEqualToString:@"i386"]) { return @"32-bit Simulator"; }
    else if ([model isEqualToString:@"x86_64"]) { return @"64-bit Simulator"; }
    else if ([model isEqualToString:@"iPod1,1"]) { return @"iPod Touch"; }
    else if ([model isEqualToString:@"iPod2,1"]) { return @"iPod Touch 2nd Gen"; }
    else if ([model isEqualToString:@"iPod3,1"]) { return @"iPod Touch 3rd Gen"; }
    else if ([model isEqualToString:@"iPod4,1"]) { return @"iPod Touch 4th Gen"; }
    else if ([model isEqualToString:@"iPhone1,1"]) { return @"iPhone"; }
    else if ([model isEqualToString:@"iPhone1,2"]) { return @"iPhone 3G"; }
    else if ([model isEqualToString:@"iPhone2,1"]) { return @"iPhone 3GS"; }
    else if ([model isEqualToString:@"iPhone3,1"]) { return @"iPhone 4 (GSM)"; }
    else if ([model isEqualToString:@"iPhone3,3"]) { return @"iPhone 4 (CDMA)"; }
    else if ([model isEqualToString:@"iPhone4,1"]) { return @"iPhone 4S"; }
    else if ([model isEqualToString:@"iPhone5,1"]) { return @"iPhone 5 (A1428)"; }
    else if ([model isEqualToString:@"iPhone5,2"]) { return @"iPhone 5 (A1429)"; }
    else if ([model isEqualToString:@"iPhone5,3"]) { return @"iPhone 5c (A1456, A1532)"; }
    else if ([model isEqualToString:@"iPhone5,4"]) { return @"iPhone 5c (A1507, A1516, A1526, A1529)"; }
    else if ([model isEqualToString:@"iPhone6,1"]) { return @"iPhone 5s (A1433, A1533)"; }
    else if ([model isEqualToString:@"iPhone6,2"]) { return @"iPhone 5s (A1457, A1518, A1528, A1530)"; }
    else if ([model isEqualToString:@"iPhone7,1"]) { return @"iPhone 6 Plus"; }
    else if ([model isEqualToString:@"iPhone7,2"]) { return @"iPhone 6"; }
    else if ([model isEqualToString:@"iPhone8,2"]) { return @"iPhone 6S"; }
    else if ([model isEqualToString:@"iPhone8,2"]) { return @"iPhone 6S Plus"; }
    else if ([model isEqualToString:@"iPad1,1"]) { return @"iPad"; }
    else if ([model isEqualToString:@"iPad2,1"]) { return @"iPad 2"; }
    else if ([model isEqualToString:@"iPad3,1"]) { return @"iPad 3"; }
    else if ([model isEqualToString:@"iPad3,4"]) { return @"iPad 4"; }
    else if ([model isEqualToString:@"iPad4,1"]) { return @"iPad Air (Wifi)"; }
    else if ([model isEqualToString:@"iPad4,2"]) { return @"iPad Air (Cellular)"; }
    else if ([model isEqualToString:@"iPad5,3"]) { return @"iPad Air 2 (Wifi)"; }
    else if ([model isEqualToString:@"iPad5,4"]) { return @"iPad Air 2 (Cellular)"; }
    else if ([model isEqualToString:@"iPad6,7"]) { return @"iPad Pro (Wifi)"; }
    else if ([model isEqualToString:@"iPad6,8"]) { return @"iPad Pro (Cellular)"; }
    else if ([model isEqualToString:@"iPad2,5"]) { return @"iPad Mini"; }
    else if ([model isEqualToString:@"iPad4,4"]) { return @"iPad Mini 2 (Wifi)"; }
    else if ([model isEqualToString:@"iPad4,5"]) { return @"iPad Mini 2 (Cellular)"; }
    else if ([model isEqualToString:@"iPad4,7"]) { return @"iPad Mini 3 (Wifi)"; }
    else if ([model isEqualToString:@"iPad4,8"]) { return @"iPad Mini 3 (Cellular)"; }
    else if ([model isEqualToString:@"iPad5,1"]) { return @"iPad Mini 4 (Wifi)"; }
    else if ([model isEqualToString:@"iPad5,2"]) { return @"iPad Mini 4 (Cellular)"; }
    else { return @"Unknown"; }
}

@end
