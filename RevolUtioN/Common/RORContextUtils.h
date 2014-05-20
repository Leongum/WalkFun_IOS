//
//  RORContextUtils.h
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORUtils.h"

@interface RORContextUtils : NSObject

+(NSManagedObjectContext *)getPrivateContext;

+(void)saveContext:(NSManagedObjectContext *) context;

+ (NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withContext:(NSManagedObjectContext *) context;

+ (NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams withContext:(NSManagedObjectContext *) context;

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams withLimit:(int)limitNumber withContext:(NSManagedObjectContext *) context;

+ (void)deleteFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withContext:(NSManagedObjectContext *) context;

+ (void)clearTableData:(NSArray *) tableArray withContext:(NSManagedObjectContext *) context;

@end
