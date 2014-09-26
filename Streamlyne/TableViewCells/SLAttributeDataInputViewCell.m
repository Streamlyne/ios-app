//
//  SLAttributeDataSubmitViewCell.m
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-28.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import "SLAttributeDataInputViewCell.h"
#import "MBProgressHUD.h"

@implementation SLAttributeDataInputViewCell

@synthesize assetNameLabel, assetDescriptionLabel, dataInputTextField, attributeDescriptionLabel,
attributeNameLabel,
attribute = _attribute;

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
    
    // Reset UI
    self.assetNameLabel.text = @"Loading Asset Name...";
    if (self.assetDescriptionLabel != nil)
    {
        self.assetDescriptionLabel.text = @"Loading Asset Description...";
    }
    self.attributeNameLabel.text = @"Loading Attribute Name...";
    if (self.attributeDescriptionLabel != nil)
    {
        self.attributeDescriptionLabel.text = @"Loading Attribute Description...";
    }
    
    
    // Bind to new attribute
    if (self.attributeDescriptionLabel != nil)
    {
        [RACObserve(self.attribute, desc) subscribeNext:^(NSString *description)
         {
             NSLog(@"Description: %@", description);
             self.attributeDescriptionLabel.text = description;
         }];
    }
    [RACObserve(self.attribute, humanName) subscribeNext:^(NSString *humanName)
     {
         NSLog(@"Attribute humanName: %@", humanName);
//         self.attributeNameLabel.text = humanName;
     }];

    [RACObserve(self.attribute, name) subscribeNext:^(NSString *name)
     {
         NSLog(@"Name: %@", name);
         self.attributeNameLabel.text = name;
     }];
    
    attribute.asset.then(^(SLAsset *asset) {
        DDLogInfo(@"Attribute's Asset: %@", asset);

        [RACObserve(asset, name) subscribeNext:^(NSString *assetName)
         {
             NSLog(@"assetName: %@", assetName);
             self.assetNameLabel.text = assetName;
         }];

        [RACObserve(asset, humanName) subscribeNext:^(NSString *assetHumanName)
         {
             NSLog(@"assetHumanName: %@", assetHumanName);
//             self.assetNameLabel.text = assetHumanName;
         }];
        
        if (self.assetDescriptionLabel != nil)
        {
            [RACObserve(asset, desc) subscribeNext:^(NSString *description)
             {
                 NSLog(@"description: %@", description);
                 self.assetDescriptionLabel.text = description;
             }];
        }
    });

    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
        });
    });
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    DDLogInfo(@"textFieldShouldReturn");
    
    // Show progress spinner
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Sending";
    
    // Get the value
    NSString *valStr = dataInputTextField.text;
    NSDecimalNumber *val = [NSDecimalNumber decimalNumberWithString:valStr];
    DDLogInfo(@"Value: %@", val);
    
    if (val == [NSDecimalNumber notANumber])
    {
        [hud hide:YES];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                           message:@"Input must be a number."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        textField.text = @""; // Clear input field
        return NO;
    }
    [textField resignFirstResponder];
    
    // Create
    DDLogInfo(@"_Attribute: %@", _attribute);
    PMKPromise *promise = [SLAttributeDatum createRecord:@{
                                                                        @"value": val
                                                                        }];
    
    promise.then(^(SLAttributeDatum *attributeDatum) {
        
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
            [hud hide:YES];
        })
        .catch(^(NSError *error){
            NSLog(@"%@", error);
            [hud hide:YES];
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                               message:error.localizedRecoverySuggestion
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            textField.text = @""; // Clear input field

        });
    });
    
    return YES;
}

@end
