//
//  MemberModel.h
//  yijiedai
//
//  Created by Mr.Q on 15/2/7.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject

@property(weak,nonatomic) NSString* userid;
@property(weak,nonatomic) NSString* username;
@property(weak,nonatomic) NSString* token;
@property(weak,nonatomic) NSString* realname;
@property(weak,nonatomic) NSString* deviceno;

- (void) initMember;
- (BOOL) save;
+ (BOOL) saveWithDict:(NSDictionary*)dict;
+ (NSString*) getUsername;
+ (NSString*) getDeviceno;
+ (NSString*) getRealname;


//用户加密信息
+ (NSString*) getUserId;
+ (void) setUserId:(NSString*)userid;
+ (NSString*) getAccessToken;
+ (void) setAccessToken:(NSString*)token;
+ (void)clearUserIdAndToken;
+ (BOOL) isLogin;

+ (NSString*) getKeyword;
+ (void) setKeyword:(NSString*)keyword;
+ (int) getKeywordTimes;
+ (void) setKeywordTimes:(int)keywordTimes;
+ (void)clearKeywordAndTimes;
@end
