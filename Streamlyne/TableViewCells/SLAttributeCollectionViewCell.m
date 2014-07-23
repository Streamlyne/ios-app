//
//  SLAttributeCollectionViewCell.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-23.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLAttributeCollectionViewCell.h"

@implementation SLAttributeCollectionViewCell

@synthesize nameLabel, descriptionLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
