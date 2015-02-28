//
//  TeleCodeViewController.m
//  yijiedai
//
//  Created by mdy1 on 15/1/28.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "TeleCodeViewController.h"
#import "TelephoneViewController.h"
#import "CommUtil.h"

@interface TeleCodeViewController ()

@end

@implementation TeleCodeViewController

@synthesize codeAgainButton;
@synthesize codeTextField;
@synthesize messageLabel;
@synthesize telephone=_telephone;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.telephone = [userDefaults objectForKey:@"telephoneTmp"];
    messageLabel.text = [NSString stringWithFormat:@"验证码短信已发送至%@",[CommUtil spliteOfStringSpec:self.telephone WithHead:3 WithFoot:4]];
    codeTextField.delegate = self;
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

- (IBAction)sendCodeAndGotoNextView:(id)sender {
    //check code =! 6
    if([codeTextField.text length]!=6){
        [CommUtil shakeTextField:codeTextField];
    }else{
        [self sendCheckCodeAction:self.telephone WithCode:codeTextField.text];
    }
}

- (IBAction)getCodeAgain:(id)sender {
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    if(secondsCountDown >0 ){
        hud.labelText = [NSString stringWithFormat:@"%d秒后可以重发",secondsCountDown];
        
    }else{
        //存放返回json数据
        NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"reg/step/1"]];
        __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
        
        [requestForm setPostValue:self.telephone forKey:@"phonenumber"];
        
        [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [requestForm addRequestHeader:@"Accept" value:@"application/json"];
        [requestForm setRequestMethod:@"POST"];
        [requestForm setTimeOutSeconds:60];
        
        [requestForm setCompletionBlock:^{     
            NSData *data = requestForm.responseData;
            NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *status = [resultJSON objectForKey:@"state"];
            if([status isEqualToString:@"1"]){
                //成功
                //hud.labelText=@"";
                secondsCountDown = 15;//30;
                countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                [hud hide:YES];
            }else{//失败
                //hud.labelText = @"你的手机号码会不会是填错了呢?";
                hud.labelText = [NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"message"]];
                sleep(2);
                [hud hide:YES];
                //[hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
            }
        }];
        
        [requestForm setFailedBlock:^{
            hud.labelText = @"网络连接出错";
            sleep(2);
            [hud hide:YES];
            //[hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
        }];
        
        [requestForm startAsynchronous];
        
        //纯文字提示弹出框
//        TelephoneViewController *telephoneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TelephoneViewController"];
    }
    
}

- (void)timeFireMethod{
    secondsCountDown--;
    if(secondsCountDown<=0){
        codeAgainButton.enabled = YES;
        codeAgainButton.titleLabel.text = @"重新获取";
        [codeAgainButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        [codeAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        TelephoneViewController *telephoneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TelephoneViewController"];
        [telephoneViewController.sendTelephoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [countDownTimer invalidate];
    }else{
        codeAgainButton.enabled = NO;
        [codeAgainButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        codeAgainButton.titleLabel.text = [NSString stringWithFormat:@"%d秒后可以重发",secondsCountDown];
        [codeAgainButton setTitle:[NSString stringWithFormat:@"%d秒后可以重发",secondsCountDown] forState:UIControlStateDisabled];
    }
}

-(void) myProgress{
    sleep(2);
}

- (void) sendCheckCodeAction:(NSString*)telephone WithCode:(NSString*) teleCode{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"reg/step/2"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:telephone forKey:@"phonenumber"];
    [requestForm setPostValue:teleCode forKey:@"code"];
    
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    
    [requestForm setCompletionBlock:^{
        NSLog(@"req:%@",[requestForm responseString]);
        
        NSData *data = [requestForm responseData];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString* statusCode = (NSString*)[resultJSON objectForKey:@"state"];
        if([statusCode isEqualToString:@"1"]){
            //成功
            [hud hide:YES];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"] animated:YES];
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
    [codeTextField resignFirstResponder];
}
@end
