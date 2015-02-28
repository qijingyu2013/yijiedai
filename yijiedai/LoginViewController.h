//
//  LoginViewController.h
//  yijiedai
//
//  Created by mdy1 on 15/1/21.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommUtil.h"
#import "ASIFormDataRequest.h"

@interface LoginViewController : UIViewController <MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;//CKTextField
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) MBProgressHUD *hud;


- (IBAction)touchToRegisterPage:(id)sender;
- (IBAction)loginButton:(id)sender;
//- (IBAction)usernameEditBegin:(id)sender;
- (IBAction)backButtonAction:(id)sender;

- (void) sendLoginInfoToServer:(NSString*)username WithPassword:(NSString*)password;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end


