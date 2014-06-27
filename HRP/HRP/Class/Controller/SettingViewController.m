//
//  SettingViewController.m
//  HRP
//
//  Created by shinsoft  on 12-8-24.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "SettingViewController.h"
#import "Default.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.field resignFirstResponder];
    [self restorePosition];
}

- (void)viewDidLoad
{
    self.param = [NSMutableDictionary dictionaryWithCapacity:6];
    [self.param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserId] forKey:@"SubmitterId"];
    [self.param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserId] forKey:@"ApplicantId"];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = done;

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Item 1" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Item 2" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"Item 3" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.toolbarItems = [NSArray arrayWithObjects:space, item1, item2, item3, nil];

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"datasource" ofType:@"json"];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:0 error:nil];
    self.title = [dataDic objectForKey:@"Title"];
    NSArray *specifiers = [dataDic objectForKey:@"Specifiers"];

    dataArray = [[NSMutableArray alloc] init];
    sectionHeader = [[NSMutableArray alloc] init];
    NSMutableArray *arr = nil;
    for(NSDictionary *dictionary in specifiers) {
        NSString *type = [dictionary objectForKey:@"Type"];
        NSString *title = [dictionary objectForKey:@"Title"];
        NSString *subTitle = [dictionary objectForKey:@"SubTitle"];
        NSString *controller = [dictionary objectForKey:@"ViewControllerClass"];
        NSString *selector = [dictionary objectForKey:@"ViewControllerSelector"];
        controller = controller == nil ? @"" : controller;
        selector = selector == nil ? @"" : selector;
        subTitle = subTitle == nil ? @"" : subTitle;
        if([type isEqualToString:@"GroupSpecifier"]) {
            [sectionHeader addObject:title];
            arr = [NSMutableArray array];
            [dataArray addObject:arr];
        }
        else {
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:type, title, subTitle, controller, selector, nil] forKeys:[NSArray arrayWithObjects:@"Type", @"Title", @"SubTitle", @"ViewControllerClass", @"ViewControllerSelector", nil]];
            [arr addObject:dic];
        }
    }
    
//    NSLog(@"%@", self.dataArray);
//    NSLog(@"%@", self.sectionHeader);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionHeader count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataArray objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionHeader objectAtIndex:section];
}

- (void)hideKeyboard:(id)sender
{
    [self.field resignFirstResponder];
    [self restorePosition];
}

- (void)nextField:(id)sender
{
    if(row == 5) {
        return;
    }
    if(row == 2) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        TextFieldTableCellView *cell = (TextFieldTableCellView *)[self.myTableView cellForRowAtIndexPath:indexPath];
        [cell.textfield becomeFirstResponder];
        return;
    }
    if(row == 4) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        TextFieldTableCellView *cell = (TextFieldTableCellView *)[self.myTableView cellForRowAtIndexPath:indexPath];
        [cell.textfield becomeFirstResponder];
        return;
    }
}

- (void)previousField:(id)sender
{
    if(row == 2)
        return;
    if(row == 5) {
        [self moveUp];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        TextFieldTableCellView *cell = (TextFieldTableCellView *)[self.myTableView cellForRowAtIndexPath:indexPath];
        [cell.textfield becomeFirstResponder];
        return;
    }
    if(row == 4) {
        [self moveUp];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        TextFieldTableCellView *cell = (TextFieldTableCellView *)[self.myTableView cellForRowAtIndexPath:indexPath];
        [cell.textfield becomeFirstResponder];
        return;
    }
}

