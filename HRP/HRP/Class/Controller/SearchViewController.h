//
//  SearchViewController.h
//  HRP
//
//  Created by shinsoft  on 12-8-24.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoAnimation.h"
#import "Default.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"

@protocol SearchViewDelegate<NSObject>
- (void)dismissPopOver:(UIView *)popOver withDestUserId:(NSString *)destId;
@end


@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ASIHTTPRequestDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    MBProgressHUD *hud;
    NSString *selectedUserId;
    NSInteger selectedIndex;
    NSMutableArray *userArray;
    NSDictionary *userDictionary;
//    NSArray *filteredArray;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) id<SearchViewDelegate> delegate;

- (IBAction)dismissPopover:(id)sender;
- (IBAction)removePopover:(id)sender;

@end


