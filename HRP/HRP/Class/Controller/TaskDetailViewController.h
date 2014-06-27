//
//  TaskDetailViewController.h
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachmentsViewController.h"
#import "SearchViewController.h"
#import "AutoAnimation.h"
#import "MyWebView.h"
#import "MyProgressBar.h"
#import "Default.h"
#import "TextAlertView.h"
#import "JSONKit.h"
#import "CXAlertView.h"
#import "BaseViewController.h"

@interface TaskDetailViewController : BaseViewController <UIWebViewDelegate, UIAlertViewDelegate, SearchViewDelegate, MyWebViewProgressDelegate, ASIHTTPRequestDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    MyProgressBar *progressBar;
    SearchViewController *searchViewController;
    TextAlertView *textAlert;
    NSString *buttonClicked;
    BOOL webViewFinished;
    BOOL requestFinished;
}

@property (strong, nonatomic) NSDictionary *buttons;
@property (strong, nonatomic) NSString *taskId;
@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *destId;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIView *ShowSelectUserView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *showTableView;

@property (strong, nonatomic) IBOutlet MyWebView *webview;
@property (nonatomic, strong) NSMutableArray *attachments;


@end
