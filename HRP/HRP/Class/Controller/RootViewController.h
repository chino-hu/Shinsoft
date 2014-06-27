//
//  RootViewController.h
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailViewController.h"
#import "SettingViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Default.h"
#import "JSONKit.h"
#import "BaseViewController.h"

@protocol RootViewControllerDelegate <NSObject>

- (void)didLogoutLoginInfo;

@end

@interface RootViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *headers;
    NSMutableArray *data;
    NSMutableArray *jobs;
    
    NSMutableArray *appIds;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,assign) id<RootViewControllerDelegate> delegate;

- (IBAction)btn_exit_clicked:(id)sender;

@end
