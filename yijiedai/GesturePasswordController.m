//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by qijingyu on 2015-01-26.
//  Copyright (c) 2015年 qijingyu. All rights reserved.
//

//#import <Security/Security.h>
//#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"
#import "ASIFormDataRequest.h"
#import "MemberModel.h"
#import "CommUtil.h"

@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSInteger inputTimes;
}

@synthesize gesturePasswordView;

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
    // Do any additional setup after loading the view.
    previousString = [NSString string];
    password = [MemberModel getKeyword];
    inputTimes = [MemberModel getKeywordTimes];
    
    if([MemberModel isLogin]){
        if([self exist]){
            [self verify];
        }else{
            [self clear];
            [self reset];
        }
    }else{
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]  animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self.view window] == nil){
        self.view = nil;
    }
}


#pragma mark - 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
    [gesturePasswordView.state setText:@"绘制手势密码"];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
    [gesturePasswordView.state setText:@"绘制新的手势密码"];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    password = [MemberModel getKeyword];
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    [MemberModel clearKeywordAndTimes];
}

#pragma mark - 忘记手势密码
- (void)forget{
    NSString* username = [MemberModel getUsername];
    NSString* newUsername = [CommUtil spliteOfStringSpec:username];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入登录密码"
                                                    message:newUsername
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = 11;
    [alert show];
}

#pragma mark - 使用其他账号登入
- (void)change{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"为了您的账户安全,我们将会清除您在本机的账户记录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = 12;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 11://修改手势密码
            if(buttonIndex == 1){
                //取得 账号 和密码 发送到api
                UITextField *passwordTextField = [alertView textFieldAtIndex:0];
                NSInteger passwordNum = passwordTextField.text.length;
                if(passwordNum<6||passwordNum>16){
                    [self forget];
                }else if([CommUtil isIncludeSpecialCharact:passwordTextField.text]){
                    [self forget];
                }else{
                    [self sendLoginInfoToServer:[MemberModel getUsername] WithPassword:passwordTextField.text];
                }
            }
            break;
        case 12://使用其他账号登入
            if(buttonIndex == 1){
                
                //清除手势密码
                [self clear];
                [self reset];
                [MemberModel clearUserIdAndToken];
                [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES];
                
            }
            break;
        default:
            break;
    }
}

- (BOOL)verification:(NSString *)result{
    inputTimes--;
    if(inputTimes<=0){
        [gesturePasswordView.tentacleView enterArgin];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"] animated:YES];
        return NO;
    }else{
        if ([result isEqualToString:password]) {
            [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
            [gesturePasswordView.state setText:@"输入正确"];
            inputTimes=5;
            [MemberModel setKeywordTimes:inputTimes];
            [self fastLoginToServer];
            [self verify];
            return YES;
        }else{
            [MemberModel setKeywordTimes:inputTimes];
            password = [MemberModel getKeyword];
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:165/255.f green:1/255.f blue:1/255.f alpha:1]];
            NSString *string = [NSString stringWithFormat:@"手势密码错误,还可以输入%ld次",(long)inputTimes];
            [gesturePasswordView.state setText:string];
            [gesturePasswordView.tentacleView enterArgin];
            return NO;
        }
    }
}

- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
        [gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    } else {
        if ([result isEqualToString:previousString]) {
            [MemberModel setKeyword:result];
            [MemberModel setKeywordTimes:5];
            [gesturePasswordView.state setTextColor:[UIColor whiteColor]];
            [gesturePasswordView.state setText:@"已保存手势密码"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return YES;
        }else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:165/255.f green:1/255.f blue:1/255.f alpha:1]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
    }
}

#pragma mark - login action
- (void) fastLoginToServer{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    //id
    NSString *userid = [MemberModel getUserId];
    //token
    NSString *token = [MemberModel getAccessToken];
    //存放返回json数据
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"login/shortcut"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:userid forKey:@"user_id"];
    [requestForm setPostValue:token forKey:@"access_token"];
    
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    
    [requestForm setCompletionBlock:^{
        NSData *data = [requestForm responseData];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *resultData = [resultJSON objectForKey:@"data"];
        NSString* statusCode = (NSString*)[resultJSON objectForKey:@"state"];
        if([statusCode isEqualToString:@"1"]){
            //成功
            //存储用户信息
            if([MemberModel saveWithDict:resultData]){
                [hud hide:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
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

-(void) myProgress{
    sleep(120);
}
#pragma mark - login action
- (void) sendLoginInfoToServer:(NSString*)username WithPassword:(NSString*)passwd{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    //密码
    NSString *newpassword =[CommUtil string2Md5:passwd];
    //设备号
    NSString *device_no = [MemberModel getDeviceno];
    
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
        //        int statusInt = [status intValue];
        if([statusCode isEqualToString:@"1"]){
            if([MemberModel saveWithDict:resultData]){
                [hud hide:YES];
                [self clear];
                [self reset];
            }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
