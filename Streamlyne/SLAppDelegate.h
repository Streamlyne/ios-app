//
//  SLAppDelegate.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import "StreamlyneSDK.h"

@interface SLAppDelegate : UIResponder <UIApplicationDelegate, PKRevealing>

#pragma mark - Properties
@property (nonatomic, strong, readwrite) PKRevealController *revealController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SLClient *client;

- (NSURL *)applicationDocumentsDirectory;

-(PKRevealController *) setupRevealController;
- (void) switchRevealFrontViewControllerTo:(UIViewController *) newFrontViewController show:(Boolean)shouldShow;
- (void) showActivityMenu;
- (void) showActivityFeed;

@end
