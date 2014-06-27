//
//  Default.m
//  HRP
//
//  Created by shinsoft  on 12-11-8.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "Default.h"

@implementation Default

+ (void)showActivityIndicatorInView:(UIView *)view WithMessage:(NSString *)info
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = info;
    hud.labelFont = [UIFont systemFontOfSize:12.0];
}

+ (void)hideActivityIndicatorInView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
