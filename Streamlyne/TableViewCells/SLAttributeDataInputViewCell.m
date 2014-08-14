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
    // Switch to new attribute
    _attribute = attribute;
    NSLog(@"Set Attribute: %@", attribute);
    
    // Bind to new attribute
    [RACObserve(self.attribute, desc) subscribeNext:^(NSString *description)
     {
         NSLog(@"Description: %@", description);
         self.attributeDescriptionLabel.text = description;
     }];
    
    attribute.asset.then(^(SLAsset *asset) {
        DDLogInfo(@"Attribute's Asset: %@", asset);
        
        [RACObserve(asset, humanName) subscribeNext:^(NSString *assetName)
         {
             NSLog(@"assetName: %@", assetName);
             self.assetNameLabel.text = assetName;
         }];
        
        [RACObserve(asset, desc) subscribeNext:^(NSString *description)
         {
             NSLog(@"description: %@", description);
             self.assetDescriptionLabel.text = description;
         }];
    });
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    DDLogInfo(@"textFieldShouldReturn");
    
    // Get the value
    NSString *valStr = dataInputTextField.text;
    NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:valStr];
    DDLogInfo(@"Value: %@", val);
    
    if (val == [NSDecimalNumber notANumber])
    {
        return NO;
    }
    [textField resignFirstResponder];
    
    // Create
    SLAttributeDatum *attributeDatum = [SLAttributeDatum createRecord:@{
                                                                        @"value": val
                                                                        }];
    // Associate the Attribute to the AttributeDatum
    attributeDatum.attribute = _attribute;
    // Set the initial meta data dates
    attributeDatum.dateCreated = [NSDate new];
    attributeDatum.dateUpdated = [NSDate new];
    DDLogInfo(@"Attribute: %@", _attribute);
    DDLogInfo(@"AttributeDatum: %@", attributeDatum);
    // Save
    [attributeDatum save]
    .then(^(SLAttributeDatum *attributeDatum) {
        NSLog(@"Datum: %@", attributeDatum);
        textField.text = @""; // Clear input field
    })
    .catch(^(NSError *error){
        NSLog(@"%@", error);
    });
    return YES;
}

@end
