//
//  RORVirtualProductService.m
//  WalkFun
//
//  Created by leon on 14-2-16.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORVirtualProductService.h"

@implementation RORVirtualProductService

//open out
+(Virtual_Product *)fetchVProduct:(NSNumber *) productId{
    return [self fetchVProduct:productId withContext:NO];
}

+(Virtual_Product *)fetchVProduct:(NSNumber *) productId withContext:(BOOL) needContext{
    NSString *table=@"Virtual_Product";
    NSString *query = @"productId = %@";
    NSArray *params = [NSArray arrayWithObjects:productId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Virtual_Product *vProduct = (Virtual_Product *) [fetchObject objectAtIndex:0];
    if(!needContext){
        return [Virtual_Product removeAssociateForEntity:vProduct];
    }
    return vProduct;
}

//open out
+ (BOOL)syncVProduct{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"VirtualProductUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORVirtualProductClientHandler getVirtualProducts:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *vProductList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *vProductDict in vProductList){
            NSNumber *productId = [vProductDict valueForKey:@"productId"];
            Virtual_Product *vProductEntity = [self fetchVProduct:productId withContext:YES];
            if(vProductEntity == nil)
                vProductEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Virtual_Product" inManagedObjectContext:context];
            [vProductEntity initWithDictionary:vProductDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"VirtualProductUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't sync virtual product Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

//open out
+(NSArray *)fetchAllVProduct{
    return [self fetchAllVProduct:NO];
}

+(NSArray *)fetchAllVProduct:(BOOL) needContext{
    NSString *table=@"Virtual_Product";
    NSString *query = @"1 = %@";
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"productId" ascending:YES];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *vProductsDetails = [NSMutableArray arrayWithCapacity:10];
    for (Virtual_Product *vProduct in fetchObject) {
        [vProductsDetails addObject:[Virtual_Product removeAssociateForEntity:vProduct]];
    }
    return [(NSArray*)vProductsDetails mutableCopy];
}

+(UIImage *)getImageOf:(Virtual_Product *)item{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, item.productId];
    UIImage *image = [UIImage imageWithContentsOfFile:pngFilePath];
    
    if (!image) {
        NSURL *imageUrl = [NSURL URLWithString:item.picLink];
        image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
        if (image){
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [data1 writeToFile:pngFilePath atomically:YES];
            NSLog(@"load pic [id:%@] from server", item.productId);
        }
    }
    return image;
}

@end
