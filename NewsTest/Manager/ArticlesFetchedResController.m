//
//  ArticlesFetchedResController.m
//  NewsTest
//
//  Created by Voitenko Daniil on 18.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "ArticlesFetchedResController.h"
#import "PersistenceController.h"

@import UIKit;


@implementation ArticlesFetchedResController


-(id)initWithFetchRequestFromArticles
{
    
    PersistenceController *persistenceController = [PersistenceController sharedPersistenceController];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self = [super initWithFetchRequest:fetchRequest
                  managedObjectContext:persistenceController.mainContext
                    sectionNameKeyPath:nil
                             cacheName:@"Cache"];
    
    if (self){
        NSError *error = nil;
        [self performFetch:&error];
        
    }
    return self;
    
}
@end
