//
//  NSManagedObjectContext+Save.m
//  NewsTest
//
//  Created by Voitenko Daniil on 22.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "NSManagedObjectContext+Save.h"

@implementation NSManagedObjectContext (Save)

-(void)save
{
    if ([self hasChanges])
    {
        [self performBlock:^{
            
            NSError *error = nil;
            [self save:&error];
            NSAssert(error == nil, @"ERROR!!!!!!");
            
            [self.parentContext save];
            
        }];
    }
}

@end
