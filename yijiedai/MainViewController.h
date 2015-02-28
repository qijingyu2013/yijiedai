//
//  MainViewController.h
//  yijiedai
//
//  Created by qijingyu on 15/1/29.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WebActionMode) {
    WebActionModeLogin,
    WebActionModeLogout,
    WebActionModeRegister,
    WebActionModePush,
    WebActionModeReal,
    WebActionModeBank,
    WebActionModeTransword,
    WebActionModeGesture
};

@interface MainViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (weak, nonatomic) NSString *token;
@property (weak, nonatomic) NSString *userid;
@property (weak, nonatomic) NSString *username;
- (void) callLogin;
//+ (NSString*)w
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end