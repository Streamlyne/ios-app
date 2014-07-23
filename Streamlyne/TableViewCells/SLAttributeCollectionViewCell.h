//
//  SLAttributeCollectionViewCell.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-23.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLAttributeCollectionViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
