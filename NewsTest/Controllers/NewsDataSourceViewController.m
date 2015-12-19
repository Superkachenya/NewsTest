//
//  NewsViewController.m
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "NewsDataSourceViewController.h"
#import "NewsTableViewCell.h"
#import "Article.h"
#import "ArticlesFetchedResController.h"
#import "Downloader.h"

static NSString * const reuseIdentifier = @"newsCell";

@interface NewsDataSourceViewController () <NSFetchedResultsControllerDelegate>

@property (strong) ArticlesFetchedResController *articlesController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation NewsDataSourceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Downloader downloadArticles];
    self.articlesController = [[ArticlesFetchedResController alloc] initWithFetchRequestFromArticles];
    self.articlesController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.articlesController.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.articlesController sections][section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier forIndexPath:indexPath];
    Article *article = [self.articlesController objectAtIndexPath:indexPath];
    cell.titleOfArticle.text = article.title;
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


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
