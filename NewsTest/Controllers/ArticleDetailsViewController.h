//
//  ArticleDetailsViewController.h
//  NewsTest
//
//  Created by Voitenko Daniil on 19.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailsViewController : UIViewController


@property (weak) NSString *articleTitle;
@property (weak) NSString *articleURL;
@property (weak) NSString *imageMedium;


- (IBAction)shareButton:(id)sender;

@end
