//
//  PassViewController.h
//  yijiedai
//
//  Created by Mr.Q on 15/2/3.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommUtil.h"
#import "ASIFormDataRequest.h"

@interface PassViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) NSString *token;
@property (weak, nonatomic) NSString *userid;
@property (weak, nonatomic) NSString *username;
@property (retain, nonatomic) MBProgressHUD *hud;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)breakButtonAction:(id)sender;
- (IBAction)sendPassAction:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) myProgress;
- (void) sendTransPassToServiceWithToken:(NSString*)accessToken WithUserid:(NSString*)userId WithPassword:(NSString*)password WithConfirm:(NSString*)repassword;
@end
