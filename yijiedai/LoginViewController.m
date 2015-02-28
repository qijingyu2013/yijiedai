//
//  LoginViewController.m
//  yijiedai
//
//  Created by mdy1 on 15/1/21.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "LoginViewController.h"
#import "MainNavigationController.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "APService.h"
#import "MemberModel.h"


@implementation LoginViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    usernameTextField.delegate = self;
    passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self.view window] == nil){
        self.view = nil;
    }
}

- (IBAction)touchToRegisterPage:(id)sender {
    
}


- (IBAction)loginButton:(id)sender {
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
        if(passwordNum<2||passwordNum>30){
            [CommUtil shakeTextField:passwordTextField];
//            [passwordTextField shake];
        }else if([CommUtil isIncludeSpecialCharact:passwordTextField.text]){
            [CommUtil shakeTextField:passwordTextField];
//            [passwordTextField shake];
        }else{
            ndl = YES;
        }
    }
    
    if(ndl){
        //跳转到main
        [self sendLoginInfoToServer:usernameTextField.text WithPassword:passwordTextField.text];
    }
    
}

//- (IBAction)usernameEditBegin:(id)sender {
//    UITextField *textField = (UITextField *)sender;
//    if(!textField.window.isKeyWindow){
//        [textField.window makeKeyAndVisible];
//    }
//}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - login action
- (void) sendLoginInfoToServer:(NSString*)username WithPassword:(NSString*)password{
    
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
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"login"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:username forKey:@"username"];
    [requestForm setPostValue:newpassword forKey:@"password"];
    [requestForm setPostValue:device_no forKey:@"device_no"];
    [requestForm setPostValue:@"ios" forKey:@"mobile_type"];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    [requestForm setCompletionBlock:^{
        NSLog(@"request:%@",[requestForm responseString]);
        NSData *data = [requestForm responseData];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultData = [resultJSON objectForKey:@"data"];
        NSString* statusCode = (NSString*)[resultJSON objectForKey:@"state"];
        if([statusCode isEqualToString:@"1"]){
            if([MemberModel saveWithDict:resultData]){
                [hud hide:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    if(!textField.window.isKeyWindow){
        [textField.window makeKeyAndVisible];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}
@end
