//
//  Downloader.m
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "Downloader.h"
#import "PersistenceController.h"
#import "NSManagedObjectContext+Save.h"

static NSString * const BaseURLString = @"http://tgs.themindstudios.com/api/v1/application/ios_test_task/articles";

@implementation Downloader



+(void)downloadArticles
{
    NSString *string = BaseURLString;
    NSURL *url = [NSURL URLWithString:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            PersistenceController *persistenceController = [PersistenceController sharedPersistenceController];
            
            
            NSArray *arrayWithArticles = (NSArray *)responseObject;
            
            NSManagedObjectContext *context = persistenceController.workerContext;
            
            for (id newArticle in arrayWithArticles) {
                if ([newArticle isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dictWithArticle = (NSDictionary *)newArticle;
                    
                    NSNumber *identifier = dictWithArticle[@"id"];
                    
                    __block Article *article = nil;
                    
                    NSFetchRequest *articleFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
                    articleFetchRequest.fetchLimit = 1;
                    articleFetchRequest.predicate = [NSPredicate predicateWithFormat:@"id == %@", identifier];
                    
                    [context performBlockAndWait:^{
                        
                        article = [context executeFetchRequest:articleFetchRequest error:nil].firstObject;
                    }];
                    
                    if (article == nil) {
                        article = [NSEntityDescription insertNewObjectForEntityForName:@"Article"
                                                                inManagedObjectContext:context];
                    }
                    
                    
                    article.id = identifier;
                    article.title = [dictWithArticle objectForKey:@"title"];
                    article.imageThumb = [dictWithArticle objectForKey:@"image_thumb"];
                    article.imageMedium = [dictWithArticle objectForKey:@"image_medium"];
                    article.detailsURL = [dictWithArticle objectForKey:@"content_url"];
                    // NSLog(@"%@", newArticle.title);
                    
                }
            }
            [context save];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}

@end
