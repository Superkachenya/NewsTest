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

static NSString * const reuseIdentifier = @"newsCell";

@interface NewsDataSourceViewController ()

@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation NewsDataSourceViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Downloader downloadArticles];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc] initWithEntityName:@"Article"];
    self.articles = [[managedObjectContext executeFetchRequest:fetchrequest error:nil] mutableCopy];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier forIndexPath:indexPath];
    Article *newArticle = self.articles [indexPath.row];
    //cell.imageOfArticle.image = [UIImage imageNamed:newArticle.imageForTableView];
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
