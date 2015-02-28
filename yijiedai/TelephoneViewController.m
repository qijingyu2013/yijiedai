//
//  TelephoneViewController.m
//  yijiedai
//
//  Created by qijingyu on 15/1/26.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "TelephoneViewController.h"
#import "TeleCodeViewController.h"

@interface TelephoneViewController ()

@end

@implementation TelephoneViewController

@synthesize navigateBar;
@synthesize selectedButton;
@synthesize telephoneTextField;
@synthesize sendTelephoneButton;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    selectedButton.selected=YES;
    telephoneTextField.delegate = self;
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

#pragma mark - selected box
- (IBAction)selectedButton:(id)sender {
    BOOL ndl = selectedButton.selected;
    if(ndl){
        [selectedButton setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateSelected];
        selectedButton.selected = NO;
    }else{
        [selectedButton setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
        selectedButton.selected = YES;
    }
    NSLog(@"%@",ndl?@"yes":@"no");
}

#pragma mark - transfer button
// go home
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//send msm and go to next page
- (IBAction)sendTelephoneButton:(id)sender {
    if([self validateMobile:telephoneTextField.text]){
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.delegate = self;
        hud.opacity = 0.4f;
        hud.yOffset = -120;
        [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
        
        
        if(secondsCountDown >0 ){
            hud.labelText = [NSString stringWithFormat:@"%d秒后可以重发",secondsCountDown];
        }else{
            [sendTelephoneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            TeleCodeViewController *teleCodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeleCodeViewController"];
            secondsCountDown = 15;//30;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:teleCodeViewController selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            //纯文字提示弹出框
            [self sendTelephoneToServer:telephoneTextField.text];
        }
    }else{
        [CommUtil shakeTextField:telephoneTextField];
        //带滚动图标的弹出框
        /*
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.delegate = self;
        hud.labelText = @"你的手机号码会不会是填错了呢?";
        [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
        */
    }
}


- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void) myProgress{
    sleep(120);
}

#pragma mark - login action
- (void) sendTelephoneToServer:(NSString*)telephone{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:telephone forKey:@"telephoneTmp"];
    
//    //teleCodeViewController.telephone = ;
//    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TeleCodeViewController"] animated:YES];
//    return;
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:hud];
//    hud.delegate = self;
//    hud.opacity = 0.4f;
//    hud.yOffset = -120;
    
    //存放返回json数据
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"reg/step/1"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    [requestForm setPostValue:telephone forKey:@"phonenumber"];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    
    [requestForm setCompletionBlock:^{
        
        NSString *reqString = [requestForm responseString];
        NSLog(@"response:%@",reqString);
        
        NSData *data = requestForm.responseData;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *status = [resultJSON objectForKey:@"state"];
        if([status isEqualToString:@"1"]){
            //成功
            [hud hide:YES];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TeleCodeViewController"] animated:YES];
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
    [telephoneTextField resignFirstResponder];
}
@end
