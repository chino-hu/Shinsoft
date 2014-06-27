//
//  LoginViewController.h
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "AutoAnimation.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Default.h"
#import "JSONKit.h"
#import "Default.h"
#import "TextAlertView.h"
#import "RootViewController.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate, UITextViewDelegate,RootViewControllerDelegate>
{
    TextAlertView *textAlert;
}
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIImageView *fieldImage;

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UITextField *account;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) RootViewController *root;
@property (strong, nonatomic) IBOutlet UIButton *setButton;

- (IBAction)btn_login_clicked:(id)sender;
- (IBAction)btn_setup_clicked:(id)sender;

@end
