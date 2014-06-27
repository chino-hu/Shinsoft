//
//  GetDeviceMacAddress.h
//  LifeWeekly
//
//  Created by xie on 12-9-14.
//
//

#import <UIKit/UIKit.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface GetDeviceMacAddress : NSObject

// 获得加密后的WIFI地址
+ (NSString *)macaddress;
+ (NSString *) md5: (NSString *) inPutText ;
@end
