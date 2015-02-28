//
//  BankViewController.h
//  yijiedai
//
//  Created by Mr.Q on 15/2/3.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommUtil.h"
#import "ASIFormDataRequest.h"
#import <sqlite3.h>
#import "ActionSheetPicker.h"
#import "CityModel.h"
#import "GYBankCardFormatTextField.h"

@class AbstractActionSheetPicker;
@interface BankViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bankScrollView;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *provincesTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *openingBankNameTextField;
@property (strong, nonatomic) IBOutlet GYBankCardFormatTextField *bankNumberTextField;
//@property (readonly, nonatomic) sqlite3 *db;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (retain, nonatomic) CityModel *cityModel;
@property (strong, nonatomic) NSMutableArray *bankArray;
@property (strong, nonatomic) NSMutableDictionary *bankDetailDict;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *realname;
@property (retain, nonatomic) MBProgressHUD *hud;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)breakButtonAction:(id)sender;
- (IBAction)selectBankNameAction:(id)sender;
- (IBAction)selectProvinces:(id)sender;
- (IBAction)selectCity:(id)sender;
- (IBAction)bindBankButtonAction:(id)sender;

- (void) initBasicInfo;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) myProgress;
- (void)sendBankInfoToServiceWithBank:(NSString*)bankId
                             WithCity:(NSString*)cityId
                      WithBankAddress:(NSString*)address
                             WithCard:(NSString*)CardNo;
@end
