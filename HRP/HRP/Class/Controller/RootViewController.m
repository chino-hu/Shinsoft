//
//  RootViewController.m
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "RootViewController.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

@interface RootViewController () <MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
}

@end

@implementation RootViewController

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
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( ios7 )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    #endif	// #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    [self setUpNavigationItem];
    [self addRightNavItem];
    [super viewDidLoad];
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.myTableView;
    /*
    
    NSURL *url = [NSURL URLWithString:@"http://118.145.0.70:8099/openapi"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSString *str = @"{\"header\":{\"request_type\":\"F00.00.01.01\",\"src\":1,\"deviceid\":\"sdfsdf\",\"smid\":\"333\"}}";//设置参数
    NSData *d = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:d];
    [request setHTTPMethod:@"Post"];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str1);
     */
}

#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self doRequest];
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self.myTableView selector:@selector(reloadData) userInfo:nil repeats:NO];
}

- (void)addRightNavItem
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"二维码" style:UIBarButtonItemStylePlain target:self action:@selector(d2)];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)d2
{
    UIViewController *vc = [[UIViewController alloc] init];
    UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"d2"]];
    imv.frame = CGRectMake(20, 100, 280, 280);
    [vc.view addSubview:imv];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUpNavigationItem
{
    UIBarButtonItem *exit = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(btn_exit_clicked:)];
    self.navigationItem.leftBarButtonItem = exit;
    exit.tintColor = [UIColor colorWithRed:40/255.0 green:135/255.0 blue:212.0/255.0 alpha:1];
    //新建申请按钮
    /*
    UIBarButtonItem *create = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createRequest:)];
    self.navigationItem.rightBarButtonItem = create;
    [create release];
    
    */
    
    if(IPHONE_OS_LOWER_VERSION)
        self.navigationController.delegate = self;
    self.title = @"任务列表";
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self doRequest];
}

- (void)doRequest
{
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPTaskList]];
    //    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:auth forKey:kHRPXlesAuth];
    [request setPostValue:@"ApplicationCode" forKey:@"HRP"];
    //当querycount不为空时，此服务为查询待审批任务数量。当querycount为空时，为查询待办事宜。
//    [request setPostValue:@"a" forKey:@"querycount"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)createRequest:(id)sender
{
    SettingViewController *setting = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
    setting.title = @"新建申请";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:YES];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
//    [Default showActivityIndicatorInView:self.view WithMessage:@""];
    [SVProgressHUD show];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    [Default hideActivityIndicatorInView:self.view];
    [SVProgressHUD dismiss];
    if(!headers)
        headers = [[NSMutableArray alloc] init];
    if(!data)
        data = [[NSMutableArray alloc] init];
    if(!jobs)
        jobs = [[NSMutableArray alloc] init];
    if(!appIds)
        appIds = [[NSMutableArray alloc] init];
    [appIds removeAllObjects];
    [jobs removeAllObjects];
    [headers removeAllObjects];
    [data removeAllObjects];
    
    NSDictionary *dic = [[request responseString] objectFromJSONString];
    NSArray *arr = [dic objectForKey:@"PreferenceSpecifiers"];
    NSMutableArray *cols = nil;
    NSMutableArray *jobarr = nil;
    NSDictionary *jobdic = nil;
    for(id obj in arr) {
        NSString *taskId = [obj objectForKey:@"TaskID"];
        NSString *destId = [obj objectForKey:@"DestinationID"];
        NSString *type = [obj objectForKey:@"Type"];
        NSString *title = [obj objectForKey:@"Title"];
       
        if(title.length > 20) {
            [appIds addObject:[title substringFromIndex:(title.length - 13)]];
        }
        
        
        if([type isEqualToString:@"PSGroupSpecifier"]) {
            cols = [NSMutableArray array];
            [headers addObject:title];
            [data addObject:cols];
            jobarr = [NSMutableArray array];
            [jobs addObject:jobarr];
        }
        if([type isEqualToString:@"PSChildPaneSpecifier"]) {
            [cols addObject:title];
            jobdic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:taskId, destId, nil] forKeys:[NSArray arrayWithObjects:@"TaskID", @"DestinationID", nil]];
            [jobarr addObject:jobdic];
        }
    }
    [_myTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *info = [[request error] localizedDescription];
    [SVProgressHUD showErrorWithStatus:info];
    NSLog(@"%@", [request error]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [headers count] + 1;
    return [headers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [_header endRefreshing];
//    if(section == 1) {
//        return [[data objectAtIndex:0] count];
//    }
//    if(section == 0) {
//        return 1;
//    }
//    return 0;
    return [[data objectAtIndex:0] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if(section == 0) {
//        return @"我的申请";
//    }
//    if(section == 1) {
//        return [headers objectAtIndex:0];
//    }
//
//    return @"";
    return [headers objectAtIndex:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (ios7) {
        return 35;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    if(indexPath.section == 1) {
//        cell.textLabel.text = [[data objectAtIndex:0] objectAtIndex:indexPath.row];
//    }
//    if(indexPath.section == 0) {
//        cell.textLabel.text = @"报销申请单";
//    }
    cell.textLabel.text = [[data objectAtIndex:0] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    cell.accessoryType = [cell.textLabel.text isEqualToString:@"暂无"] ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [[data objectAtIndex:0] objectAtIndex:indexPath.row];
    if([title isEqualToString:@"暂无"]) {
        return;
    }
    TaskDetailViewController *detailViewController = [[TaskDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.title = @"任务详细";
    detailViewController.appId = [appIds objectAtIndex:indexPath.row];
    detailViewController.taskId = [[[jobs objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"TaskID"];
    detailViewController.destId = [[[jobs objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"DestinationID"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)btn_exit_clicked:(id)sender {
    [self.delegate didLogoutLoginInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


@end
