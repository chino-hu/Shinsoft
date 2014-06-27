//
//  BaseViewController.m
//  HRP
//
//  Created by ShinSoft on 14-1-22.
//  Copyright (c) 2014年 shinsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "Default.h"

#define NAV_BAR_BGCOLOR [UIColor colorWithRed:139/255.0 green:184/255.0 blue:234/255.0 alpha:1]

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (ios7) {
        [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 2)
                                                               radius:2
                                                                color:[UIColor darkGrayColor]
                                                              opacity:1];
        
        self.navigationController.navigationBar.barTintColor = NAV_BAR_BGCOLOR;
        
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
