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
    [self downloadImageWithURL:(NSURL *)article.imageThumb completionBlock:^ (BOOL succeeded, UIImage *image){
        
        if (succeeded) {
            cell.imageOfArticle.image = image;
            
        }
    }];
    
    return cell;
}



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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"venue";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Venue *venue = ((Venue * )self.venues[indexPath.row]);
    if (venue.userImage) {
        cell.imageView.image = venue.image;
    } else {
        // set default user image while image is being downloaded
        cell.imageView.image = [UIImage imageNamed:@"batman.png"];
        
        // download the image asynchronously
        [self downloadImageWithURL:venue.url completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                // change the image in the cell
                cell.imageView.image = image;
                
                // cache the image for use later (when scrolling up)
                venue.image = image;
            }
        }];
    }
}
*/

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
