//
//  SLLoginViewController.h
//  Streamlyne
//
//  Created by Glavin Wiechert on 2014-07-09.
//  Copyright (c) 2014 Streamlyne Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *organizationTextField;

@end
