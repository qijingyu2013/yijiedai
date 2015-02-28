//
//  RealViewController.h
//  yijiedai
//
//  Created by Mr.Q on 15/2/3.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommUtil.h"
#import "ASIFormDataRequest.h"

@interface RealViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) NSString *token;
@property (weak, nonatomic) NSString *userid;
@property (weak, nonatomic) NSString *username;
@property (retain, nonatomic) MBProgressHUD *hud;


- (IBAction)backButtonAction:(id)sender;
- (IBAction)breakButtonAction:(id)sender;
- (IBAction)sendRealInfoAction:(id)sender;

- (void)sendRealInfoToServerWithToken:(NSString*)accessToken WithUserid:(NSString*)userId WithRealname:(NSString*)realname WithIdcard:(NSString*)idcard;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) myProgress;
@end
