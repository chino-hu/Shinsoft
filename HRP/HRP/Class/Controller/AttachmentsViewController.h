//
//  AttachmentsViewController.h
//  仁济财务平台
//
//  Created by Chino Hu on 13-9-23.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *mytable;

@property (nonatomic, strong) NSMutableArray *atts;

@end
