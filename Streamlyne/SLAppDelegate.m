//
//  SLAppDelegate.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLAppDelegate.h"
// CocoaLumberJack
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
// ViewControllers
#import "SLHomeViewController.h"
#import "SLLoginViewController.h"

@implementation SLAppDelegate

@synthesize client;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure CocoaLumberjack
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDLogInfo(@"Initializing");
    
    // Setup Defaults for Settings
    [self registerDefaultsFromSettingsBundle];
    
    // Make Status Bar text white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Magical Record
    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    DDLogInfo(@"Finished setting up RevealController");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

#pragma mark - Settings
- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        DDLogInfo(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key && [[prefSpecification allKeys] containsObject:@"DefaultValue"]) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - PKRevealing

-(PKRevealController *) setupRevealController {
    
    if (self.revealController == nil) {
        // Step 1: Create your controllers.
        SLHomeViewController *frontViewController = [[UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:nil] instantiateViewControllerWithIdentifier:@"homeViewController"];
        
        // Setup root navigation controller
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        
        // glyphicons_halflings_055_list.png
        UITableViewController *leftViewController = [[UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:nil] instantiateViewControllerWithIdentifier:@"activityMenuViewController"];
        
        // Step 2: Instantiate.
        self.revealController = [PKRevealController revealControllerWithFrontViewController:frontNavigationController
                                                                         leftViewController:leftViewController
                                 //                                       rightViewController:[self rightViewController]
                                 ];
        // Step 3: Configure.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iOS 3.2 or later.
            [self.revealController setMinimumWidth:620.0 maximumWidth:644.0 forViewController:leftViewController];
        }
        else
        {
            // The device is an iPhone or iPod touch.
            [self.revealController setMinimumWidth:276.0 maximumWidth:280.0 forViewController:leftViewController];
        }
        self.revealController.delegate = self;
        self.revealController.animationDuration = 0.25;
        
        [self switchRevealFrontViewControllerTo:frontViewController show:YES];
    }
    return self.revealController;
}

- (void)revealController:(PKRevealController *)revealController didChangeToState:(PKRevealControllerState)state
{
    DDLogInfo(@"%@ (%d)", NSStringFromSelector(_cmd), (int)state);
}

- (void)revealController:(PKRevealController *)revealController willChangeToState:(PKRevealControllerState)next
{
    PKRevealControllerState current = revealController.state;
    DDLogInfo(@"%@ (%d -> %d)", NSStringFromSelector(_cmd), (int)current, (int)next);
}

#pragma mark - Helpers

- (void) switchRevealFrontViewControllerTo:(UIViewController *) newFrontViewController show:(Boolean)shouldShow {
    
    // Switch front view controllers
    UINavigationController *frontNavigationController = (UINavigationController *) self.revealController.frontViewController;
    [frontNavigationController setViewControllers:@[newFrontViewController] animated:YES];
    
    // add left bar button item for activity menu
    UIImage* activityMenuImage = [UIImage imageNamed:@"glyphicons_halflings_054_align-justify.png"];
    // Make image a template image
    activityMenuImage = [activityMenuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //
    CGRect frameimg = CGRectMake(0, 0, activityMenuImage.size.width, activityMenuImage.size.height);
    UIButton *activityMenuBtn = [[UIButton alloc] initWithFrame:frameimg];
    [activityMenuBtn setTintColor:[UIColor whiteColor]];
    [activityMenuBtn setBackgroundImage:activityMenuImage forState:UIControlStateNormal];
    [activityMenuBtn addTarget:self action:@selector(showActivityMenu)
              forControlEvents:UIControlEventTouchUpInside];
    [activityMenuBtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *activityMenuBarBtn =[[UIBarButtonItem alloc] initWithCustomView:activityMenuBtn];
    frontNavigationController.topViewController.navigationItem.leftBarButtonItem = activityMenuBarBtn;
    
    if (shouldShow) {
        // Show front view controller
        [self.revealController showViewController:newFrontViewController];
    }
    
}

- (void) showActivityMenu {
    [self.revealController showViewController:self.revealController.leftViewController];
}


- (void) showActivityFeed {
    [self.revealController showViewController:self.revealController.rightViewController];
}

#warning FIXME: Remove this and create the ActivitiesViewController
- (UIViewController *)rightViewController
{
    UIViewController *rightViewController = [[UIViewController alloc] init];
    rightViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"oil_gas_plant.jpg"]];
    
    
    UIButton *presentationModeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-200.0, 60.0, 180.0, 30.0)];
    presentationModeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [presentationModeButton setTitle:@"Presentation Mode" forState:UIControlStateNormal];
    [presentationModeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [presentationModeButton addTarget:self.revealController
                               action:@selector(startPresentationMode)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [rightViewController.view addSubview:presentationModeButton];
    
    return rightViewController;
}

- (void)startPresentationMode
{
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES completion:nil];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}

- (void) login
{
    // Setup
    [self setupRevealController];
    
    // Step 4: Apply.
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    
}

- (void) logout
{
    SLLoginViewController *loginViewController = [[UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    // Apply
    self.window.rootViewController = loginViewController;
}

@end
