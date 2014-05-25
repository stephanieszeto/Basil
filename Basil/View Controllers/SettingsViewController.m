//
//  SettingsViewController.m
//  Basil
//
//  Created by Stephanie Szeto on 5/15/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;
@property (weak, nonatomic) IBOutlet UITextField *customTip1;
@property (weak, nonatomic) IBOutlet UITextField *customTip2;
@property (weak, nonatomic) IBOutlet UITextField *customTip3;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set up coloring
    UIColor *greenColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
    //self.view.backgroundColor = greenColor;
    self.defaultTipControl.tintColor = greenColor;
    self.customTip1.layer.borderColor = [greenColor CGColor];
    self.customTip2.layer.borderColor = [greenColor CGColor];
    self.customTip3.layer.borderColor = [greenColor CGColor];
    self.customTip1.layer.borderWidth = 1.0f;
    self.customTip2.layer.borderWidth = 1.0f;
    self.customTip3.layer.borderWidth = 1.0f;
    self.customTip1.textColor = greenColor;
    self.customTip2.textColor = greenColor;
    self.customTip3.textColor = greenColor;
    
    // set up default tip control
    [self.defaultTipControl addTarget:self action:@selector(onDefaultControlTap:) forControlEvents:UIControlEventValueChanged];
    
    // set up custom tip fields
    UITapGestureRecognizer *viewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    [self.view addGestureRecognizer:viewGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)onDefaultControlTap:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultTipControl.selectedSegmentIndex forKey:@"defaultTipIndex"];
}

- (void)onViewTap:(id)sender {
    [self.view endEditing:YES];
}

@end
