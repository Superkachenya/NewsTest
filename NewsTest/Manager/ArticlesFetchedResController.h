//
//  ArticlesFetchedResController.h
//  NewsTest
//
//  Created by Voitenko Daniil on 18.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PersistenceController.h"

@interface ArticlesFetchedResController : NSFetchedResultsController

//@property (strong) NSFetchedResultsController *articles;

-(id)initWithFetchRequestFromArticles;


@end
