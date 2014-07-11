//
//  SLAppDelegate.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"

@interface SLAppDelegate : UIResponder <UIApplicationDelegate, PKRevealing>

#pragma mark - Properties
@property (nonatomic, strong, readwrite) PKRevealController *revealController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void) switchRevealFrontViewControllerTo:(UIViewController *) newFrontViewController show:(Boolean)shouldShow;
- (void) showActivityMenu;
- (void) showActivityFeed;

@end
