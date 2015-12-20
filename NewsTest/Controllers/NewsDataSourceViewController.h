//
//  NewsViewController.h
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesFetchedResController.h"


@interface NewsDataSourceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong) ArticlesFetchedResController *articlesController;
@property (strong) IBOutlet UITableView *tableView;


@end
