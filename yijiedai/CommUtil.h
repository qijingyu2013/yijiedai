//
//  CommUtil.h
//  yijiedai
//
//  Created by qijingyu on 15/1/27.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *apiUrl;
static NSString *apiLoginUrl;
static NSString *mainUrl;

@interface CommUtil : NSObject
//弹出框 带定时自动消失功能
+ (void)timerFireMethod:(NSTimer*)theTimer;
+ (void)showAlert:(NSString*)_message;

//判断字符串长度
+ (NSUInteger)unicodeLengthOfString:(NSString*)text;

//对象转字符串
+ (NSString*)objectToString:(id) obj;

//切割字符串 取首尾各一个字符 当中用*填充
+ (NSString*)spliteOfStringSpec:(NSString*)text;
+ (NSString*)spliteOfStringSpec:(NSString*)text WithHead:(NSInteger)head WithFoot:(NSInteger)foot;

//判断是否有特殊字符
+ (NSUInteger)isIncludeSpecialCharact:(NSString*)text;

//device_no = uuid
+ (NSString*) getUUID;

//md5
+ (NSString*)string2Md5:(NSString*)string;

+ (void)shakeTextField:(UITextField*)textField;

+ (UIViewController*)getCurrentViewController;
@end