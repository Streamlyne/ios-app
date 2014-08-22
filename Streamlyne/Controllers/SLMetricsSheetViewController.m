//
//  SLMetricsSheetViewController.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-23.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLMetricsSheetViewController.h"
#import "SLAttributeDataInputViewCell.h"
#import <Streamlyne-Cocoa-SDK/SLAttribute.h>

@interface SLMetricsSheetViewController ()

@end

@implementation SLMetricsSheetViewController

@synthesize descriptionLabel, attributeCollection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    // Display AttributeCollection's meta data
    [RACObserve(attributeCollection, name) subscribeNext:^(NSString *name)
     {
         self.title = name;
     }];
    [RACObserve(attributeCollection, desc) subscribeNext:^(NSString *description)
     {
         self.descriptionLabel.text = description;
     }];
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    // Configure View Controller
    [self setRefreshControl:refreshControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleRefresh:(UIRefreshControl *)refreshControl
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        // Request
        [self.refreshControl beginRefreshing];
        [self.attributeCollection reloadRecord]
        //[SLAttributeCollection findById:attributeCollection.nid]
        .then(^(SLAttributeCollection *record) {
            NSLog(@"attributeCollection: %@", record);
            self.attributeCollection = record;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        })
        .catch(^(NSError *error) {
            DDLogInfo(@"Error: %@", error);
        });

        
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
        });
        
    });
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
    return [self.attributeCollection.attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLAttributeDataInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //NSLog(@"AttributeCollection: %@", self.attributeCollection);
    //NSLog(@"Attributes: %@", self.attributeCollection.attributes);
    
    NSOrderedSet *attributes = [self.attributeCollection.attributes copy];
    //NSLog(@"attributes: %@", attributes);
    
    if ([self.attributeCollection.attributes count] > indexPath.row)
    {
        SLAttribute *attribute = [attributes objectAtIndex:indexPath.row];
        [cell setAttribute: attribute];
    }
    else
    {
        NSLog(@"Attribute list is too short (%i) to handle request for objectAtIndex %i", [self.attributeCollection.attributes count], indexPath.row);
    }
    
    return cell;
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

@end
