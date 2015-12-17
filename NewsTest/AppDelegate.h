//
//  AppDelegate.h
//  NewsTest
//
//  Created by Voitenko Daniil on 15.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistenceController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly)PersistenceController *persistenceController;


@end

