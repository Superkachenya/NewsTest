//
//  NewsViewController.m
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "NewsDataSourceViewController.h"
#import <CoreData/CoreData.h>
#import "NewsTableViewCell.h"
#import "Article.h"
#import "Downloader.h"
#import "PersistenceController.h"
#import "AppDelegate.h"

static NSString * const reuseIdentifier = @"newsCell";

@interface NewsDataSourceViewController ()

@property (nonatomic, strong) NSFetchedResultsController *articles;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation NewsDataSourceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    PersistenceController *context = [[PersistenceController alloc]initWithCallback:nil];
    
    //[Downloader downloadArticles];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    self.articles = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                        managedObjectContext:context.managedObjectContext
                                                          sectionNameKeyPath:nil
                                                                   cacheName:@"Cache"];
    [self.tableView reloadData];
    
    [self.articles performFetch:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.articles sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.articles sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier forIndexPath:indexPath];
    Article *newArticle = [self.articles objectAtIndexPath:indexPath];;
    cell.titleOfArticle.text = newArticle.title;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
