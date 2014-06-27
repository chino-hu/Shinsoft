//
//  TextFieldTableCellView.m
//  HRP
//
//  Created by shinsoft  on 12-8-24.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "TextFieldTableCellView.h"

@implementation TextFieldTableCellView
@synthesize label;
@synthesize textfield;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
