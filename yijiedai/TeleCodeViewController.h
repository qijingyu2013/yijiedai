//
//  TeleCodeViewController.h
//  yijiedai
//
//  Created by mdy1 on 15/1/28.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"

int secondsCountDown;
NSString *telephoneTmp;
NSTimer *countDownTimer;

@interface TeleCodeViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeAgainButton;
@property (weak, nonatomic) NSString *telephone;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (retain, nonatomic) MBProgressHUD *hud;

- (IBAction)backButton:(id)sender;
- (IBAction)sendCodeAndGotoNextView:(id)sender;
- (IBAction)getCodeAgain:(id)sender;

- (void) sendCheckCodeAction:(NSString*)telephone WithCode:(NSString*) teleCode;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) myProgress;
- (void)timeFireMethod;
@end
