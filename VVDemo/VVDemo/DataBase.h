//
//  DataBase.h
//  VVDemo
//
//  Created by Jack on 2018/5/11.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
#pragma 数据库宏定义
#define DB [DataBase shareInstance]
#pragma 获取Document根路径
#define DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]
@interface DataBase : NSObject
@property(nonatomic,strong)FMDatabase *studentDB;
+(DataBase *)shareInstance;
#pragma 数据库初始化--命名--'表名'
-(void)createTab;
#pragma 以dic 对象,向表中插入数据
-(BOOL)addMessageIntoSQLite:(NSDictionary *)dictionary;
# pragma 通过 str 对象,查询一条数据
- (NSArray *)qureyIDFromSQLiteWith:(NSString *)str;
# pragma ,查询'xxx_'表中所有数据
- (NSMutableArray *)qureyALLDataFromMessage;
# pragma 通过 str 对象,删除一条数据
- (void)removeMessageByid:(NSString *)str;
#pragma 删除数据库中'xxx表'table
-(void)dropTableFromSqlite:(NSString *)tableName;
@end
