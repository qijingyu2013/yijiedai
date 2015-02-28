//
//  RegisterViewController.m
//  yijiedai
//
//  Created by Mr.Q on 15/2/2.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "RegisterViewController.h"
#import "TeleCodeViewController.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "APService.h"
#import "MemberModel.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize rePasswordTextField;
@synthesize telephone;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    telephone = [userDefaults objectForKey:@"telephoneTmp"];
    usernameTextField.delegate = self;
    passwordTextField.delegate = self;
    rePasswordTextField.delegate = self;
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

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButton:(id)sender {
    BOOL ndl = NO;
    NSInteger usernameNum = [CommUtil unicodeLengthOfString:usernameTextField.text];
    if(usernameNum<2||usernameNum>30){
        [CommUtil shakeTextField:usernameTextField];
        //        [usernameTextField shake];
    }else if([CommUtil isIncludeSpecialCharact:usernameTextField.text]){
        [CommUtil shakeTextField:usernameTextField];
    }else{
        ndl = YES;
    }
    
    if(ndl){
        ndl = NO;
        NSInteger passwordNum = [CommUtil unicodeLengthOfString:passwordTextField.text];
        if(passwordNum<3){
            [CommUtil shakeTextField:passwordTextField];
        }else if(passwordNum>8){
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
        //跳转到main
        [self sendRegisterInfoToServer:usernameTextField.text WithPassword:passwordTextField.text];
    }
}

#pragma mark - register action
- (void) sendRegisterInfoToServer:(NSString*)username WithPassword:(NSString*)password{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    //密码
    NSString *newpassword =[CommUtil string2Md5:password];
    //设备号
    NSString *device_no = [APService registrationID];
    if([device_no isEqualToString:@""])[CommUtil getUUID];
    //存放返回json数据
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"reg/step/3"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:username forKey:@"nickname"];
    [requestForm setPostValue:newpassword forKey:@"password"];
    [requestForm setPostValue:telephone forKey:@"phonenumber"];
    [requestForm setPostValue:device_no forKey:@"device_no"];
    [requestForm setPostValue:@"ios" forKey:@"mobile_type"];
    
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    
    [requestForm setCompletionBlock:^{
        NSString *req = [requestForm responseString];
        NSLog(@"req:%@",req);
        
        NSData *data = [requestForm responseData];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultData = [resultJSON objectForKey:@"data"];
        NSString* statusCode = (NSString*)[resultJSON objectForKey:@"state"];
        if([statusCode isEqualToString:@"1"]){
            //成功
            if([MemberModel saveWithDict:resultData]){
                [hud hide:YES];
                [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RealViewController"] animated:YES];
            }
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

-(void) myProgress{
    sleep(120);
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [rePasswordTextField resignFirstResponder];
}
@end
