//
//  SLLoginViewController.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLLoginViewController.h"
#import "SLAppDelegate.h"

@interface SLLoginViewController ()
- (IBAction)loginBtnPressed:(UIButton *)sender;

@end

@implementation SLLoginViewController

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

- (IBAction)loginBtnPressed:(UIButton *)sender {
    
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Step 4: Apply.
    d.window.rootViewController = d.revealController;
    [d.window makeKeyAndVisible];
    
}

@end
