//
//  SLActivityMenuViewController.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLActivityMenuViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeUserLabel;
- (IBAction)logoutBtnPressed:(id)sender;

@end
