//
//  SLActivityMenuViewController.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLActivityMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SLAppDelegate.h"

@interface SLActivityMenuViewController ()
    @property NSArray *activities;
@end

@implementation SLActivityMenuViewController

@synthesize welcomeUserLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.activities = @[];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.activities = @[
                            @{
                                @"title":@"Metrics",
                                @"storyboard": @"Metrics",
                                @"identifier": @"metricsViewController"
                                }
//                            ,
//                            @{
//                                @"title":@"Assets",
//                                @"storyboard": @"Assets",
//                                @"identifier": @"assetsViewController"
//                                }
                            ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"oil_gas_plant_blurred_darkened_cropped.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    // Disable scroll when content fits on screen
    self.tableView.alwaysBounceVertical = NO;
    
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    SLClient *client = d.client;
    SLUser *meUser = client.me;
    welcomeUserLabel.text = [NSString stringWithFormat:@"Welcome %@ %@", meUser.firstName, meUser.lastName];
    NSLog(@"MeUser: %@", meUser);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    //
    NSDictionary *act = self.activities[indexPath.row];
    NSString *title = act[@"title"];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSDictionary *act = self.activities[indexPath.row];
    
    // Get the storyboard named secondStoryBoard from the main bundle:
    NSString *storyboardName = [NSString stringWithFormat:@"%@_%@", act[@"storyboard"], @"iPad"];
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    // Load the view controller with the identifier string myTabBar
    // Change UIViewController to the appropriate class
    NSString *identifier = act[@"identifier"];
    UIViewController *viewController = (UIViewController *)[secondStoryBoard instantiateViewControllerWithIdentifier:identifier];
    
    // Switch front view controllers
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [d switchRevealFrontViewControllerTo:viewController show:true];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutBtnPressed:(id)sender {
    SLAppDelegate *d = (SLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [d logout];
}

@end
