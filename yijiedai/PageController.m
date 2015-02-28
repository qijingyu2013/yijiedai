//
//  PageController.m
//  yijiedai
//
//  Created by mdy1 on 15/1/23.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "PageController.h"

@implementation PageController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad{
    [super viewDidLoad];
    [self runIntroducePage];
}

- (IBAction)startWalkThought:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma make - Page View Crontroller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    if(index==0 || index == NSNotFound){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PageContentViewController *pageContentViewController = (PageContentViewController*) viewController;
    NSUInteger index = pageContentViewController.pageIndex;
    if(index == NSNotFound){
        return nil;
    }
    
    index++;
    if(index == [self.pageTitles count]){
        pageContentViewController.openButton.hidden = NO;
        
        return nil;
    }else{
        pageContentViewController.openButton.hidden = YES;
    }
    
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    if ([self.pageTitles count] == 0 || index >= [self.pageTitles count]) {
        return nil;
    }
    
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [self.pageTitles count];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}

//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        LoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self presentViewController:loginViewController animated:YES completion:nil];
//}

#pragma mark - page introduce

- (BOOL) runIntroducePage{
    //if ([self isFirstLoad]) {
    NSLog(@"第一次启动!");
    //create data model
    _pageTitles = @[@"1", @"2", @"3"];
    _pageImages = @[@"guide01.png", @"guide02.png", @"guide03.png"];
    
    //create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height+40);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view] ;
    [self.pageViewController didMoveToParentViewController:self];
    //    }else{
    //        NSLog(@"不是第一次启动!");
    //    }
    return YES;
}
@end
