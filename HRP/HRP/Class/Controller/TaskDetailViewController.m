//
//  TaskDetailViewController.m
//  HRP
//
//  Created by shinsoft  on 12-8-22.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "TaskDetailViewController.h"
#import "SVProgressHUD.h"

//颜色转换
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//按钮颜色
#define KColor_Button_TitleNormal RGBCOLOR(0,122,255)
#define KColor_Button_TitlePressed RGBCOLOR(76,158,216)

@interface TaskDetailViewController ()
@property (nonatomic,strong) UITextView *editTextView;
@property (nonatomic,strong) CXAlertView *alertViewMe;

@property (nonatomic,strong) NSMutableArray *userArray;
@property (nonatomic,strong) NSDictionary *userDictionary;
@property (nonatomic,strong) NSString *selectedUserId;


@end

@implementation TaskDetailViewController
@synthesize editTextView;
@synthesize alertViewMe;
@synthesize userArray;
@synthesize userDictionary;
@synthesize selectedUserId;


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
    [super viewDidLoad];
    
    
    
//    self.searchBar.showsCancelButton = YES;
    if (!ios7) {
//        for (UIView *subView in self.searchBar.subviews) {
//            if ([subView isKindOfClass:[UIButton class]]) {
//                UIButton *cancelButton = (UIButton*)subView;
//                [cancelButton setBackgroundColor:[UIColor clearColor]];
//                [cancelButton setTitleColor:KColor_Button_TitleNormal forState:UIControlStateNormal];
//                [cancelButton setTitleColor:KColor_Button_TitlePressed forState:UIControlStateHighlighted];
//                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//            }
//        }
        
        //修改搜索框背景
        self.searchBar.backgroundColor=[UIColor clearColor];
        [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
        
        
    } else {
        self.showTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}

- (void)initGCD
{
    dispatch_queue_t groupBack = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(groupBack, ^{
        //请求附件列表
        [self requestAttachments];
        //加载操作按钮
        [self requestOperations];
    });
}

- (void)showAttButton:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if(!self.attachments || self.attachments.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        UIBarButtonItem *attachment = [[UIBarButtonItem alloc] initWithTitle:@"附件" style:UIBarButtonItemStylePlain target:self action:@selector(showAttachments:)];
        self.navigationItem.rightBarButtonItem = attachment;
        attachment.tintColor = [UIColor colorWithRed:40/255.0 green:135/255.0 blue:212.0/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = attachment;
    }
}

- (void)showAttachments:(id)sender
{
    AttachmentsViewController *vc = [[AttachmentsViewController alloc] init];
    vc.atts = self.attachments;
    vc.title = @"查看附件";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showToolbarButtons:(NSString *)result
{
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [items addObject:space];
    for(NSString *title in [self.buttons allKeys]) {
        UIBarButtonItem *approve = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(taskProcess:)];
        [items addObject:approve];
        [items addObject:space];
    }
    [_toolbar setItems:items animated:YES];
}

- (void)requestOperations
{
    //获取操作按钮
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPTaskOperation]];
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
    NSString *loginUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserId];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:loginUserId forKey:@"userID"];
    [request setPostValue:@"r" forKey:@"process"];  //"r" : 返回操作按钮
    [request setPostValue:_taskId forKey:@"id"];
    [request setPostValue:auth forKey:kHRPXlesAuth];
    [request startSynchronous];
    
    
    NSError * error=[request error];
    if (!error)
    {
        self.buttons = [[request responseString] objectFromJSONString];
        [self performSelectorOnMainThread:@selector(showToolbarButtons:) withObject:nil waitUntilDone:YES];
    }
}

- (void)requestAttachments
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kHRPAttachmenRequest, self.appId]]];
    [request startSynchronous];
    
    NSError * error=[request error];
    if (!error)
    {
        self.attachments = [[request responseString] objectFromJSONString];
        [self performSelectorOnMainThread:@selector(showAttButton:) withObject:nil waitUntilDone:YES];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:YES];
}

