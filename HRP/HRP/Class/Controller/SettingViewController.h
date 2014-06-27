//
//  SettingViewController.h
//  HRP
//
//  Created by shinsoft  on 12-8-24.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "ASIFormDataRequest.h"
#import "TextFieldTableCellView.h"
#import "ToggleTableCellView.h"
#import "SliderTableCellView.h"
#import "NVUIGradientButton.h"
#import "AutoAnimation.h"
#import "UserViewController.h"
#import "JSONKit.h"
#import "NameViewController.h"

@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DetailViewDelegate, ASIHTTPRequestDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *sectionHeader;
    int row;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) UITextField *field;
@property (strong, nonatomic) NSMutableDictionary *param;

@end
