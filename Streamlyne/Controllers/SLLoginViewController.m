//
//  SLLoginViewController.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLLoginViewController.h"
#import "SLAppDelegate.h"
#import "StreamlyneSDK.h"
#import "MBProgressHUD.h"
#import "UITextField+PlaceholderColor.h"

@interface SLLoginViewController ()
- (IBAction)loginBtnPressed:(UIButton *)sender;
@end

@implementation SLLoginViewController

@synthesize emailTextField, passwordTextField, organizationTextField;

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
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.organizationTextField.delegate = self;
    
    // Change placeholder text color
    UIColor *placeholderColor = [UIColor grayColor];
    [self.emailTextField setPlaceholderColor:placeholderColor];
    [self.passwordTextField setPlaceholderColor:placeholderColor];
    [self.organizationTextField setPlaceholderColor:placeholderColor];
    
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
    
    // Validate login
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Streamlyne API Client
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *host = [defaults stringForKey:@"apiHost"];
    SLClient *client = [SLClient connectWithHost:host];
    d.client = client;
    
    // Get Login info
    NSString *email = emailTextField.text;
    NSString *password = passwordTextField.text;
    NSString *organization = organizationTextField.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    // Login with credentials
    [client authenticateWithUserEmail:email
                              withPassword:password
                          withOrganization:organization]
    .then(^(SLClient *client, SLUser *me) {
        
        [hud hide:YES];
        [d login];
        
    }).catch(^(NSError *error) {
        
        [hud hide:YES];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                           message:error.localizedRecoverySuggestion
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        
    });

}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.organizationTextField) {
        [theTextField resignFirstResponder];
        [self loginBtnPressed:nil];
    } else if (theTextField == self.passwordTextField) {
        [self.organizationTextField becomeFirstResponder];
    } else if (theTextField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [theTextField resignFirstResponder];
    }
    return YES;
}

@end
