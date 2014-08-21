//
//  SLHomeViewController.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLHomeViewController.h"
#import "SLAppDelegate.h"

@interface SLHomeViewController ()
- (IBAction)getStartedBtnPressed:(id)sender;

@end

@implementation SLHomeViewController
@synthesize usersNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *slBlue = [UIColor colorWithRed:(99/255.0) green:(189/255.0) blue:(211/255.0) alpha:1.0];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = slBlue;
        self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.tintColor = slBlue;
    }
    
    //
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SLClient *client = d.client;
    SLUser *meUser = client.me;
    usersNameLabel.text = [NSString stringWithFormat:@"%@ %@!", meUser.firstName, meUser.lastName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)getStartedBtnPressed:(id)sender {
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [d showActivityMenu];
}

@end
