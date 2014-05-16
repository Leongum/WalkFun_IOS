//
//  main.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RORAppDelegate.h"

int main(int argc, char *argv[])
{
//    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
//    [ctx setUndoManager:nil];
//    [ctx setPersistentStoreCoordinator: [delegate persistentStoreCoordinator]];
//
//    // Register context with the notification center
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self
//           selector:@selector(mergeChanges:)
//               name:NSManagedObjectContextDidSaveNotification
//             object:ctx];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([RORAppDelegate class]));
    }
}
