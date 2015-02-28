//
//  TentacleView.h
//  GesturePassword
//
//  Created by qijingyu on 2015-01-26.
//  Copyright (c) 2015年 qijingyu. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ResetDelegate <NSObject>

- (BOOL)resetPassword:(NSString *)result;

@end

@protocol VerificationDelegate <NSObject>

- (BOOL)verification:(NSString *)result;

@end

@protocol TouchBeginDelegate <NSObject>

- (void)gestureTouchBegin;

@end



@interface TentacleView : UIView

@property (nonatomic,strong) NSArray * buttonArray;

@property (nonatomic,assign) id<VerificationDelegate> rerificationDelegate;

@property (nonatomic,assign) id<ResetDelegate> resetDelegate;

@property (nonatomic,assign) id<TouchBeginDelegate> touchBeginDelegate;

/*
 1: Verify
 2: Reset
 */
@property (nonatomic,assign) NSInteger style;

- (void)enterArgin;

@end
