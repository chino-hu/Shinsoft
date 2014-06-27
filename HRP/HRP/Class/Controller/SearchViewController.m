//
//  SearchViewController.m
//  HRP
//
//  Created by shinsoft  on 12-8-24.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchbar;
@synthesize tableview;
@synthesize delegate;

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
    if(IPHONE_OS_LOWER_VERSION)
        self.navigationController.delegate = self;
    tableview.backgroundColor = [UIColor clearColor];
    [[searchbar.subviews objectAtIndex:0] removeFromSuperview];
    searchbar.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(selectedUserId) {
        selectedUserId = nil;
    }
    self.saveButton.enabled = NO;
    [userArray removeAllObjects];
    
//    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
//    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
//    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPUserList]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:auth forKey:kHRPXlesAuth];
//    [request setDelegate:self];
//    [request startAsynchronous];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    if(hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
    }
    hud.labelText = @"";
    hud.dimBackground = YES;
    [hud show:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [hud hide:YES afterDelay:.2f];
    NSDictionary *arr = [[request responseString] objectFromJSONString];
    if(!arr) return;
    if(userArray == nil) {
        userArray = [[NSMutableArray alloc] init];
    }
    [userArray removeAllObjects];
    NSMutableArray *dics = [NSMutableArray array];
//    NSLog(@"%@", arr);
    for(NSDictionary *user in arr) {
        [userArray addObject:[NSString stringWithFormat:@"%@ %@", [user objectForKey:@"LoginID"], [user objectForKey:@"display"]]];
        [dics addObject:[user objectForKey:@"id"]];
    }
    userDictionary = [NSDictionary dictionaryWithObjects:dics forKeys:userArray];
    
//    filteredArray = [userArray retain];
    [tableview reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [hud hide:YES afterDelay:.2f];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.text = [userArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor blackColor];
    if(indexPath.row == selectedIndex && selectedUserId) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor brownColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [delegate dismissPopOver:YES];
    selectedIndex = indexPath.row;
    self.saveButton.enabled = YES;
    
    [searchbar resignFirstResponder];
    UITableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    selectedUserId = [userDictionary objectForKey:cell.textLabel.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if(cell.accessoryType == UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.textLabel.textColor = [UIColor brownColor];
//        return;
//    }
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.textLabel.textColor = [UIColor blackColor];
    [tableView reloadData];
}

/*
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""]) {
        filteredArray = userArray;
        [tableview reloadData];
    }
}
 */

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPUserList]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:auth forKey:kHRPXlesAuth];
    [request setPostValue:searchBar.text forKey:@"name"];
    [request setDelegate:self];
    [request startAsynchronous];

    [self.view endEditing:YES];
}

/*
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains %@", searchBar.text];
    filteredArray = [[userArray filteredArrayUsingPredicate:predicate] retain];
    [tableview reloadData];
}
 */

- (IBAction)dismissPopover:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要加签此用户吗？"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        searchbar.text = @"";
        CATransition *animation = [AutoAnimation createAnimation];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.type = @"kCATransitionMoveIn";
        self.view.frame = CGRectMake(0, 0, 0, 0);
        self.view.alpha = 0.0f;
        [[self.view layer] addAnimation:animation forKey:@"animation"];
        if(selectedUserId)
            [delegate dismissPopOver:self.view withDestUserId:selectedUserId];
    }
}

- (IBAction)removePopover:(id)sender {
    searchbar.text = @"";
    CATransition *animation = [AutoAnimation createAnimation];
    animation.delegate = self;
    animation.type = @"kCATransitionMoveIn";
    self.view.frame = CGRectMake(0, 0, 0, 0);
    self.view.alpha = 0.0f;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setSearchbar:nil];
    [self setTableview:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
