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
#import "Downloader.h"
#import "ArticleDetailsViewController.h"

static NSString * const reuseIdentifier = @"newsCell";

@interface NewsDataSourceViewController () <NSFetchedResultsControllerDelegate>

@property (strong) UIRefreshControl *refreshControl;

@end

@implementation NewsDataSourceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.articlesController = [[ArticlesFetchedResController alloc] initWithFetchRequestFromArticles];
    self.articlesController.delegate = self;
    
    
    //setUp pullToRefresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(checkForUpdates)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - updates checker

-(void)checkForUpdates
{
    [Downloader downloadArticles];
    [self.refreshControl endRefreshing];
    
}


#pragma mark - Image download method

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailsURL"]) {
        ArticleDetailsViewController *details = [segue destinationViewController];
        NSIndexPath *indexPath =  [self.tableView indexPathForSelectedRow];
        Article *article = [self.articlesController objectAtIndexPath:indexPath];
        details.articleURL = article.detailsURL;
        details.imageMedium = article.imageMedium;
    }
    
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
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
    NSURL *url = [NSURL URLWithString:article.imageThumb];
    
    cell.titleOfArticle.text = article.title;
    [self downloadImageWithURL:url completionBlock:^ (BOOL succeeded, UIImage *image){
        
        if (succeeded) {
            cell.imageOfArticle.image = image;
            
        }
    }];
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersistenceController *persistenceLink = [PersistenceController sharedPersistenceController];
    NSManagedObjectContext *context = persistenceLink.workerContext;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.articlesController objectAtIndexPath:indexPath]];
        
        [persistenceLink save];
        [self controllerDidChangeContent:self.articlesController];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
