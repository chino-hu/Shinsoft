//
//  MyWebView.h
//  HRP
//
//  Created by shinsoft  on 12-9-3.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyWebView;

@protocol MyWebViewProgressDelegate <NSObject>
@optional
- (void) webView:(MyWebView*)webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources;
@end

@interface MyWebView : UIWebView

@property (nonatomic, assign) int resourceCount;
@property (nonatomic, assign) int resourceCompletedCount;
@property (nonatomic, assign) IBOutlet id<MyWebViewProgressDelegate> progressDelegate;

@end

