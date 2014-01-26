//
//  RORContextUtils.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORContextUtils.h"

@implementation RORContextUtils

static NSManagedObjectContext *context = nil;

+(NSManagedObjectContext *)getShareContext{
    if(context == nil){
        RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
        context = delegate.managedObjectContext;
    }
    return context;
}

+(void)saveContext{
    NSError *error = nil;
    if (![[self getShareContext] save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query{
    [self getShareContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams{
    [self getShareContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortParams];
    
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams withLimit:(int)limitNumber{
    [self getShareContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortParams];
    [fetchRequest setFetchLimit:limitNumber];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(void)deleteFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query{
    [self getShareContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    [self saveContext];
}

+ (void)clearTableData:(NSArray *) tableArray{
    [self getShareContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    for(NSString *table in tableArray){
        NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchObject) {
            [context deleteObject:info];
        }
    }
    [self saveContext];
}
@end
