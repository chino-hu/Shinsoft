//
//  AttachmentsViewController.m
//  仁济财务平台
//
//  Created by Chino Hu on 13-9-23.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import "AttachmentsViewController.h"
#import "WebViewController.h"

@interface AttachmentsViewController ()

@end

@implementation AttachmentsViewController

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
    // Do any additional setup after loading the view from its nib.
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.atts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.textLabel.text = [[self.atts objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *web = [[WebViewController alloc] init];
    web.url = [[self.atts objectAtIndex:indexPath.row] objectForKey:@"url"];
    web.title = @"附件内容";
    web.fileName = [[self.atts objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMytable:nil];
    [super viewDidUnload];
}
@end
