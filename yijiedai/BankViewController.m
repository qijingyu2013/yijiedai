//
//  BankViewController.m
//  yijiedai
//
//  Created by Mr.Q on 15/2/3.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "BankViewController.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "APService.h"
#import "CommUtil.h"
#import "MemberModel.h"

@interface BankViewController (){
    BOOL keyboardIsShow;
    UITextField* currentTextField;
}
@end

@implementation BankViewController

@synthesize bankScrollView=_bankScrollView;
@synthesize realNameTextField=_realNameTextField;
@synthesize bankNameTextField=_bankNameTextField;
@synthesize bankNumberTextField=_bankNumberTextField;
@synthesize provincesTextField=_provincesTextField;
@synthesize cityTextField=_cityTextField;
@synthesize openingBankNameTextField=_openingBankNameTextField;

@synthesize cityModel=_cityModel;
@synthesize bankArray=_bankArray;
@synthesize bankDetailDict=_bankDetailDict;
@synthesize userid=_userid;
@synthesize realname=_realname;
@synthesize token=_token;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bankNameTextField.delegate = self;
    self.provincesTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.openingBankNameTextField.delegate = self;
    self.bankNumberTextField.delegate = self;
    [self.bankScrollView setContentSize:CGSizeMake(320, 254)];
    self.realname = [MemberModel getRealname];
    self.userid = [MemberModel getUserId];
    self.token = [MemberModel getAccessToken];
    
    //self.
    GYBankCardFormatTextField *bankCardNumberTextField = [[GYBankCardFormatTextField alloc]initWithFrame:[self.bankNumberTextField frame]];
    bankCardNumberTextField.placeholder = @"请输入银行卡号";
    bankCardNumberTextField.tag = 19;
    bankCardNumberTextField.font = [UIFont fontWithName:@"Heiti SC" size:14.0f];//黑体-简 细体
    bankCardNumberTextField.adjustsFontSizeToFitWidth = YES;
    bankCardNumberTextField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    bankCardNumberTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bankCardNumberTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [self.bankNumberTextField removeFromSuperview];
    self.bankNumberTextField = bankCardNumberTextField;
//    self.bankNumberTextField.delegate = self;
    [self.bankScrollView addSubview:self.bankNumberTextField];
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;

    _cityModel= [[CityModel alloc] initWithConnect];
    
    [self initBasicInfo];
    
    self.bankArray = [NSMutableArray array];
    [self getBankNameArrayFromServer];
    
    /*
     FMResultSet *rs = [_cityModel selectCityWithId:[NSNumber numberWithInt:0]];
     
     while ([rs next]) {
     // just print out what we've got in a number of formats.
     NSLog(@"row: %d %@ %d %d %@",
     [rs intForColumn:@"id"],
     [rs stringForColumn:@"name"],
     [rs intForColumn:@"parentid"],
     [rs intForColumn:@"pid"],
     [rs stringForColumn:@"p"]);
     
     }
     */
}

- (void) viewWillAppear:(BOOL)animated{
    //show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:self.view.window];
    //hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
    //show
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    //hide
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void) keyboardDidShow:(NSNotification*) notification{
    if(keyboardIsShow)return;
    NSDictionary *info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.bankScrollView frame];
    viewFrame.size.height -= (keyboardRect.size.height/2);
    self.bankScrollView.frame = viewFrame;
    CGRect textFieldRect = [currentTextField frame];
    [self.bankScrollView scrollRectToVisible:textFieldRect animated:YES];
    keyboardIsShow = YES;
}

- (void) keyboardDidHide:(NSNotification*) notification{
    NSDictionary *info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    CGRect viewFrame = [self.bankScrollView frame];
    viewFrame.size.height += (keyboardRect.size.height/2);
    self.bankScrollView.frame = viewFrame;
    keyboardIsShow = NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)breakButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)selectBankNameAction:(id)sender {
    ActionStringDoneBlock bankNameDone = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.bankNameTextField.text = selectedValue;
    };
    ActionStringCancelBlock bankNameCancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    [ActionSheetStringPicker showPickerWithTitle:@"选择银行" rows:self.bankArray initialSelection:0 doneBlock:bankNameDone cancelBlock:bankNameCancel origin:sender];
}

