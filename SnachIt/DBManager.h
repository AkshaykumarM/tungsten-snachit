//
//  DBManager.h
//  SQLite3DBSample
//
//  Created by Akshay Maldhure on 17/1/015.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;



-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
