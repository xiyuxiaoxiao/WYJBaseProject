//
//  JKBaseModel.h
//  JKBaseModel
//
//  Created by zx_04 on 15/6/27.
//  Copyright (c) 2015年 joker. All rights reserved.
//  github:https://github.com/Joker-King/JKDBModel

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define PrimaryKey  @"primary key"

#define primaryId   @"pk"

@interface JKDBModel : NSObject

/** 主键 id */
@property (nonatomic, assign)   int        pk;
/** 列名 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeNames;
/** 列类型 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeTypes;

/** 
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys;

/** 获取所有属性，包括主键 */
+ (NSDictionary *)getAllProperties;

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable;

/** 表中的字段*/
+ (NSArray *)getColumns;

/** 保存或更新
 * 如果不存在主键，保存，
 * 有主键，则更新
 */
- (BOOL)saveOrUpdate;
/** 保存或更新
 * 如果根据特定的列数据可以获取记录，则更新，
 * 没有记录，则保存
 */
- (BOOL)saveOrUpdateByColumnName:(NSString*)columnName AndColumnValue:(NSString*)columnValue;
/** 保存单个数据 */
- (BOOL)save;
/** 批量保存数据 */
+ (BOOL)saveObjects:(NSArray *)array;
/** 更新单个数据 */
- (BOOL)update;
/** 批量更新数据*/
+ (BOOL)updateObjects:(NSArray *)array;
/** 删除单个数据 */
- (BOOL)deleteObject;
/** 批量删除数据 */
+ (BOOL)deleteObjects:(NSArray *)array;
/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria;
/** 通过条件删除 (多参数）--2 */
+ (BOOL)deleteObjectsWithFormat:(NSString *)format, ...;
/** 清空表 */
+ (BOOL)clearTable;

/** 查询全部数据 */
+ (NSArray *)findAll;

/** 通过主键查询 */
+ (instancetype)findByPK:(int)inPk;

+ (instancetype)findFirstWithFormat:(NSString *)format, ...;

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria;

+ (NSArray *)findWithFormat:(NSString *)format, ...;

/** 通过条件查找数据 
 * 这样可以进行分页查询 @" WHERE pk > 5 limit 10"
 */
+ (NSArray *)findByCriteria:(NSString *)criteria;
/**
 根据SQL 查询结果 创建对象
 */
+ (instancetype)JKDBModelWithResultset:(FMResultSet *)resultSet;
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;

#pragma mark - 版本更新

/**
 *
 * 将tab 表 中的列 更新 名为到 新的表中的列 此方法 只适用于 将旧表的字段更改 并且新表于旧表的 并不适用插入有数据的其他表的列中， 一般为更改表的列名 和 更改表名 当前表应该为新的使用的表 或者 自己
 * tab 要改变的表名
 * columns  要改变的列名
 * newColumns 改编后的列表 与columns 一一对应
 *
 * 第一个 用于更细自己的列名称，第二个用于更新表名 和 列名
 */
+ (void)updateColumns: (NSArray *)columns
            newColumn: (NSArray *)newColumns;
+ (void)updateTable: (NSString *)tab
            columns: (NSArray *)needColumns
          newColumn: (NSArray *)newColumns;

#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写 
 */
+ (NSArray *)transients;

/** 如果需要指定某些属性的值 不允许重复 那这个方法 必须在子类中重写
 */
+ (NSArray *)uniquePropertys;

/** 删除表 */
+ (BOOL)dropTable:(NSString *)tableName;
@end
