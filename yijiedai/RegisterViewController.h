//
//  RegisterViewController.h
//  yijiedai
//
//  Created by Mr.Q on 15/2/2.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommUtil.h"
#import "ASIFormDataRequest.h"

@interface RegisterViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) NSString *telephone;
@property (retain, nonatomic) MBProgressHUD *hud;

- (IBAction)backButton:(id)sender;
- (IBAction)registerButton:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) myProgress;
@end
