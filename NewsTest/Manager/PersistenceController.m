//
//  MyPersistentController.m
//  NewsTest
//
//  Created by Voitenko Daniil on 17.12.15.
//  Copyright © 2015 Voitenko Daniil. All rights reserved.
//

#import "PersistenceController.h"
#import "AppDelegate.h"

@interface PersistenceController()

@property (strong, readwrite) NSManagedObjectContext *mainContext;
@property (strong) NSManagedObjectContext *privateContext;
@property (strong, readwrite) NSManagedObjectContext *workerContext;

@property (copy) InitCallbackBlock initCallBack;

-(void)initializeCoreData;


@end

@implementation PersistenceController

+ (instancetype)sharedPersistenceController
{
    static PersistenceController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PersistenceController alloc] initWithCallback:^{
            NSLog(@"all works");
        }];
    });
    return sharedInstance;
}

-(id)initWithCallback:(InitCallbackBlock)callback
{
    if (!(self = [super init])) return nil;
    
    
    [self setInitCallBack:callback];
    [self initializeCoreData];
    
    return self;
}

-(void)initializeCoreData
{
    if (self.mainContext) return;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewsTest"
                                              withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom, @"%@: %@ No model to generate a store from",[self class], NSStringFromSelector(_cmd));
    
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSAssert(coordinator, @"Failed to initialize coordinator");
    
    //initializing contexts
    self.mainContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.privateContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [self.privateContext setPersistentStoreCoordinator:coordinator];
    
    [self.mainContext setParentContext:self.privateContext];
    [self.workerContext setParentContext:self.privateContext];
    
    /*
     To protect our main thread, we call -addPersistentStoreWithType: configuration: URL: options: error: in a dispatched background block.
     This will allow our -initializeCoreData method to return immediately, even if the persistent store needs to do some additional work
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
        
        NSPersistentStoreCoordinator *psc = [[self privateContext] persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"NewsTest.sqlite"];
        
        NSError *error = nil;
        
        NSAssert([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error], @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        /*
         However, the user interface needs to know when it is safe to access the persistence layer. Therefore we need to use the callback block that was given to us.
         */
        
        if (![self initCallBack]) return;
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self initCallBack]();
        });
    });
    
}

-(void)save
{
    if (![[self privateContext] hasChanges] && ![[self mainContext] hasChanges] && ![[self workerContext] hasChanges]) return;
    
    [self.mainContext performBlockAndWait:^{
        NSError *mainError = nil;
        
        NSAssert([self.mainContext save:&mainError], @"Error saving work context: %@\n%@", [mainError localizedDescription], [mainError userInfo]);
        
    }];
    
        [self.workerContext performBlockAndWait: ^{
            NSError *workerError = nil;
            
            NSAssert([self.workerContext save:&workerError], @"Error saving work context: %@\n%@", [workerError localizedDescription], [workerError userInfo]);
        }];
        
        [self.privateContext performBlock:^{
            NSError *privateError = nil;
            
            NSAssert([self.privateContext save:&privateError], @"Error saving privat context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
        }];
        
    //}];
}


@end
