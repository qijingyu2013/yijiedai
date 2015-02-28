//
//  TelephoneViewController.h
//  yijiedai
//
//  Created by mdy1 on 15/1/26.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommUtil.h"
#import "ASIFormDataRequest.h"



@interface TelephoneViewController : UIViewController <MBProgressHUDDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigateBar;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *sendTelephoneButton;
@property (retain, nonatomic) MBProgressHUD *hud;

- (IBAction)sendTelephoneButton:(id)sender;
- (IBAction)selectedButton:(id)sender;
- (IBAction)backButton:(id)sender;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end
