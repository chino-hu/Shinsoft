//
//  HomeViewController.m
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize navigationViewController;

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:navigationViewController.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"home view will appear...");
}

- (void)viewDidUnload
{
    [self setNavigationViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.view removeFromSuperview];
}

- (IBAction)nav_logout_clicked:(id)sender {
    CATransition *animation = [AutoAnimation createAnimation];
    animation.delegate = self;
    animation.type = @"ResizeForKeyBoard";
    self.view.alpha = 0.0f;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}

- (IBAction)nav_setting_clicked:(id)sender {
    if(settingViewController == nil) {
        settingViewController = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    }
    [navigationViewController pushViewController:settingViewController animated:YES];
}
@end
