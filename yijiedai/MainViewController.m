//
//  MainViewController.m
//  yijiedai
//
//  Created by qijingyu on 15/1/29.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "MainViewController.h"
#import "GesturePasswordController.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "MemberModel.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize mainWebView;
@synthesize token;
@synthesize userid;
@synthesize username;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self loadingWebView];
    [self checkLoadPage];
    
    //open notificationCenter
    [self openNotificationCenter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self.view window] == nil){
        self.view = nil;
    }
}

//check load page
- (void) checkLoadPage{
    if([self isFirstLoad]){
        [self runIntroducePage];
    }else if ([self isLogin]){
        [self runGesturePasswordPage];
    }
}

//open notificationCenter
- (void)openNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationnDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)loadingWebView{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
    
    token = [keychinUserToken objectForKey:(__bridge id)kSecValueData];
    username = [keychinUserToken objectForKey:(__bridge id)kSecAttrAccount];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDict = [userDefaults objectForKey:@"userInfo"];
    userid = [userDict objectForKey:@"user_id"];
    
        NSString *resPath = [[NSBundle mainBundle] resourcePath];
        NSString* path = [resPath stringByAppendingPathComponent:@"web.bundle"];
        NSBundle *yijiedaiWebBundle = [NSBundle bundleWithPath:path];
        NSString *htmlPath = [yijiedaiWebBundle pathForResource:@"index" ofType:@"html"];
        NSURL *baseUrl = [NSURL fileURLWithPath:htmlPath];
    //NSURL *baseUrl = [NSURL URLWithString:@"http://m.yijiedai.org"];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:baseUrl]];
    
    NSString *jsString = [NSString stringWithFormat:@"window.js_app_user = {};window.js_app_user.token = '%@';window.js_app_user.username = '%@';window.js_app_user.userid = '%@';",token,username,userid];
    
    jsString = [NSString stringWithFormat:@"var script = document.createElement('script');script.type = 'text/javascript';script.text =\"%@\";document.getElementsByTagName('head')[0].appendChild(script);",jsString];
    [self.mainWebView stringByEvaluatingJavaScriptFromString:jsString];
    [self.mainWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"web" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
}


#pragma mark - login delegate
- (void) callLogin{
    NSLog(@"callLogin");
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];//获取请求的绝对路径.
    NSArray *components = [requestString componentsSeparatedByString:@":"];//提交请求时候分割参数的分隔符
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"iosapp"]) {
        //过滤请求是否是我们需要的.不需要的请求不进入条件
        NSLog(@"hello world");
        NSString *cmd = (NSString *)[components objectAtIndex:1];
        if([cmd isEqualToString:@"login"]){
            [self callCmdAction:WebActionModeLogin];
        }else if ([cmd isEqualToString:@"register"]){
            [self callCmdAction:WebActionModeRegister];
        }else if ([cmd isEqualToString:@"logout"]){
            [self callCmdAction:WebActionModeLogout];
        }else if ([cmd isEqualToString:@"real"]){
            [self callCmdAction:WebActionModeReal];
        }else if ([cmd isEqualToString:@"bank"]){
            [self callCmdAction:WebActionModeBank];
        }else if ([cmd isEqualToString:@"transword"]){
            [self callCmdAction:WebActionModeTransword];
        }else if ([cmd isEqualToString:@"gesture"]){
            [self callCmdAction:WebActionModeGesture];
        }
        return NO;
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.mainWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getMessageFromApp('%@')", @"加载结束调用方法"]];
}

- (void)callCmdAction:(WebActionMode)webActionMode{
    switch (webActionMode) {
        case WebActionModeLogin:
            NSLog(@"WebActionModeLogin");
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES];
            break;
        case WebActionModeLogout:
            NSLog(@"WebActionModeLogout");
            [MemberModel clearKeywordAndTimes];
            [MemberModel clearUserIdAndToken];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES];
            break;
        case WebActionModeRegister:
            NSLog(@"WebActionModeRegister");
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TelephoneViewController"] animated:YES];
            break;
        case WebActionModeReal:
            NSLog(@"WebActionModeReal");
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RealViewController"] animated:YES];
            break;
        case WebActionModeBank:
            NSLog(@"WebActionModeBank");
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"BankViewController"] animated:YES];
            break;
        case WebActionModeTransword:
            NSLog(@"WebActionModeTransword");
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PassViewController"] animated:YES];
            break;
        case WebActionModeGesture:
            NSLog(@"WebActionModeGesture");
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GesturePasswordController"] animated:YES];
            break;
        default:
            NSLog(@"no call");
            break;
    }
}


//- (IBAction)messageToHtml:(id)sender {
//    NSString *message = self.jsText.text;
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getMessageFromApp('%@')", message]];
//}
/*
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlstr = request.URL.absoluteString;
    NSRange range = [urlstr rangeOfString:@"ios://"];
    if (range.length!=0) {
        NSString *method = [urlstr substringFromIndex:(range.location+range.length)];
        SEL selctor = NSSelectorFromString(method);
        [self performSelector:selctor withObject:nil];
    }
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - introduce page
- (BOOL) runIntroducePage{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PageController"] animated:NO];
    return YES;
}

#define LAST_RUN_VERSION_KEY        @"last_run_version_of_application"
- (BOOL) isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        // App is being run for first time
        NSLog(@"App is being run for first time");
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
        
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        // App has been updated since last run
        NSLog(@"App has been updated since last run");
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    NSLog(@"App is not being run for first time");
    return NO;
}



#pragma mark - login page
- (BOOL) runLoginPage{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES];
    return YES;
}

- (BOOL) isLogin{
    token = [MemberModel getAccessToken];
    userid = [MemberModel getUserId];
    if ([userid isEqualToString:@""]||[token isEqualToString:@""]){
        return NO;
    }
    return YES;
}

#pragma mark - GesturePassword
- (BOOL) runGesturePasswordPage{
//    NSArray* controllers = self.navigationController.childViewControllers;
//    NSLog(@"controllers:%@",controllers);
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GesturePasswordController"] animated:NO];
//    [[[UIWindow alloc] window] makeKeyAndVisible];
    return YES;
}

#pragma mark - main page
- (BOOL) runMainPage{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"] animated:YES];
    return YES;
}

#pragma mark - NSNotificationCenter Listener
- (void) applicationWillResignActive{
    NSInteger leaveTime = [[NSDate date] timeIntervalSince1970];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%ld",(long)leaveTime] forKey:@"leaveTimeTmp"];
}

- (void) applicationnDidBecomeActive{
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *leaveTimeString = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"leaveTimeTmp"]];
    NSInteger leaveTime = [leaveTimeString intValue];
    if(leaveTime>0 && (nowTime - leaveTime)>60){
       [self checkLoadPage];
    }
}

@end
