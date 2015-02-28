//
//  CityModel.m
//  yijiedai
//
//  Created by Mr.Q on 15/2/4.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
- (CityModel *) initWithConnect
{
    [self connectDB];
    return self;
}

- (void) connectDB
{
    if(![self checkDataBase])
    {
        [self createDataBase];
    }
}
//检查是否能连接
- (BOOL) checkDataBase
{
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //并给文件起个文件名
    NSString *dbPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"city.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if(![db open])
    {
        return NO;
    }
    else
    {
        _db = db;
        return YES;
    }
}
- (void) createDataBase
{
    // First, test for existence. BOOL success=NO;
    BOOL success=NO;
    NSString *dbFileName = @"city.db";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error; NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){ NSLog(@"数据库存在");
        return;}
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFileName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }else {
        NSLog(@"createEditableCopyOfDatabaseIfNeeded initialize success");
    }
    [self checkDataBase];
}

- (FMResultSet *) selectCityWithId:(NSInteger)cityId{
    FMResultSet *rs = [_db executeQuery:@"select * from yjd_city where id = ?",[NSNumber numberWithInt:cityId]];
    return rs;
}

- (FMResultSet *) selectCityWithName:(NSString*)cityName{
    FMResultSet *rs = [_db executeQuery:@"select * from yjd_city where name = ?",cityName];
    return rs;
}

- (FMResultSet *) selectProvinceWithParentId:(NSInteger)provinceId{
    FMResultSet *rs = [_db executeQuery:@"select * from yjd_city where parentid = ?",[NSNumber numberWithInt:provinceId]];
    return rs;
}

- (FMResultSet *) selectProvinceWithoutParentId:(NSInteger)provinceId{
    FMResultSet *rs = [_db executeQuery:@"select * from yjd_city where parentid != ?",[NSNumber numberWithInt:provinceId]];
    return rs;
}

- (FMResultSet *) selectProvinceWithName:(NSString*)name{
    FMResultSet *rs = [_db executeQuery:@"select * from yjd_city where name = ?",name];
    return rs;
}

//- (FMResultSet *) selectActiveById:(int)aId
//{
//    NSNumber *aid = [NSNumber numberWithInt:aId];
//    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM active WHERE id = ?",aid];
//    return rs;
//}
//
//- (void) insertActiveWithDict:(NSDictionary *) active
//{
//    //检查表是否存在
//    if([self checkActiveTable])
//    {
//        //NSLog(@"%@",active);
//        NSString *aIdStr = [active objectForKey:@"id"];
//        int aId = [aIdStr intValue];
//        //NSLog(@"%d",aId);
//        //检查数据是否重复
//        if([self checkActiveById:aId])
//        {//id重复 更新此数据
//            [self updateActive: active];
//        }
//        else
//        {//id不存在 添加数据
//            [self insertActive: active];
//        }
//        
//    }
//    else
//    {
//        //创建表
//        [self createTable];
//        //添加数据
//        [self insertActive: active];
//    }
//}
- (void) insertActive:(NSDictionary *) active
{
    NSDictionary *picVal = [active objectForKey:@"pic"];
    [_db executeUpdate:@" INSERT INTO active (id,title,mNumMax,mNumNow,activePicId,cId,sort,picName,path) VALUES (?,?,?,?,?,?,?,?,?);",
     [NSNumber numberWithInt:[[active objectForKey:@"id"] intValue]],
     [active objectForKey:@"title"],
     [NSNumber numberWithInt:[[active objectForKey:@"mNumMax"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"mNumNow"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"activePicId"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"cId"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"sort"] intValue]],
     [picVal objectForKey:@"picName"],
     [picVal objectForKey:@"path"]
     ];
    
}
- (void) updateActive:(NSDictionary *) active
{
    //    NSMutableDictionary *dictionaryArgs = [NSMutableDictionary dictionary];
    //
    //    [dictionaryArgs setObject:[active objectForKey:@"title"]                                            forKey:@"title"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"mNumMax"] intValue]]      forKey:@"mNumMax"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"mNumNow"] intValue]]      forKey:@"mNumNow"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"activePicId"] intValue]]  forKey:@"activePicId"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"cId"] intValue]]          forKey:@"cId"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"sort"] intValue]]         forKey:@"sort"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"id"] intValue]]           forKey:@"id"];
    //    [dictionaryArgs setObject:[NSNumber numberWithInt:[[active objectForKey:@"mNumMax"] intValue]]      forKey:@"mNumMax"];
    //    NSLog(@"%@",dictionaryArgs);
    //    BOOL rc = [_db executeUpdate:@"UPDATE active SET title = :title, mNumMax = :mNumMax, mNumNow = :mNumNow, activePicId = :activePicId, cId = :cId, sort = :sort WHERE id = :id" withParameterDictionary:dictionaryArgs];
    NSDictionary *picVal = [active objectForKey:@"pic"];
    
    [_db executeUpdate:@"UPDATE active SET title = ?, mNumMax = ?, mNumNow = ?, activePicId = ?, cId = ?, sort = ?, picName = ?, path = ? WHERE id = ?;",
     [active objectForKey:@"title"],
     [NSNumber numberWithInt:[[active objectForKey:@"mNumMax"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"mNumNow"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"activePicId"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"cId"] intValue]],
     [NSNumber numberWithInt:[[active objectForKey:@"sort"] intValue]],
     [picVal objectForKey:@"picName"],
     [picVal objectForKey:@"path"],
     [NSNumber numberWithInt:[[active objectForKey:@"id"] intValue]]
     ];
    
}
- (FMResultSet *) selectActiveById:(int)aId
{
    NSNumber *aid = [NSNumber numberWithInt:aId];
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM active WHERE id = ?",aid];
    return rs;
}

- (FMResultSet *) selectActive:(int) start andLimit:(int) step
{
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM active LIMIT ? , ?;",[NSNumber numberWithInt:start],[NSNumber numberWithInt:step]];
    return rs;
}

- (BOOL) checkActiveById:(int)aId
{
    //int row = [_db intForQuery:@"SELECT  FROM active WHERE id = ?",aId];
    FMResultSet *rs = [self selectActiveById:aId];
    if ([rs next])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

-(BOOL)isExistsFile:(NSString *)filepath{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return [filemanage fileExistsAtPath:filepath];
}

@end