- (void)loadWebView
{
    //获取详细页面
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/Workflow/TaskFormMobile.aspx?Task=%@&User=%@", ip, _taskId, [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginAccount]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webview.scalesPageToFit = YES;
    [_webview loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (progressBar == nil) {
        progressBar = [[MyProgressBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 4.0f)];
        [self.view addSubview:progressBar];
    }
    
    //启动多线程
    [self initGCD];
    [self loadWebView];
}

- (void)webView:(MyWebView *)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources
{
    [progressBar setProgress:((float)resourceNumber) / ((float)totalResources) animated:YES];
    if (resourceNumber == totalResources) {
        _webview.resourceCount = 0;
        _webview.resourceCompletedCount = 0;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webViewFinished = NO;
//    [Default showActivityIndicatorInView:self.view WithMessage:@""];
    [SVProgressHUD show];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webViewFinished = YES;
//    [Default hideActivityIndicatorInView:self.view];
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    webViewFinished = YES;
//    [Default hideActivityIndicatorInView:self.view];
    [SVProgressHUD dismiss];
    NSLog(@"failed load webview: %@", [error description]);
}

- (void)adduser
{
    if(searchViewController == nil) {
        searchViewController = [[SearchViewController alloc] initWithNibName:nil bundle:nil];
    }
    searchViewController.delegate = self;
    CATransition *animation = [AutoAnimation createAnimation];
    animation.type = @"kCATransitionMoveIn";
    animation.duration = 0.3f;
    [self.view addSubview:searchViewController.view];
    searchViewController.view.alpha = 0.8f;
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    searchViewController.view.frame = CGRectMake(10, 30, 300, 320);
    searchViewController.tableview.frame = CGRectMake(0, 89, 300, 225);
    searchViewController.searchbar.frame = CGRectMake(5, 45, 290, 44);
    [searchViewController viewWillAppear:YES];
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}

- (void)taskProcess:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    if([item.title isEqualToString:@"加签"]) {
//        [self adduser];
        [self showSelectUser];
        return;
    }
    
    //显示可编辑的弹出框
    [self showEditDialog:item.title];
    
    [[NSUserDefaults standardUserDefaults] setObject:item.title forKey:kHRPButtonKey];
    [self getButtonTagByTitle:item.title];
    
    
    /*
    textAlert = [[TextAlertView alloc] initWithTitle:@"Confirm"
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:@"Cancel", nil];
    [[NSUserDefaults standardUserDefaults] setObject:item.title forKey:kHRPButtonKey];
    [self getButtonTagByTitle:item.title];
    textAlert.btnEnabled = ![buttonClicked isEqualToString:@"re"];
    if([buttonClicked isEqualToString:@"xx"]) {
        textAlert.tag = 101;
        textAlert.textview.text = @"请登录网站进行重新提交的操作！";
        textAlert.textview.editable = NO;
    }
    [textAlert show];
     */
}

- (void)showSelectUser{
    alertViewMe = nil;
    
    alertViewMe = [[CXAlertView alloc] initWithTitle:@"加签" contentView:self.ShowSelectUserView cancelButtonTitle:@"取消"];
    alertViewMe.showButtonLine = NO;
    [alertViewMe show];
}

- (void)showEditDialog:(NSString *)title{
    editTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 220, 70)];
    editTextView.delegate = self;
    alertViewMe = nil;
    alertViewMe = [[CXAlertView alloc] initWithTitle:title contentView:editTextView cancelButtonTitle:@"取消"];
    __block TaskDetailViewController *blockSelf = self;
    [alertViewMe addButtonWithTitle:@"确定"
                               type:CXAlertViewButtonTypeDefault
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *buttonItem) {
                                NSLog(@"%@, %@", alertView.title, buttonItem.titleLabel.text);
//                                [alertViewMe dismiss];
                                [blockSelf->editTextView resignFirstResponder];
                                if ([title isEqualToString:@"拒绝"] && ([blockSelf->editTextView.text length]==0 || !blockSelf->editTextView)) {
                                    [SVProgressHUD showErrorWithStatus:@"请录入拒绝原因"];
                                    return ;
                                }
                                [blockSelf obtainApproval];
                            }];
    alertViewMe.showButtonLine = NO;
    [alertViewMe show];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 1 || alertView.tag == 101) {
//        return;
//    }
//    [self obtainApproval];
//}

- (void)obtainApproval{
    NSString *loginUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserId];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPTaskProcess]];
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
    
    NSLog(@"-----审批参数-----");
    NSLog(@"XLES_AUTH : %@", auth);
    NSLog(@"id : %@", _taskId);
    NSLog(@"userID : %@", loginUserId);
    NSLog(@"comment : %@", textAlert.textview.text);
    NSLog(@"code : %@", [self.buttons objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:kHRPButtonKey]]);
    NSLog(@"process : %@", buttonClicked);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:auth forKey:kHRPXlesAuth];
    [request setPostValue:_taskId forKey:@"id"];
    [request setPostValue:loginUserId forKey:@"userID"];
    [request setPostValue:textAlert.textview.text forKey:@"comment"];
    [request setPostValue:[self.buttons objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:kHRPButtonKey]] forKey:@"code"];
    [request setPostValue:buttonClicked forKey:@"process"];
    [request setDelegate:self];
    request.tag = 2;
    [request startAsynchronous];
    
    NSLog(@"%@, %@, %@, %@, %@, %@", _taskId, loginUserId, textAlert.textview.text, [self.buttons objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:kHRPButtonKey]], buttonClicked, auth);
}

- (void)dismissPopOver:(UIView *)popOver withDestUserId:(NSString *)destUserId
{
    [self obtainAddUser:destUserId];
}

