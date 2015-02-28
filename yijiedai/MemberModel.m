//
//  MemberModel.m
//  yijiedai
//
//  Created by Mr.Q on 15/2/7.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "MemberModel.h"
#import "APService.h"
#import "KeychainItemWrapper/KeychainItemWrapper.h"
#import "CommUtil.h"

@implementation MemberModel

@synthesize userid;
@synthesize username;
@synthesize token;
@synthesize realname;
@synthesize deviceno;

- (void) initMember{
    
}

- (BOOL) save{

    return YES;
}



+ (BOOL) saveWithDict:(NSDictionary*)dict{
    //用户基础信息
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    [userDict setObject:[CommUtil objectToString:[dict objectForKey:@"user_id"]] forKey:@"user_id"];
    [userDict setObject:[CommUtil objectToString:[dict objectForKey:@"username"]] forKey:@"username"];
    [userDict setObject:[CommUtil objectToString:[dict objectForKey:@"idname"]] forKey:@"realname"];
    [userDict setObject:[CommUtil objectToString:[dict objectForKey:@"mobile"]] forKey:@"mobile"];
    [userDict setObject:[APService registrationID] forKey:@"jpush_id"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userDict forKey:@"userInfo"];
    //存储用户密码
    [self setAccessToken:[NSString stringWithFormat:@"%@",[dict objectForKey:@"access_token"]]];
    [self setUserId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]]];
    //初始化用户手势密码次数
    [self setKeywordTimes:5];
    return YES;
}

//用户普通信息
+ (NSString*) getUsername{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDict = [userDefaults objectForKey:@"userInfo"];
    return (NSString*)[userDict objectForKey:@"username"];
}

+ (NSString*) getDeviceno{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDict = [userDefaults objectForKey:@"userInfo"];
    NSString *jpId = (NSString*)[userDict objectForKey:@"jpush_id"];
    if([jpId isEqualToString:@""]){
        jpId = [CommUtil getUUID];
    }
    return jpId;
}

+ (NSString*) getRealname{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDict = [userDefaults objectForKey:@"userInfo"];
    return [userDict objectForKey:@"realname"]==nil?@"":(NSString*)[userDict objectForKey:@"realname"];
}

+ (void) setRealname:(NSString*)realname{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDict = [userDefaults objectForKey:@"userInfo"];
    
}


//用户加密信息
+ (NSString*) getUserId{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
    return (NSString*)[keychinUserToken objectForKey:(__bridge id)kSecAttrAccount];
}

+ (void) setUserId:(NSString*)userid{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
    NSString *token = [self getAccessToken];
    [keychinUserToken resetKeychainItem];
    [keychinUserToken setObject:@"YJD_USER_SERVICE" forKey:(__bridge id)kSecAttrService];
    [keychinUserToken setObject:userid forKey:(__bridge id)kSecAttrAccount];
    [keychinUserToken setObject:token forKey:(__bridge id)kSecValueData];
}

+ (NSString*) getAccessToken{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
    return (NSString*)[keychinUserToken objectForKey:(__bridge id)kSecValueData];
}

+ (void) setAccessToken:(NSString*)token{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
    NSString *uid = [self getUserId];
    [keychinUserToken resetKeychainItem];
    [keychinUserToken setObject:@"YJD_USER_SERVICE" forKey:(__bridge id)kSecAttrService];
    [keychinUserToken setObject:uid forKey:(__bridge id)kSecAttrAccount];
    [keychinUserToken setObject:token forKey:(__bridge id)kSecValueData];
    
}

+ (void) clearUserIdAndToken{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdUserToken"accessGroup:nil];
    [keychinUserToken resetKeychainItem];
}

+ (BOOL) isLogin{
    if(![[self getUserId] isEqualToString:@""]){
        if(![[self getAccessToken] isEqualToString:@""]){
            return YES;
        }
    }
    return NO;
}

//手势密码部分
+ (NSString*) getKeyword{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdGestureKeyword"accessGroup:nil];
    return (NSString*)[keychinUserToken objectForKey:(__bridge id)kSecValueData];
}

+ (void) setKeyword:(NSString*)keyword{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdGestureKeyword"accessGroup:nil];
    [keychinUserToken resetKeychainItem];
    [keychinUserToken setObject:@"YJD_KEYWORD_SERVICE" forKey:(__bridge id)kSecAttrService];
    [keychinUserToken setObject:keyword forKey:(__bridge id)kSecValueData];
}

+ (int) getKeywordTimes{
    KeychainItemWrapper * keychinTimes = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdGestureTimes"accessGroup:nil];
    return [[keychinTimes objectForKey:(__bridge id)kSecValueData] intValue];
}

+ (void) setKeywordTimes:(int)keywordTimes{
    KeychainItemWrapper * keychinUserToken = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdGestureTimes"accessGroup:nil];
    [keychinUserToken resetKeychainItem];
    [keychinUserToken setObject:@"YJD_TIMES_SERVICE" forKey:(__bridge id)kSecAttrService];
    [keychinUserToken setObject:[NSString stringWithFormat:@"%d",keywordTimes] forKey:(__bridge id)kSecValueData];
}


+ (void)clearKeywordAndTimes{
    KeychainItemWrapper * keychinKeyword = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdGestureKeyword" accessGroup:nil];
    [keychinKeyword resetKeychainItem];
    KeychainItemWrapper * keychinTimes = [[KeychainItemWrapper alloc]initWithIdentifier:@"YjdGestureTimes" accessGroup:nil];
    [keychinTimes resetKeychainItem];
}

@end
