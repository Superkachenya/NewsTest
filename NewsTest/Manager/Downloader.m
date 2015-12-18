//
//  Downloader.m
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "Downloader.h"
#import "PersistenceController.h"

static NSString * const BaseURLString = @"http://tgs.themindstudios.com/api/v1/application/ios_test_task/articles";

@implementation Downloader

+(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

+(void)downloadArticles
{
    NSString *string = BaseURLString;
    NSURL *url = [NSURL URLWithString:string];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        PersistenceController *context = [[PersistenceController alloc] initWithCallback:nil];
       
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray *arrayWithArticles = [NSArray arrayWithArray:(NSArray *)responseObject];
        
            for (id newArticle in arrayWithArticles) {
                NSDictionary *dictWithArticle = (NSDictionary *)newArticle;
            
                Article *newArticle = [NSEntityDescription insertNewObjectForEntityForName:@"Article"
                                                                    inManagedObjectContext:context.managedObjectContext];
                newArticle.id = [dictWithArticle objectForKey:@"id"];
                newArticle.title = [dictWithArticle objectForKey:@"title"];
                newArticle.imageThumb = [dictWithArticle objectForKey:@"image_thumb"];
                newArticle.imageMedium = [dictWithArticle objectForKey:@"image_medium"];
                newArticle.detailsURL = [dictWithArticle objectForKey:@"content_url"];
               // NSLog(@"%@", newArticle.title);
            }
            [context save];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
    
    
    
   
}

@end
