//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by qijingyu on 2015-01-26.
//  Copyright (c) 2015年 qijingyu. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TentacleView.h"
#import "GesturePasswordView.h"
#import "MainNavigationController.h"

@interface GesturePasswordController : UIViewController <MBProgressHUDDelegate,VerificationDelegate,ResetDelegate,GesturePasswordDelegate,UIAlertViewDelegate>

- (void)clear;

- (BOOL)exist;

@end
