//
//  MyPersistentController.h
//  NewsTest
//
//  Created by Voitenko Daniil on 17.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^InitCallbackBlock)(void);

@interface PersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *mainContext;
@property (strong, readonly) NSManagedObjectContext *workerContext;


+ (instancetype)sharedPersistenceController;

-(void)save;

@end
