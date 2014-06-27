//
//  DetailViewController.m
//  HRP
//
//  Created by shinsoft  on 13-1-31.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import "DetailViewController.h"
#import "Default.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:1];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPParamList]];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    if(self.type == 0) {
        [request setPostValue:[NSString stringWithFormat:@"{\"Code\":\"User\", \"value\":\"%@\"}", self.name] forKey:@"Parameters"];
    }
    if(self.type == 1) {
        [request setPostValue:@"{\"Code\":\"BudgetAccount\", \"value\":\"\"}" forKey:@"Parameters"];//BudgetAccount
    }
    [request setDelegate:self];
    [request startAsynchronous];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    id level = [[self.data objectAtIndex:indexPath.row] objectForKey:@"level"];
    if(level != [NSNull null]) {
        NSString *temp = [NSString stringWithFormat:@"%@", @""];
        for(int i = 0; i < [level intValue]; i ++) {
            temp = [temp stringByAppendingString:@"     "];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", temp, [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"]];
    }
    else {
        cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
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

- (void)requestStarted:(ASIHTTPRequest *)request
{
    [Default showActivityIndicatorInView:self.view WithMessage:@""];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Default hideActivityIndicatorInView:self.view];
    self.data = [[request responseString]  objectFromJSONString];
    [self.dataTable reloadData];
    NSLog(@"%@", [request responseString]);
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
    [self setDataTable:nil];
    [super viewDidUnload];
}
@end
