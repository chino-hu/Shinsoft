//
//  WebViewController.h
//  仁济财务平台
//
//  Created by Chino Hu on 13-9-23.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface WebViewController : UIViewController <ASIHTTPRequestDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *web;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *fileName;

@end
