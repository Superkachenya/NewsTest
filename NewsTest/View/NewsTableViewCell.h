//
//  NewsTableViewCell.h
//  NewsTest
//
//  Created by Voitenko Daniil on 16.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageOfArticle;
@property (weak, nonatomic) IBOutlet UILabel *titleOfArticle;

@end
