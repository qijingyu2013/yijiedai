//
//  CommUtil.m
//  yijiedai
//
//  Created by qijingyu on 15/1/27.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "CommUtil.h"

@implementation CommUtil

//弹出框 带定时自动消失功能
+ (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView *) [theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

+ (void)showAlert:(NSString*)_message{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
//判断字符串长度 中文 2 英文 1
+ (NSUInteger)unicodeLengthOfString:(NSString*)text{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}

//切割字符串 取首尾各一个字符 当中用*填充
+ (NSString*)spliteOfStringSpec:(NSString*)text{
    return [NSString stringWithFormat:@"%@*****%@" , [text substringToIndex:1], [text substringFromIndex:text.length-1]];
}
+ (NSString*)spliteOfStringSpec:(NSString*)text WithHead:(NSInteger)head WithFoot:(NSInteger)foot{
    return [NSString stringWithFormat:@"%@*****%@" , [text substringToIndex:head], [text substringFromIndex:text.length-foot]];
}
//判断是否有特殊字符
+ (NSUInteger)isIncludeSpecialCharact:(NSString*)text{
    NSRange urgentRange = [text rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€ 　"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

//device_no = uuid
+ (NSString*) getUUID{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString*)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

//md5
+ (NSString*)string2Md5:(NSString*)string{
    const char *charString = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(charString, (int)strlen(charString), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//
+ (void)shakeTextField:(UITextField*)textField
{
    textField.layer.transform = CATransform3DMakeTranslation(10.0, 0.0, 0.0);
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        textField.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        textField.layer.transform = CATransform3DIdentity;
    }];
}

+ (UIViewController*)getCurrentViewController{
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if(topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (topWindow in windows) {
            if(topWindow.windowLevel == UIWindowLevelNormal){
                break;
            }
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    if([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else if([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }else{
    }
    return result;
}

+ (NSString*)objectToString:(id) obj{
    return [obj isKindOfClass:[NSNull class]]?@"":[NSString stringWithFormat:@"%@",obj];
}
@end
