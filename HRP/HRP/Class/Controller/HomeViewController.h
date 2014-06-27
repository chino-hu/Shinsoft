//
//  HomeViewController.h
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoAnimation.h"
#import "SettingViewController.h"

@interface HomeViewController : UIViewController
{
    SettingViewController *settingViewController;
}

@property (strong, nonatomic) IBOutlet UINavigationController *navigationViewController;

- (IBAction)nav_logout_clicked:(id)sender;
- (IBAction)nav_setting_clicked:(id)sender;
@end
