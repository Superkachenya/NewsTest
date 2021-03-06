//
//  ArticleDetailsViewController.m
//  NewsTest
//
//  Created by Voitenko Daniil on 19.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "ArticleDetailsViewController.h"

@interface ArticleDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webViewArticle;


@end

@implementation ArticleDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.articleURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webViewArticle loadRequest:request];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)shareButton:(id)sender {
    
    NSURL *url = [NSURL URLWithString:self.imageMedium];
  
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[self.articleURL, url]
                                      applicationActivities:nil];
    //activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList];

    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:nil];
    
}



@end
