//
//  MainNavigationController.m
//  yijiedai
//
//  Created by mdy1 on 15/1/29.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "MainNavigationController.h"
#import "APService.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"leaveTimeTmp"];
    //NotificationCenter
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - jpush delegate
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    //NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册");
    //NSLog(@"RegistrationID:%@",[[notification userInfo] valueForKey:@"RegistrationID"]);
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    if ([APService registrationID]) {
//        NSSet *tagSet = [NSSet setWithObjects:@"yijiedai",@"yijiedai_ios",@"yijiedai_product_ios",@"yijiedai_develop_ios", nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults] ;
        
        NSMutableDictionary *userDict =[NSMutableDictionary dictionaryWithDictionary:[userDefaults valueForKey:@"userInfo"]];
        
        NSString *jpushid = [APService registrationID];
        [userDict setObject:jpushid forKey:@"jpush_id"];
        [userDefaults setValue:userDict forKey:@"userInfo"];
    }
}
//收到自定义消息
- (void) networkDidReceiveMessage:(NSNotification *)notification{
    //自定义消息
    NSDictionary *userInfo = [notification userInfo];
    //取得推送内容
    NSString *content = [userInfo valueForKey:@"content"];
    NSLog(@"content:%@",content);
    //取得用户自定义参数
    NSString *extras = [userInfo valueForKey:@"extras"];
    NSLog(@"extras:%@",extras);
    //根据自定义key 取得 value
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"];
    NSLog(@"customizeField1:%@",customizeField1);
    
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

@end
