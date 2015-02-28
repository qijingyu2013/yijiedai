//
//  PageContentViewController.h
//  yijiedai
//
//  Created by mdy1 on 15/1/20.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
- (IBAction)openMainView:(id)sender;

@end
