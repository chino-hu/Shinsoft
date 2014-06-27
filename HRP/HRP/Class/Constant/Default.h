//
//  Default.h
//  HRP
//
//  Created by shinsoft  on 12-9-10.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "MBProgressHUD.h"

#ifndef HRP_Default_h
#define HRP_Default_h

#define         kHRPXlesAuth                    @"XLES_AUTH"
#define         kHRPServerIP                    @"SERVER_ADDRESS"
#define         kHRPLoginUserId                 @"USER_ID"
#define         kHRPLoginUserName               @"USER_NAME"
#define         kHRPLoginAccount                @"USER_ACCOUNT"
#define         kHRPLoginPassword                @"USER_PASSWORD"
#define         kHRPButtonKey                   @"BUTTON_TITLE"
//192.168.0.10:9005/shinflow
//192.168.0.10:9007

#define         kHRPServiceAddress              @"180.166.62.50:8002" //HRD
//#define         kHRPServiceAddress              @"180.166.62.50:8004"   //DEV

#define         kHRPAuthLogin                   @"/MobileDevicesService/authlogin.ashx"
#define         kHRPTaskList                    @"/MobileDevicesService/Gtasks.ashx"
#define         kHRPUserList                    @"/MobileDevicesService/UserListLoad.ashx"
#define         kHRPTaskProcess                 @"/MobileDevicesService/Process.ashx"
#define         kHRPTaskOperation               @"/MobileDevicesService/OpenTask.ashx"
//192.168.0.10:9006
#define         kHRPParamList                   @"/Modules/Custom/RenJi/JsonHandler/ParamHandler.ashx"
#define         kHRPRequestSubmit               @"/Modules/Custom/RenJi/JsonHandler/ApplicationSubmitHandler.ashx"

//DEV
//#define         kHRPAttachmenRequest            @"http://180.166.62.50:8003/Modules/Custom/RenJi/JsonHandler/AttachmentsHandler.ashx?applicationId="
//HRD
#define         kHRPAttachmenRequest            @"http://180.166.62.50:8001/Modules/Custom/RenJi/JsonHandler/AttachmentsHandler.ashx?applicationId="

#define         IPHONE_OS_LOWER_VERSION         [[[UIDevice currentDevice] systemVersion] floatValue] < 4.3
#define         IPHONE_OS_MIDDLE_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue] > 4.3 && [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0
#define         IPHONE_OS_HIGHER_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue] > 5.1.1

#endif

#define ios7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define kIsIphone5 [UIScreen mainScreen].applicationFrame.size.height > 960
#define k_frame_base_width [[UIScreen mainScreen]bounds].size.width
#define k_frame_base_height [[UIScreen mainScreen]bounds].size.height

#define setFrameY(view, newY) CGRect rect = view.frame; rect.origin.y = newY; view.frame = rect;

@interface Default : NSObject

+ (void)showActivityIndicatorInView:(UIView *)view WithMessage:(NSString *)info;
+ (void)hideActivityIndicatorInView:(UIView *)view;

@end
