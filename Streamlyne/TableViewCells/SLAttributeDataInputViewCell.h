//
//  SLAttributeDataSubmitViewCell.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-28.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Streamlyne-Cocoa-SDK/SLAttribute.h>

@interface SLAttributeDataInputViewCell : UITableViewCell

@property (weak, nonatomic) SLAttribute *attribute;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *dataInputTextField;
@property (weak, nonatomic) IBOutlet UILabel *attributeDescriptionLabel;

@end
