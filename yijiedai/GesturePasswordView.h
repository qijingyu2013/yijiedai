//
//  GesturePasswordView.h
//  GesturePassword
//
//  Created by qijingyu on 2015-01-26.
//  Copyright (c) 2015年 qijingyu. All rights reserved.
//

@protocol GesturePasswordDelegate //<NSObject>

- (void)forget;
- (void)change;

@end

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@interface GesturePasswordView : UIView<TouchBeginDelegate>

@property (nonatomic,strong) TentacleView * tentacleView;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,assign) id<GesturePasswordDelegate> gesturePasswordDelegate;

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UIView * simulationView;
@property (nonatomic,strong) UIButton * forgetButton;
@property (nonatomic,strong) UIButton * changeButton;

@end
