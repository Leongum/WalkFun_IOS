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

+(NSString *)getFileNameFrom:(NSURL *)URL{
    NSMutableString *strURL = [NSMutableString stringWithFormat:@"%@",URL];
    NSArray *comps = [strURL componentsSeparatedByString:@"/"];
    return [comps objectAtIndex:comps.count-1];
}

+(void)syncAllItemImages{
    NSArray *itemList = [self fetchAllVProduct];
    for (Virtual_Product *item in itemList) {
        [self getImageOf:item];
    }
}

+(UIImage *)getImageOf:(Virtual_Product *)item{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    NSURL *imageUrl = [NSURL URLWithString:item.picLink];
    NSString *fileName = [self getFileNameFrom:imageUrl];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:pngFilePath];
    
    if (!image) {
        NSURL *imageUrl = [NSURL URLWithString:item.picLink];
        [self getFileNameFrom:imageUrl];
        image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
        if (image){
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [data1 writeToFile:pngFilePath atomically:YES];
//            NSLog(@"load pic [id:%@] from server", item.productId);
        }
    }
    return image;
}

+(UIImage *)getRandomDropImageOf:(Virtual_Product *)item{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    NSArray *imageURLStringList = [item.dropPicList componentsSeparatedByString:@"|"];
    int index = arc4random() % imageURLStringList.count;
    if (imageURLStringList.count>1)
        index = 1;
    if (index>0) {
        NSLog(@"%@",[imageURLStringList objectAtIndex:index]);
    }
    NSURL *imageUrl = [NSURL URLWithString:[RORDBCommon getStringFromId:[imageURLStringList objectAtIndex:index]]];
    NSString *fileName = [self getFileNameFrom:imageUrl];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:pngFilePath];
    
    if (!image) {
        NSURL *imageUrl = [NSURL URLWithString:item.picLink];
        [self getFileNameFrom:imageUrl];
        image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imageUrl]];
        if (image){
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [data1 writeToFile:pngFilePath atomically:YES];
            //            NSLog(@"load pic [id:%@] from server", item.productId);
        }
    }
    return image;
}

+(void)syncAllEventSounds{
    NSArray *eventList = [RORSystemService fetchAllActionDefine:ActionDefineRun];
    for (Action_Define *event in eventList) {
        [self getSoundFileOf:event];
    }
}

+(NSString *)getSoundFileOf:(Action_Define *)event{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    NSURL *soundUrl = [NSURL URLWithString:event.soundLink];
    NSString *fileName = [self getFileNameFrom:soundUrl];
    NSString *mp3FilePath = [NSString stringWithFormat:@"%@/%@",docDir, fileName];
//    [NSData dataWithContentsOfFile:pngFilePath];
    NSData *mp3Data = [[NSData alloc] initWithContentsOfFile:mp3FilePath];
    if (!mp3Data) {
        [[NSData dataWithContentsOfURL:soundUrl] writeToFile:mp3FilePath atomically:YES];
        mp3Data = [[NSData alloc] initWithContentsOfFile:mp3FilePath];
    }
    return mp3FilePath;
}

@end