- (void)obtainAddUser:(NSString *)destUserId{
    NSString *loginUserId = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserId];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPTaskProcess]];
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
    
    NSLog(@"-----加签参数-----");
    NSLog(@"XLES_AUTH : %@", auth);
    NSLog(@"id : %@", _taskId);
    NSLog(@"userID : %@", loginUserId);
    NSLog(@"destinationID : %@", destUserId);
    NSLog(@"process : ad");
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:auth forKey:kHRPXlesAuth];
    [request setPostValue:_taskId forKey:@"id"];
    [request setPostValue:loginUserId forKey:@"userID"];
    [request setPostValue:destUserId forKey:@"destinationID"];
    [request setPostValue:@"ad" forKey:@"process"];
    [request setDelegate:self];
    request.tag = 1;
    [request startAsynchronous];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)getButtonTagByTitle:(NSString *)title
{
    if([title isEqualToString:@"拒绝"]) {
        buttonClicked = @"re";
    }
    else if([title isEqualToString:@"加签"]) {
        buttonClicked = @"ad";
    }
    else if([title isEqualToString:@"撤销"]) {
        buttonClicked = @"fc";
    }
    else if([title isEqualToString:@"反馈"]) {
        buttonClicked = @"fb";
    }
    else if([title isEqualToString:@"重新提交"]) {
        buttonClicked = @"xx";
    }
    else {
        buttonClicked = @"eo";
    }
}

- (void)viewDidUnload
{
//    [self setWebview:nil];
//    [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)requestStarted:(ASIHTTPRequest *)request{
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD show];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed");
    NSString *info = [[request error] localizedDescription];
    [SVProgressHUD showErrorWithStatus:info];
    if (request.tag==1) {
        [alertViewMe dismiss];
    } else if (request.tag==2) {//除加签的操作请求
//        [alertViewMe dismiss];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    [SVProgressHUD showSuccessWithStatus:nil];
    NSLog(@"requestFinished");
    if (request.tag==1) {
        [alertViewMe dismiss];
        [self loadWebView];
    } else if (request.tag==2) {//除加签的操作请求
        [alertViewMe dismiss];
//        [self loadWebView];
        [self.navigationController popViewControllerAnimated:YES];
    } else if(request.tag == 3){//加签查询
        [self.searchBar resignFirstResponder];
        
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
        [self.showTableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
    NSLog(@"222222222222");
    
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPXlesAuth];
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:0];
    ip = kHRPServiceAddress;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPUserList]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:auth forKey:kHRPXlesAuth];
    [request setPostValue:searchBar.text forKey:@"name"];
    [request setDelegate:self];
    request.tag = 3;
    [request startAsynchronous];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *CellIndentifier = @"Cell";
//    UITableViewCell *cell;
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
//    }
//    cell.textLabel.text = @"Cell";
//    return cell;
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
//    if(indexPath.row == selectedIndex && selectedUserId) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.textLabel.textColor = [UIColor brownColor];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [alertViewMe dismiss];
    UITableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    selectedUserId = [userDictionary objectForKey:cell.textLabel.text];
    
    [alertViewMe dismiss];
//    [alertViewMe cleanAllPenddingAlert];
//    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:[NSString stringWithFormat:@"确定要加签用户%@吗？",[userArray objectAtIndex:indexPath.row]]
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"确定", nil];
//    [confirmAlert show];
    
    __block TaskDetailViewController *blockSelf = self;
    
    alertViewMe = [[CXAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"确定要加签用户%@吗？",[userArray objectAtIndex:indexPath.row]] cancelButtonTitle:nil];
    
   //alertViewMe = [[CXAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确定要加签用户%@吗？",[userArray objectAtIndex:indexPath.row]] contentView:nil cancelButtonTitle:nil];
    [alertViewMe addButtonWithTitle:@"取消"
                               type:CXAlertViewButtonTypeDefault
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *buttonItem) {
                                NSLog(@"%@, %@", alertView.title, buttonItem.titleLabel.text);
                                [alertView dismiss];
                                [blockSelf showSelectUser];
                                //                                [self obtainApproval];
                                //                                [alertView dismiss];
                                //                                [alertViewMe dismiss];
                                //                                [alertView cleanAllPenddingAlert];
                            }];
    [alertViewMe addButtonWithTitle:@"确定"
                               type:CXAlertViewButtonTypeDefault
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *buttonItem) {
                                NSLog(@"%@, %@", alertView.title, buttonItem.titleLabel.text);
                                //                                [alertView dismiss];
//                                [self obtainApproval];
//                                [alertView dismiss];
//                                [alertViewMe dismiss];
//                                [alertView cleanAllPenddingAlert];
                                
                                if ([blockSelf->userArray count]>0) {
                                    blockSelf.searchBar.text = nil;
                                    [blockSelf->userArray removeAllObjects];
                                    [blockSelf.showTableView reloadData];
                                }
                                
                                [blockSelf obtainAddUser:blockSelf->selectedUserId];
                            }];
    alertViewMe.showButtonLine = NO;
    [alertViewMe show];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [alertViewMe show];
    } else {
        [alertViewMe dismiss];
    }
}


#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
