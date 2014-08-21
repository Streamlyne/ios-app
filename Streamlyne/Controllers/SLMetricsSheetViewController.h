//
//  SLMetricsSheetViewController.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-23.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Streamlyne-Cocoa-SDK/SLAttributeCollection.h>

@interface SLMetricsSheetViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) SLAttributeCollection *attributeCollection;

@end
