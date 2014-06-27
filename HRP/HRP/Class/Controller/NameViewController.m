//
//  NameViewController.m
//  HRP
//
//  Created by shinsoft  on 13-2-1.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import "NameViewController.h"
#import "Default.h"

@interface NameViewController ()

@end

@implementation NameViewController

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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
    //    NSLog(@"%@, %@", [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"], [[self.data objectAtIndex:indexPath.row] objectForKey:@"value"]);
    [self.delegate showSelectedItem:[[self.data objectAtIndex:indexPath.row] objectForKey:@"name"] Code:[[self.data objectAtIndex:indexPath.row] objectForKey:@"value"]];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:1];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPParamList]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSString stringWithFormat:@"{\"Code\":\"User\", \"value\":\"%@\"}", searchBar.text] forKey:@"Parameters"];//BudgetAccount
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    [Default showActivityIndicatorInView:self.view WithMessage:@""];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Default hideActivityIndicatorInView:self.view];
    self.data = [[request responseString]  objectFromJSONString];
    [self.nameTable reloadData];
    //    NSLog(@"%@", [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Default hideActivityIndicatorInView:self.view];
    NSLog(@"%@", [request error]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
