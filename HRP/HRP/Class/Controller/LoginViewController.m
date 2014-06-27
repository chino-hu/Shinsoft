//
//  LoginViewController.m
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
//010648
//000000
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( ios7 )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    #endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    
    _account.returnKeyType = UIReturnKeyNext;
    _password.returnKeyType = UIReturnKeyGo;
    _root = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    _root.delegate = self;
    self.setButton.center = CGPointMake(160, k_frame_base_height- 100);
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:40/255.0 green:135/255.0 blue:212.0/255.0 alpha:1];
    self.title = @"用户登录";
    
//    UIButton *setbtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    [setbtn setFrame:CGRectMake(0, 0, 30, 30)];
//    [setbtn addTarget:self action:@selector(btn_setup_clicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *sbtn = [[UIBarButtonItem alloc] initWithCustomView:setbtn];
//    self.navigationItem.rightBarButtonItem = sbtn;
//    [sbtn release];
    
    [self setupView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if(ios7) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂不支持iOS7"
//                                                        message:@""
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

- (void)setupView
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height > 480.f)
        {
            [self.bgImage setImage:[UIImage imageNamed:@"bg-1"]];
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES];
    
    NSString *acc = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginAccount];
    if(acc)
        self.account.text = acc;
    
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginPassword];
    if(pwd)
        self.password.text = pwd;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _account) {
        [_password becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
         [self restorePosition];
        [self btn_login_clicked:nil];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveUpPosition:textField == _account ? 1 : 2];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (void)restorePosition
{
    [UIView beginAnimations:nil context:(__bridge void *)(self.view)];
    [UIView setAnimationDuration:0.2f];
    CGRect frame = self.view.frame;
    if (ios7) {
        frame.origin.y = 64;
    } else {
        frame.origin.y = 0;
    }
    
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)moveUpPosition:(NSInteger)times
{
    CGRect frame = self.view.frame;
    [UIView beginAnimations:nil context:(__bridge void *)(self.view)];
    [UIView setAnimationDuration:0.3f];
    frame.origin.y = -40 * times;
    self.view.frame = frame;
    [UIView commitAnimations];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (UITextField *)getFirstResponder
{
    return [_account isFirstResponder] ? _account : _password;
}

- (IBAction)btn_login_clicked:(id)sender {
    [self restorePosition];
    [[self getFirstResponder] resignFirstResponder];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPAuthLogin]];
//    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:_account.text forKey:@"XLES_LoginID"];
    [request setPostValue:_password.text forKey:@"XLES_Pwd"];
    [request setDelegate:self];
    [request startAsynchronous]; 
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    //[Default showActivityIndicatorInView:self.view WithMessage:@""];
    [SVProgressHUD show];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    //[Default hideActivityIndicatorInView:self.view];
    [SVProgressHUD dismiss];
    NSDictionary *jsonData = [[request responseString] objectFromJSONString];
    NSLog(@"%@", jsonData);
    NSString *status = [jsonData objectForKey:@"status"];
    NSString *info = [jsonData objectForKey:@"info"];
    NSString *auth = [jsonData objectForKey:@"xles_auth"];
    NSString *name = [jsonData objectForKey:@"name"];
    
    if([status isEqualToString:@"success"]) {
        [[NSUserDefaults standardUserDefaults] setObject:_account.text forKey:kHRPLoginAccount];
        [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:kHRPLoginPassword];
        [[NSUserDefaults standardUserDefaults] setObject:auth forKey:kHRPXlesAuth];
        [[NSUserDefaults standardUserDefaults] setObject:info forKey:kHRPLoginUserId];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:kHRPLoginUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController pushViewController:_root animated:YES];
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
//                                                        message:info
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
        
        [SVProgressHUD showErrorWithStatus:info];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *info = [[request error] localizedDescription];
    [SVProgressHUD showErrorWithStatus:info];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务器连接失败" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//    [alert show];
}

- (IBAction)btn_setup_clicked:(id)sender {
    textAlert = nil;
    if(!textAlert) {
        textAlert = [[TextAlertView alloc] initWithTitle:@"服务器地址" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        textAlert.delegate = self;
        textAlert.btnEnabled = NO;
    }
    
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    textAlert.textview.text = address ? address : kHRPServiceAddress;
    textAlert.tag = 1;
    [textAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1) {
        NSString *ip = textAlert.textview.text;
        [[NSUserDefaults standardUserDefaults] setObject:ip forKey:kHRPServerIP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma  mark - RootViewControllerDelegate
- (void)didLogoutLoginInfo{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kHRPLoginAccount];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kHRPLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.account.text = @"";
    self.password.text = @"";
}


@end
