//
//  ToggleTableCellView.h
//  HRP
//
//  Created by shinsoft  on 12-8-24.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleTableCellView : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UISwitch *toggle;
@end
