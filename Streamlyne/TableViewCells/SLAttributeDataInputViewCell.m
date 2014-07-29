//
//  SLAttributeDataSubmitViewCell.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-28.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLAttributeDataInputViewCell.h"

@implementation SLAttributeDataInputViewCell

@synthesize assetNameLabel, assetDescriptionLabel, dataInputTextField, attributeDescriptionLabel, attribute = _attribute;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (id)initWithCoder:(NSCoder *)encoder
{
    self = [super initWithCoder:encoder];
    if (self) {
    }
    return self;
}

- (void) layoutSubviews
{
    [[self superclass] layerClass];
    
    NSLog(@"layoutSubviews: %@", self.attribute);
    if (self.attribute != nil)
    {
        self.attributeDescriptionLabel.text = _attribute.name;
        self.assetNameLabel.text = _attribute.assetName;
        self.assetDescriptionLabel.text = _attribute.desc;
    }
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

- (void) setAttribute:(SLAttribute *)attribute
{
    // Remove original bindings
    
    // Switch to new attribute
    _attribute = attribute;
    NSLog(@"Attribute: %@", attribute);
    // Bind to new attribute
    [RACObserve(attribute, desc) subscribeNext:^(NSString *description)
     {
         NSLog(@"Description: %@", description);
         self.attributeDescriptionLabel.text = description;
     }];
    
    
    [RACObserve(attribute, assetName) subscribeNext:^(NSString *assetName)
     {
         NSLog(@"assetName: %@", assetName);
         self.assetNameLabel.text = assetName;
     }];
    
    
    [RACObserve(attribute, name) subscribeNext:^(NSString *name)
     {
         NSLog(@"name: %@", name);
         self.assetDescriptionLabel.text = name;
     }];
    
}

@end
