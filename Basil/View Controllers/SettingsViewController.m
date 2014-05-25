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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // update default tip control, custom percentage fields with values if they already exist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"tipPercentInts"]) {
        NSArray *tipPercentInts = [defaults objectForKey:@"tipPercentInts"];
        [self.defaultTipControl setTitle:[NSString stringWithFormat:@"%@%%", tipPercentInts[0]] forSegmentAtIndex:0];
        [self.defaultTipControl setTitle:[NSString stringWithFormat:@"%@%%", tipPercentInts[1]] forSegmentAtIndex:1];
        [self.defaultTipControl setTitle:[NSString stringWithFormat:@"%@%%", tipPercentInts[2]] forSegmentAtIndex:2];
        
        self.customTip1.text = [tipPercentInts[0] stringValue];
        self.customTip2.text = [tipPercentInts[1] stringValue];
        self.customTip3.text = [tipPercentInts[2] stringValue];
    }
    
    // update default tip index if it already exists
    NSInteger defaultIndex = [defaults integerForKey:@"defaultTipIndex"];
    if (defaultIndex) {
        self.defaultTipControl.selectedSegmentIndex = defaultIndex;
    }
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
    [defaults synchronize];
}

- (void)onViewTap:(id)sender {
    [self.view endEditing:YES];
    
    // first, convert to integer
    NSInteger customTip1 = [self.customTip1.text integerValue];
    NSInteger customTip2 = [self.customTip2.text integerValue];
    NSInteger customTip3 = [self.customTip3.text integerValue];

    // validate values
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoa there!"
                                                    message:@"Percentages must be less than 100."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    if (customTip1 > 100 || customTip2 > 100 || customTip3 > 100) {
        [alert show];
    } else {
        // update tip control array
        float customPercentage1 = customTip1 / 100.0f;
        float customPercentage2 = customTip2 / 100.0f;
        float customPercentage3 = customTip3 / 100.0f;
        NSArray *tipPercentFloats = @[@(customPercentage1), @(customPercentage2), @(customPercentage3)];
        NSArray *tipPercentInts = @[@(customTip1), @(customTip2), @(customTip3)];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tipPercentFloats forKey:@"tipPercentFloats"];
        [defaults setObject:tipPercentInts forKey:@"tipPercentInts"];
        [defaults synchronize];
        
        // update values in defaultTipControl
        [self.defaultTipControl setTitle:[NSString stringWithFormat:@"%d%%", customTip1] forSegmentAtIndex:0];
        [self.defaultTipControl setTitle:[NSString stringWithFormat:@"%d%%", customTip2] forSegmentAtIndex:1];
        [self.defaultTipControl setTitle:[NSString stringWithFormat:@"%d%%", customTip3] forSegmentAtIndex:2];
    }
}

@end
