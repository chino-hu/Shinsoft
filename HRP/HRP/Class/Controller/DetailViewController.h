//
//  DetailViewController.h
//  HRP
//
//  Created by shinsoft  on 13-1-31.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@protocol DetailViewDelegate <NSObject>

- (void)showSelectedItem:(NSString *)name Code:(NSString *)code;

@end

@interface DetailViewController : UIViewController<ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSString *name;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UITableView *dataTable;
@property (nonatomic, assign) id<DetailViewDelegate> delegate;

@end
