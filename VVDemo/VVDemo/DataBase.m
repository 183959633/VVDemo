//
//  DataBase.m
//  VVDemo
//
//  Created by Jack on 2018/5/11.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "DataBase.h"
#import <FMDB.h>
@implementation DataBase
+ (DataBase*)shareInstance{
    
    static DataBase        *dataBase;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!dataBase) {
            dataBase            = [[DataBase alloc]init];
            dataBase.studentDB  = [[FMDatabase alloc]init];
        }
    });

    return dataBase;
}
- (void)setValueToModel:(NSMutableArray *)toArray classString:(NSString *)classString withFMResultSet:(FMResultSet *)rs
{
    NSDictionary *dic = [rs resultDictionary];
    [toArray addObject:dic];
}
#pragma 数据库初始化
-(void)createTab{
    
    NSString      *dbPath  = [DOCUMENT stringByAppendingPathComponent:@"student.db"];
    NSFileManager *file    = [NSFileManager defaultManager];
    _studentDB             = [FMDatabase databaseWithPath:dbPath];
    
    NSString      *SQL     = @"CREATE TABLE IF NOT EXISTS M_VERSION_UPDATE_INFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name,address,age)";
    
    if (![file fileExistsAtPath:dbPath]){

        if ([_studentDB open]) {
            
            BOOL res = [_studentDB executeUpdate:SQL];
            
            if (res) {
                NSLog(@"yes,创表成功!==%@",dbPath);
            
            }else{
                NSLog(@"no,创表失败了!");
            }
        }
        [_studentDB close];
        
    }else{
        NSLog(@"路径已存在,无需创建!");
    }
}
#pragma 以dic对象,向表中插入数据(此处可传入唯一 key 用于检测目标值是否已经存入 sql)
-(BOOL)addMessageIntoSQLite:(NSDictionary *)dictionary{
    NSString *SQL =nil;
    BOOL result;
    NSArray *arr  =[self qureyIDFromSQLiteWith:dictionary[@"id"]];
    
    if ([_studentDB open]) {
        //为数据库设置缓存,提高查询效率!
        [_studentDB setShouldCacheStatements:YES];
        if (arr.count>0) {
            SQL = [NSString stringWithFormat:@"update M_VERSION_UPDATE_INFO set name = '%@',address = '%@',age = '%@'",dictionary[@"name"],dictionary[@"address"],dictionary[@"age"]];
            
        }else{
            SQL = [[NSString alloc] initWithFormat:@"insert  into M_VERSION_UPDATE_INFO (name,address,age) values ('%@','%@','%@')",dictionary[@"name"],dictionary[@"address"],dictionary[@"age"]];
        }
        BOOL res = [_studentDB executeUpdate:SQL];
        if (res) {
            NSLog(@"insert seccess!!!=== %@",DOCUMENT);
    
            result = YES;
        }else{
            NSLog(@" insert failed!!!");
            result = NO;
        }
    }else{
        NSLog(@"DB did not open -> !!!");
        result = NO;
    }
    [_studentDB close];
    return result;
}

#pragma 通过 str 对象,查询一条数据
- (NSArray *)qureyIDFromSQLiteWith:(NSString *)str{
    
    NSMutableArray * modelArray = [NSMutableArray array];
    if ([_studentDB open]) {
        [_studentDB setShouldCacheStatements:YES];//为数据库设置缓存,提高查询效率!
        NSString *SQL = [NSString stringWithFormat:@"select * from M_VERSION_UPDATE_INFO where ID = '%@'",str];
        FMResultSet *rs = [_studentDB executeQuery:SQL];
        while ([rs next]) {
            [self setValueToModel:modelArray classString:@"M_VERSION_UPDATE_INFO" withFMResultSet:rs];
        }
    }else{
        NSLog(@"DB did not open -> !!!");
    }
    [_studentDB close];
    
    return modelArray;
}

#pragma ,查询'xxx_'表中数据所有数据
- (NSMutableArray *)qureyALLDataFromMessage{
    
    NSMutableArray * modelArray = [[NSMutableArray alloc] init];
    if ([_studentDB open]) {
        [_studentDB setShouldCacheStatements:YES];//为数据库设置缓存,提高查询效率!
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM M_VERSION_UPDATE_INFO"];
        FMResultSet *rs = [_studentDB executeQuery:sql];
        while ([rs next]) {
            [self setValueToModel:modelArray classString:@"M_VERSION_UPDATE_INFO" withFMResultSet:rs];
        }
    }else{
        NSLog(@"DB did not open -> !!!");
    }
    [_studentDB close];
    return modelArray;
}


#pragma 通过 str 对象,删除一条数据
- (void)removeMessageByid:(NSString *)str{
    NSString *SQL = [NSString stringWithFormat:@"delete from M_VERSION_UPDATE_INFO where ID = '%@'",str];
    if ([_studentDB open]) {
        [_studentDB setShouldCacheStatements:YES];//为数据库设置缓存,提高查询效率!
        BOOL res = [_studentDB executeUpdate:SQL];
        if (res) {
            NSLog(@"delete seccess!!!");
        }else{
            NSLog(@"delete failed!!!");
        }
    }else{
        NSLog(@"DB did not open -> !!!");
    }
    [_studentDB close];
}
#pragma 删除数据库中'xxx表'table
-(void)dropTableFromSqlite:(NSString *)tableName{
    
    NSString *SQL = nil;
    SQL = [NSString stringWithFormat:@"drop table %@",tableName];
    if ([_studentDB open]) {
        [_studentDB setShouldCacheStatements:YES];
        BOOL res = [_studentDB executeUpdate:SQL];
        if (res) {
            NSLog(@"drop 'table of %@' seccess!!!",tableName);
        }else{
            NSLog(@"drop 'table of %@' failed!!!",tableName);
        }
    }else{
        NSLog(@"open failed !!!");
    }
    [_studentDB close];
}
@end
