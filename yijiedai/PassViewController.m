//
//  PassViewController.m
//  yijiedai
//
//  Created by Mr.Q on 15/2/3.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "PassViewController.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"

@interface PassViewController ()

@end

@implementation PassViewController

@synthesize passwordTextField;
@synthesize rePasswordTextField;
@synthesize token;
@synthesize userid;
@synthesize username;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rePasswordTextField.delegate = self;
    passwordTextField.delegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDict = [userDefaults objectForKey:@"userInfo"];
    userid = [userDict objectForKey:@"user_id"];
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)breakButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)sendPassAction:(id)sender {
    BOOL ndl = YES;
    if(ndl){
        ndl = NO;
        //NSInteger passwordNum = [CommUtil unicodeLengthOfString:passwordTextField.text];
        if(passwordTextField.text.length<6){
            [CommUtil shakeTextField:passwordTextField];
        }else if(passwordTextField.text.length>16){
            [CommUtil shakeTextField:passwordTextField];
        }else if([CommUtil isIncludeSpecialCharact:passwordTextField.text]){
            [CommUtil shakeTextField:passwordTextField];
        }else{
            ndl = YES;
        }
    }
    
    if(ndl){
        ndl = NO;
        if([passwordTextField.text isEqualToString:rePasswordTextField.text]){
            ndl = YES;
        }else{
            [CommUtil shakeTextField:rePasswordTextField];
        }
    }
    
    if(ndl){
        KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
        self.token = [keychinUserToken objectForKey:(__bridge id)kSecValueData];
        [self sendTransPassToServiceWithToken:self.token WithUserid:userid WithPassword:passwordTextField.text  WithConfirm:rePasswordTextField.text];
    }
}

#pragma mark - action
- (void) sendTransPassToServiceWithToken:(NSString*)accessToken WithUserid:(NSString*)userId WithPassword:(NSString*)password WithConfirm:(NSString*)repassword{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    //密码
    NSString *newpassword =[CommUtil string2Md5:password];
    //确认
    NSString *newrePassword = [CommUtil string2Md5:repassword];
    //存放返回json数据
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"safe/pay/password/add"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:newpassword forKey:@"password"];
    [requestForm setPostValue:newrePassword forKey:@"pwdconfirm"];
    [requestForm setPostValue:accessToken forKey:@"access_token"];
    [requestForm setPostValue:userId forKey:@"user_id"];
    
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    
    [requestForm setCompletionBlock:^{
        NSData *data = [requestForm responseData];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString* statusCode = (NSString*)[resultJSON objectForKey:@"state"];
        if([statusCode isEqualToString:@"1"]){
            //成功
            [hud hide:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{//失败
            hud.labelText = [NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"message"]];
            sleep(2);
            [hud hide:YES];
        }
    }];
    
    [requestForm setFailedBlock:^{
        hud.labelText = @"网络连接出错";
        sleep(2);
        [hud hide:YES];
    }];
    
    [requestForm startAsynchronous];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [rePasswordTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void) myProgress{
    sleep(120);
}
@end
