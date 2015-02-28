//
//  RealViewController.m
//  yijiedai
//
//  Created by Mr.Q on 15/2/3.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "RealViewController.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"

@interface RealViewController ()

@end

@implementation RealViewController

@synthesize realNameTextField;
@synthesize idCardTextField;
@synthesize token;
@synthesize userid;
@synthesize username;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    realNameTextField.delegate = self;
    idCardTextField.delegate = self;
    
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

- (IBAction)sendRealInfoAction:(id)sender {
    BOOL ndl = NO;
    NSInteger usernameNum = [CommUtil unicodeLengthOfString:realNameTextField.text];
    if(usernameNum<1||usernameNum>30){
        [CommUtil shakeTextField:realNameTextField];
    }else if([CommUtil isIncludeSpecialCharact:realNameTextField.text]){
        [CommUtil shakeTextField:realNameTextField];
    }else{
        ndl = YES;
    }
    
    if(ndl){
        ndl = [self checkIdentityCardNo:idCardTextField.text];
        if(!ndl){
            [CommUtil shakeTextField:idCardTextField];
        }
    }
    
    if(ndl){
        KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
        self.token = [keychinUserToken objectForKey:(__bridge id)kSecValueData];
        [self sendRealInfoToServerWithToken:self.token WithUserid:self.userid WithRealname:realNameTextField.text WithIdcard:idCardTextField.text];
    }
}

#pragma mark - action
- (void)sendRealInfoToServerWithToken:(NSString*)accessToken WithUserid:(NSString*)userId WithRealname:(NSString*)realname WithIdcard:(NSString*)idcard{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"safe/auth"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:realname forKey:@"idname"];
    [requestForm setPostValue:idcard forKey:@"idcard"];
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
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"BankViewController"] animated:YES];
        }else{//失败
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"message"]];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
        }
    }];
    
    [requestForm setFailedBlock:^{
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络连接出错";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    }];
    
    [requestForm startAsynchronous];
}

- (void) myProgress{
    sleep(120);
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [realNameTextField resignFirstResponder];
    [idCardTextField resignFirstResponder];
}

#pragma mark - 身份证识别
- (BOOL)checkIdentityCardNo:(NSString*)cardNo{
    BOOL flag;
    if (cardNo.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:cardNo];
}
@end
