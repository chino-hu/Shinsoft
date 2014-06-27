//
//  WebViewController.m
//  仁济财务平台
//
//  Created by Chino Hu on 13-9-23.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController ()

@end

@implementation WebViewController

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
    

    NSLog(@"%@", self.url);
//    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.fileName];
    NSLog(@"%@", path);
    
    NSURL *url = [NSURL URLWithString:self.url];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setDelegate:self];
    [request setDownloadDestinationPath :path];
    [request startAsynchronous];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.fileName];
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWeb:nil];
    [super viewDidUnload];
}
@end
