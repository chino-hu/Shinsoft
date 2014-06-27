//
//  NameViewController.h
//  HRP
//
//  Created by shinsoft  on 13-2-1.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "DetailViewController.h"
#import "JSONKit.h"

@interface NameViewController : UIViewController<ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *nameTable;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, assign) id<DetailViewDelegate> delegate;

@end