- (IBAction)selectProvinces:(id)sender {
    ActionStringDoneBlock provinceDone = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.provincesTextField.text = selectedValue;
    };
    ActionStringCancelBlock provinceCancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    
    FMResultSet *rs = [_cityModel selectProvinceWithParentId:0];
    NSMutableArray *provincesArray = [NSMutableArray array];
    
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        [provincesArray addObject:[rs stringForColumn:@"name"]];
    }
    [ActionSheetStringPicker showPickerWithTitle:@"选择省份" rows:provincesArray initialSelection:0 doneBlock:provinceDone cancelBlock:provinceCancel origin:sender];
}

- (IBAction)selectCity:(id)sender {
    ActionStringDoneBlock cityDone = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.cityTextField.text = selectedValue;
    };
    ActionStringCancelBlock cityCancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    FMResultSet *rs;
    NSMutableArray *provincesArray = [NSMutableArray array];
    if([self.provincesTextField.text isEqualToString:@""]){
         rs = [_cityModel selectProvinceWithoutParentId:[[NSNumber numberWithInt:0] integerValue]];
    }else{
        FMResultSet *province = [_cityModel selectProvinceWithName:self.provincesTextField.text];
        if([province next]){
            NSNumber *provinceId = [NSNumber numberWithInt:[province intForColumn:@"id"]];
            rs = [_cityModel selectProvinceWithParentId:[provinceId integerValue]];
        }else{
            rs = [_cityModel selectProvinceWithoutParentId:[[NSNumber numberWithInt:0] integerValue]];
        }
    }
    while ([rs next]) {
        // just print out what we've got in a number of formats.
        [provincesArray addObject:[rs stringForColumn:@"name"]];
    }
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择城市" rows:provincesArray initialSelection:0 doneBlock:cityDone cancelBlock:cityCancel origin:sender];
    [picker showActionSheetPicker];
}

