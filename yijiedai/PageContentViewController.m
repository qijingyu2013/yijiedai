//
//  PageContentViewController.m
//  yijiedai
//
//  Created by mdy1 on 15/1/20.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "PageContentViewController.h"
#import "MainNavigationController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.openButton.hidden = YES;
//    self.titleLabel = self.titleText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openMainView:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainNavigationController *mainNavigationController = [storyBoard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    [self presentViewController:mainNavigationController animated:YES completion:nil];
}
@end