- (void)submitRequest:(id)sender
{
//    @"SubmitterId", @"ApplicantId", @"Description", @"BudgetAccountId", @"Amount", @"Comment"
    if(![self.param objectForKey:@"ApplicantId"]) {
        NSLog(@"ApplicantId is null.;");
        return;
    }
    if(![self.param objectForKey:@"Description"]) {
        NSLog(@"Description is null.;");
        return;
    }
    if(![self.param objectForKey:@"BudgetAccountId"]) {
        NSLog(@"BudgetAccountId is null.;");
        return;
    }
    if(![self.param objectForKey:@"Amount"]) {
        NSLog(@"Amount is null.;");
        return;
    }

    NSString *json = [NSString string];
    json = [json stringByAppendingString:@"{"];
    for(int i=0; i<[self.param count]; i++) {
        json = [json stringByAppendingFormat:@"\"%@\"", [[self.param allKeys] objectAtIndex:i]];
        json = [json stringByAppendingString:@":"];
        json = [json stringByAppendingFormat:@"\"%@\"", [[self.param allValues] objectAtIndex:i]];
        if(i < [self.param count] - 1)
            json = [json stringByAppendingString:@","];
    }
    json = [json stringByAppendingString:@"}"];
    NSLog(@"%@", json);
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPServerIP];
    ip = [[ip componentsSeparatedByString:@"\n"] objectAtIndex:1];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", ip, kHRPRequestSubmit]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:json forKey:@"Parameters"];
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
    NSLog(@"%@", [request responseString]);
    [self.navigationController dismissModalViewControllerAnimated:YES];
    //    NSLog(@"%@", [request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Default hideActivityIndicatorInView:self.view];
    NSLog(@"%@", [request error]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"后一项" style:UIBarButtonItemStyleDone target:self action:@selector(nextField:)];
    UIBarButtonItem *previous = [[UIBarButtonItem alloc] initWithTitle:@"前一项" style:UIBarButtonItemStyleDone target:self action:@selector(previousField:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完 成" style:UIBarButtonItemStyleBordered target:self action:@selector(hideKeyboard:)];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = [NSArray arrayWithObjects:next, previous, space, done, nil];

    
    UITableViewCell *cell = nil;
    NSString *type = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Type"];
    NSString *title = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Title"];
    if([type isEqualToString:@"TextFieldSpecifier"]) {
        static NSString *CellIdentifier = @"TextFieldTableCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = (TextFieldTableCellView *) [[[NSBundle mainBundle] loadNibNamed:@"TextFieldTableCellView" owner:self options:nil] objectAtIndex:0];
            ((TextFieldTableCellView *)cell).label.text = title;
            ((TextFieldTableCellView *)cell).textfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:title];
            ((TextFieldTableCellView *)cell).textfield.textColor = [UIColor brownColor];
        }
        if(indexPath.row == 0) {
            ((TextFieldTableCellView *)cell).textfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserName];
            ((TextFieldTableCellView *)cell).textfield.enabled = NO;
        }
        if(indexPath.row != 5) {
            ((TextFieldTableCellView *)cell).textfield.placeholder = @"必须填写";
        }
        ((TextFieldTableCellView *)cell).textfield.inputAccessoryView = toolBar;
    }
    if([type isEqualToString:@"ToggleSpecifier"]) {
        static NSString *CellIdentifier = @"ToggleTableCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = (ToggleTableCellView *) [[[NSBundle mainBundle] loadNibNamed:@"ToggleTableCellView" owner:self options:nil] objectAtIndex:0];
            ((ToggleTableCellView *)cell).label.text = title;
            ((ToggleTableCellView *)cell).toggle.on = [[[NSUserDefaults standardUserDefaults]objectForKey:title] boolValue];
            [((ToggleTableCellView *)cell).toggle addTarget:self action:@selector(toggleValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    if([type isEqualToString:@"SliderSpecifier"]) {
        static NSString *CellIdentifier = @"SliderTableCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = (SliderTableCellView *) [[[NSBundle mainBundle] loadNibNamed:@"SliderTableCellView" owner:self options:nil] objectAtIndex:0];
            ((SliderTableCellView *)cell).slider.value = [[[NSUserDefaults standardUserDefaults] objectForKey:title] floatValue];
            ((SliderTableCellView *)cell).label.text = title;
            [((SliderTableCellView *)cell).slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    if([type isEqualToString:@"ButtonSpecifier"])  {
        static NSString *CellIdentifier = @"CellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NVUIGradientButton *button = [[NVUIGradientButton alloc] initWithFrame:CGRectMake(10, 0, 300, 44) style:NVUIGradientButtonStyleDefault cornerRadius:5.0 borderWidth:1.0 andText:@"提 交"];
            [button addTarget:self action:@selector(submitRequest:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([type isEqualToString:@"MultiValueSpecifier"]) {
        static NSString *CellIdentifier = @"TextFieldTableCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = (TextFieldTableCellView *) [[[NSBundle mainBundle] loadNibNamed:@"TextFieldTableCellView" owner:self options:nil] objectAtIndex:0];
            ((TextFieldTableCellView *)cell).label.text = title;
            ((TextFieldTableCellView *)cell).textfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:title];
            ((TextFieldTableCellView *)cell).textfield.textColor = [UIColor brownColor];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        if(indexPath.row == 1) {
            ((TextFieldTableCellView *)cell).textfield.enabled = NO;
            ((TextFieldTableCellView *)cell).textfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:kHRPLoginUserName];
        }
        if(indexPath.row == 3) {
            ((TextFieldTableCellView *)cell).textfield.enabled = NO;
            ((TextFieldTableCellView *)cell).textfield.placeholder = @"必须填写";
        }
        ((TextFieldTableCellView *)cell).textfield.inputAccessoryView = toolBar;
    }
    if([type isEqualToString:@"CustomViewSpecifier"]) {
        static NSString *CellIdentifier = @"CellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.text = title;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self.field resignFirstResponder];
    row = indexPath.row;
    TextFieldTableCellView *cell = (TextFieldTableCellView *)[tableView cellForRowAtIndexPath:indexPath];
    self.field = cell.textfield;
    if(indexPath.row == 1) {
        NameViewController *vc = [[NameViewController alloc] initWithNibName:nil bundle:nil];
        vc.delegate = self;
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = temp;
        vc.title = @"用户查询";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.row == 3) {
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
        detail.delegate = self;
        detail.type = 1;
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = temp;
        detail.title = @"费用类型";
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Type"];
    UITableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if([type isEqualToString:@"TextFieldSpecifier"]) {
        [((TextFieldTableCellView *)cell).textfield becomeFirstResponder];
    }
    if([type isEqualToString:@"SliderSpecifier"]) {
        NSLog(@"%@", cell);
    }
    if([type isEqualToString:@"ToggleSpecifier"]) {
        NSLog(@"%@", cell);
    }
    if([type isEqualToString:@"ButtonSpecifier"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"button clicked..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    if([type isEqualToString:@"CustomViewSpecifier"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor brownColor];
            return;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
        
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        UserViewController *uservc = [[UserViewController alloc] initWithNibName:nil bundle:nil];
        [self presentModalViewController:uservc animated:YES];
    }
}

- (void)showSelectedItem:(NSString *)name Code:(NSString *)code
{
    self.field.text = name;
    if(row == 1) {
        [self.param setObject:code forKey:@"ApplicantId"];
    }
    if(row == 3) {
        [self.param setObject:code forKey:@"BudgetAccountId"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.field = textField;
    row = [self.myTableView indexPathForCell:(UITableViewCell *)[[textField superview] superview]].row;
    if(row == 1) {
        [self.param removeObjectForKey:@"ApplicantId"];
    }
    
    [UIView beginAnimations:@"nil" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    UIView *cell = [[textField superview] superview];
    CGRect rect = self.view.frame;
    CGRect selectRect = [self.myTableView convertRect:cell.frame toView:nil];
    float ofs = selectRect.origin.y + 216 - [UIScreen mainScreen].bounds.size.height + 48 + 90;
    if(ofs > 0 && (self.view.frame.origin.y - ofs + self.view.frame.size.height + 216 > 436)) {
        rect.origin.y -= ofs;
    }
    if(ofs > 0 && (self.view.frame.origin.y - ofs + self.view.frame.size.height + 216 < 436)) {
        rect.origin.y = 480 - self.view.frame.size.height - 280;
    }
    self.view.frame = rect;
    [self.myTableView scrollRectToVisible:cell.frame animated:YES];
    
    [UIView commitAnimations];
}

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TextFieldTableCellView *cell = (TextFieldTableCellView *)[[textField superview] superview];
    row = [self.myTableView indexPathForCell:cell].row;
    NSArray *keys = [NSArray arrayWithObjects:@"SubmitterId", @"ApplicantId", @"Description", @"BudgetAccountId", @"Amount", @"Comment", nil];
    if(row == 2 || row == 5) {
        [self.param setObject:textField.text forKey:[keys objectAtIndex:row]];
    }
    if(row == 4) {
        NSString *regex = @"([1-9]\\d*(\\.\\d{1,2})?|0\\.[1-9]\\d?|0\\.0[1-9]|0|0.0)$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:textField.text];
        if(!isMatch) {
            cell.textfield.text = @"请输入有效数字！";
            cell.textfield.textColor = [UIColor redColor];
            return;
        }
        else {
            cell.textfield.textColor = [UIColor blackColor];
        }
        [self.param setObject:textField.text forKey:[keys objectAtIndex:row]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    TextFieldTableCellView *cell = (TextFieldTableCellView *)[[textField superview] superview];
    //    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:cell.label.text];
    [textField resignFirstResponder];
    [self restorePosition];
    return YES;
}

- (void)moveUp
{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.5f];
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y + 36;
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)restorePosition
{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.2f];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)toggleValueChanged:(id)sender
{
    UISwitch *toggle = (UISwitch *)sender;
    ToggleTableCellView *cell = (ToggleTableCellView *)[[toggle superview] superview];
    [[NSUserDefaults standardUserDefaults] setBool:toggle.isOn forKey:cell.label.text];
}

- (void)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    SliderTableCellView *cell = (SliderTableCellView *)[[slider superview] superview];
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:cell.label.text];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