- (IBAction)bindBankButtonAction:(id)sender {
    BOOL ndl=YES;
    NSString *bankId;
    NSString *cityId;
    NSString *address;
    NSString *cardNum;
    //检查银行名称
    if (ndl) {
        if([self.bankNameTextField.text isEqualToString:@""]){
            ndl = NO;
            [CommUtil shakeTextField:self.bankNameTextField];
        }else{
            bankId = [self findKeyByBankName:self.bankNameTextField.text];
            if([bankId isEqualToString:@""]){
                ndl = NO;
                [CommUtil shakeTextField:self.bankNameTextField];
            }
        }
    }
    
    //检查省份名称
    if(ndl){
        if([self.provincesTextField.text isEqualToString:@""]){
            ndl = NO;
            [CommUtil shakeTextField:self.provincesTextField];
        }
    }
    
    //检查城市名称
    if(ndl){
        if([self.cityTextField.text isEqualToString:@""]){
            ndl = NO;
            [CommUtil shakeTextField:self.cityTextField];
        }else{
            FMResultSet *city = [_cityModel selectCityWithName:self.cityTextField.text];
            if([city next]){
                NSNumber *cityNum = [NSNumber numberWithInt:[city intForColumn:@"id"]];
                cityId = [NSString stringWithFormat:@"%@",cityNum];
            }else{
                ndl = NO;
                [CommUtil shakeTextField:self.cityTextField];
            }
        }
    }
    
    //检查开户行名称
    if(ndl){
        if([self.openingBankNameTextField.text isEqualToString:@""] && self.openingBankNameTextField.text.length<=3){
            ndl = NO;
            [CommUtil shakeTextField:self.openingBankNameTextField];
        }else{
            address = self.openingBankNameTextField.text;
        }
    }
    
    //检查银行卡号
    if(ndl){
        if([self.bankNumberTextField.text isEqualToString:@""]){
            ndl = NO;
            [CommUtil shakeTextField:self.bankNumberTextField];
        }else{
            cardNum = [self.bankNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    
    if(ndl){
        [self sendBankInfoToServiceWithBank:bankId
                                   WithCity:cityId
                            WithBankAddress:address
                                   WithCard:cardNum];
    }
}

- (void)sendBankInfoToServiceWithBank:(NSString*)bankId
                             WithCity:(NSString*)cityId
                      WithBankAddress:(NSString*)address
                             WithCard:(NSString*)cardNum{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.opacity = 0.4f;
    hud.yOffset = -120;
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"cash/addMyBankCard"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:cardNum forKey:@"bankcode"]; //银行卡号
    [requestForm setPostValue:address forKey:@"bankaddress"]; //开户行名称
    [requestForm setPostValue:bankId forKey:@"bank"]; //银行id
    [requestForm setPostValue:cityId forKey:@"city"]; //开户城市id
    
    [requestForm setPostValue:self.token forKey:@"access_token"];
    [requestForm setPostValue:self.userid forKey:@"user_id"];
    
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [requestForm addRequestHeader:@"Accept" value:@"application/json"];
    [requestForm setRequestMethod:@"POST"];
    [requestForm setTimeOutSeconds:60];
    
    [requestForm setCompletionBlock:^{
        NSData *data = [requestForm responseData];
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString* statusCode = (NSString*)[resultJSON objectForKey:@"state"];
        if([statusCode isEqualToString:@"1"]){
            //成功
            [hud hide:YES];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PassViewController"] animated:YES];
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

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    [self.bankNameTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.realNameTextField resignFirstResponder];
    [self.bankNameTextField resignFirstResponder];
    [self.provincesTextField resignFirstResponder];
    [self.cityTextField resignFirstResponder];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
}

//隐藏虚拟键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag > 17){
        return YES;
    }else{
        [textField resignFirstResponder];
        return NO;
    }
}

//
- (void)textFieldDidEndEditing:(UITextField *)textField{
    currentTextField = nil;
}

#pragma mark - login action
- (void) getBankNameArrayFromServer{
    [hud showWhileExecuting:@selector(myProgress) onTarget:self withObject:nil animated:YES];
    
    NSURL *url = [NSURL URLWithString:[APIURL stringByAppendingString:@"ebank/banks"]];
    __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
    
    [requestForm setPostValue:self.token forKey:@"access_token"];
    [requestForm setPostValue:self.userid forKey:@"user_id"];
    
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
            NSDictionary *bankDict = [resultData objectForKey:@"banks"];
            
            self.bankDetailDict = [NSMutableDictionary dictionary];
            for (NSDictionary *row in bankDict) {
                [self.bankArray addObject:[row objectForKey:@"bank_name"]];
                NSDictionary *dictTmp = [[NSDictionary alloc] initWithObjectsAndKeys:[row objectForKey:@"id_bank"],@"bankId", nil];
                [self.bankDetailDict setObject:dictTmp forKey:[row objectForKey:@"bank_name"]];
            }
            [hud hide:YES];
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

- (void) myProgress{
    sleep(120);
}

- (void) initBasicInfo{
    if([self.realname isEqualToString:@""]){
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先实名认证!";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RealViewController"]  animated:YES];
    }else if([self.userid isEqualToString:@""]||[self.token isEqualToString:@""]){
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先登入!";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]  animated:YES];
    }else{
        self.realNameTextField.text = self.realname;
    }
}

-(NSString*)findKeyByBankName:(NSString*)name{
    NSString *key = @"";
    NSDictionary *dictTmp = [self.bankDetailDict objectForKey:name];
    if(dictTmp !=nil){
        key = [NSString stringWithFormat:@"%@",[dictTmp objectForKey:@"bankId"]];
    }
    return key;
}
@end
