//
//  CityModel.h
//  yijiedai
//
//  Created by Mr.Q on 15/2/4.
//  Copyright (c) 2015年 yixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface CityModel : NSObject
@property (retain, nonatomic) FMDatabase *db;
@property (readwrite, nonatomic) sqlite3 *database;

- (CityModel *) initWithConnect;

- (void) connectDB;
- (BOOL) checkDataBase;
- (void) createDataBase;


- (FMResultSet *) selectProvinceWithParentId:(NSInteger)provinceId;
- (FMResultSet *) selectProvinceWithoutParentId:(NSInteger)provinceId;
- (FMResultSet *) selectProvinceWithName:(NSString*)name;
- (FMResultSet *) selectCityWithId:(NSInteger)cityId;
- (FMResultSet *) selectCityWithName:(NSString*)cityName;


/*
- (BOOL) checkTable;
- (void) createTable;

- (void) insertCity;
- (void) selectCity;
- (void) updateCity;
- (void) deleteCity;

- (BOOL) checkActiveTable;
- (void) insertActive:(NSDictionary *) active;
- (void) selectActive;
- (void) updateActive:(NSDictionary *) active;
- (void) deleteActive;

- (void) insertActiveWithDict:(NSDictionary *) active;
- (BOOL) checkActiveById:(int)aId;
- (FMResultSet *) selectActiveById:(int)aId;
- (FMResultSet *) selectActive:(int) start andLimit:(int) step;
*/
@end
