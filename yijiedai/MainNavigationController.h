//
//  MainNavigationController.h
//  yijiedai
//
//  Created by mdy1 on 15/1/29.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController

- (void)networkDidSetup:(NSNotification *)notification;
- (void)networkDidClose:(NSNotification *)notification;
- (void)networkDidRegister:(NSNotification *)notification;
- (void)networkDidLogin:(NSNotification *)notification;
- (void)networkDidReceiveMessage:(NSNotification *)notification;
- (void)serviceError:(NSNotification *)notification;

@end
