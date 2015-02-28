//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by qijingyu on 2015-01-26.
//  Copyright (c) 2015年 qijingyu. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}
@synthesize imgView;
@synthesize simulationView;
@synthesize forgetButton;
@synthesize changeButton;

@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, frame.size.height/2-80, 320, 320)];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        [self addSubview:view];
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, frame.size.height/2-120, 280, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:state];
        
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-35, frame.size.width/2-75, 70, 70)];
        [imgView setImage:[UIImage imageNamed:@"GestureHeader.png"]];
        //[imgView.layer setCornerRadius:35];
        //[imgView.layer setBorderColor:[UIColor grayColor].CGColor];
        //[imgView.layer setBorderWidth:3];
        [self addSubview:imgView];
        
//        simulationView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-40, frame.size.width/2-80, 80, 80)];
//        [simulationView setBackgroundColor:[UIColor blueColor]];
//        
//        for (int i=0; i<9; i++) {
//            NSInteger row = i/3;
//            NSInteger col = i%3;
//            // Button Frame
//            
//            NSInteger distance = 80/3+6;
//            NSInteger size = distance/3;
//            NSInteger margin = size/3;
//
//            GesturePasswordButton *pointSimulationView = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance+1, size, size)];
//            [pointSimulationView setTag:i+10];
//            [pointSimulationView.layer setBorderColor:[UIColor blackColor].CGColor];
//            [simulationView addSubview:pointSimulationView];
//        }

//        frame.origin.y=0;
//        [self addSubview:view];
//        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
//        [tentacleView setButtonArray:buttonArray];
//        [tentacleView setTouchBeginDelegate:self];
//        [self addSubview:tentacleView];

        
        
//        [simulationView.layer setCornerRadius:35];
//        [simulationView.layer setBorderColor:[UIColor grayColor].CGColor];
//        [simulationView.layer setBorderWidth:3];
        [self addSubview:simulationView];
        
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2-150, frame.size.height/2+220, 120, 30)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        
        changeButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2+30, frame.size.height/2+220, 120, 30)];
        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeButton setTitle:@"使用其他账号" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
        [self addSubview:changeButton];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        228 / 255.0, 80 / 255.0, 77 / 255.0, 1.00,
        165 / 255.0,  1 / 255.0, 1 / 255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}

-(void)forget{
    [gesturePasswordDelegate forget];
}

-(void)change{
    [gesturePasswordDelegate change];
}


@end
