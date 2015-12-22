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
@property (strong) NSManagedObjectContext *rootContext;
@property (strong, readwrite) NSManagedObjectContext *workerContext;

-(void)initializeCoreData;


@end

@implementation PersistenceController

+ (instancetype)sharedPersistenceController
{
    static PersistenceController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PersistenceController new];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        [self initializeCoreData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rootContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.rootContext];
    }
    
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
    self.rootContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [self.rootContext setPersistentStoreCoordinator:coordinator];
    
    [self.mainContext setParentContext:self.rootContext];
    [self.workerContext setParentContext:self.rootContext];
    
    /*
     To protect our main thread, we call -addPersistentStoreWithType: configuration: URL: options: error: in a dispatched background block.
     This will allow our -initializeCoreData method to return immediately, even if the persistent store needs to do some additional work
     */
    
        NSPersistentStoreCoordinator *psc = [[self rootContext] persistentStoreCoordinator];
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
    
    
}


- (void)rootContextDidSave:(NSNotification *)notification
{
    [self.mainContext performBlock:^{
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}


@end
