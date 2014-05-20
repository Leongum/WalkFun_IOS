//
//  RORContextUtils.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORContextUtils.h"

@implementation RORContextUtils


//***************** private ***************
+(NSManagedObjectContext *)generatePrivateContextWithParent:(NSManagedObjectContext *)parentContext {
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateContext.parentContext = parentContext;
    return privateContext;
}

+(NSManagedObjectContext *)generateStraightPrivateContextWithParent:(NSManagedObjectContext *)mainContext {
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] init];
    privateContext.persistentStoreCoordinator = mainContext.persistentStoreCoordinator;
    return privateContext;
}

//***************** public ***************
+(NSManagedObjectContext *)getPrivateContext{
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext  *context = delegate.managedObjectContext;
    return [self generatePrivateContextWithParent:context];
}

+(void)saveContext:(NSManagedObjectContext *) context{
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    RORAppDelegate *appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withContext:(NSManagedObjectContext *) context{
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

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams withContext:(NSManagedObjectContext *) context{
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

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams withLimit:(int)limitNumber withContext:(NSManagedObjectContext *) context{
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

+(void)deleteFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withContext:(NSManagedObjectContext *) context{
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
    [self saveContext:context];
}

+ (void)clearTableData:(NSArray *) tableArray withContext:(NSManagedObjectContext *) context{
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
    [self saveContext:context];
}
@end
