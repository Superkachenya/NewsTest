//
//  ArticlesFetchedResController.m
//  NewsTest
//
//  Created by Voitenko Daniil on 18.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "ArticlesFetchedResController.h"

@implementation ArticlesFetchedResController


-(id)initWithFetchRequestFromArticles
{
    if (self){
        PersistenceController *context = [[PersistenceController alloc] initWithCallback:nil];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
            
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            
            [fetchRequest setSortDescriptors:sortDescriptors];
        
        self = [super initWithFetchRequest:fetchRequest
               managedObjectContext:context.managedObjectContext
                 sectionNameKeyPath:nil
                          cacheName:@"Cache"];
    }
    return self;
    
}
@end
