//
//  Downloader.h
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Article.h"

@interface Downloader : NSObject

+(void)downloadArticles;


@end
