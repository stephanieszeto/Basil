//
//  TipViewController.m
//  Basil
//
//  Created by Stephanie Szeto on 5/14/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *subtotal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UILabel *onePersonTotal;
@property (weak, nonatomic) IBOutlet UILabel *twoPersonTotal;
@property (weak, nonatomic) IBOutlet UILabel *threePersonTotal;
@property (weak, nonatomic) IBOutlet UILabel *fourPersonTotal;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set default tip percentage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tipControl.selectedSegmentIndex = [defaults integerForKey:@"defaultTipIndex"];
    
    // set tip percentages in tip control
    NSArray *tipPercentInts = [defaults objectForKey:@"tipPercentInts"];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%@%%", tipPercentInts[0]] forSegmentAtIndex:0];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%@%%", tipPercentInts[1]] forSegmentAtIndex:1];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%@%%", tipPercentInts[2]] forSegmentAtIndex:2];
    
    // recalculate tip
    [self updateValues];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.subtotal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // coloring
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIColor *greenColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
    UIColor *whiteColor = [UIColor whiteColor];
    self.view.backgroundColor = greenColor;
    self.subtotal.backgroundColor = [UIColor clearColor];
    self.subtotal.textColor = whiteColor;
    self.tipControl.tintColor = whiteColor;
    self.tip.textColor = whiteColor;
    self.onePersonTotal.textColor = whiteColor;
    self.twoPersonTotal.textColor = whiteColor;
    self.threePersonTotal.textColor = whiteColor;
    self.fourPersonTotal.textColor = whiteColor;
    
    UIColor *lightGreenColor = [UIColor colorWithRed:1/255.0f green:171/255.0f blue:156/255.0f alpha:1.0f];
    self.tabBarController.tabBar.tintColor = whiteColor;
    self.tabBarController.tabBar.barTintColor = greenColor;
    
    // set up subtotal
    self.subtotal.borderStyle = UITextBorderStyleNone;
    CGRect frame = self.subtotal.frame;
    frame.size.height = 100;
    self.subtotal.frame = frame;
    UITapGestureRecognizer *viewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    [self.view addGestureRecognizer:viewGestureRecognizer];
    
    // set up tip control
    [self.tipControl addTarget:self action:@selector(onTipTap:) forControlEvents: UIControlEventValueChanged];
    
    // set up initial values
    NSString *zero = @"$0.00";
    self.tip.text = zero;
    self.onePersonTotal.text = zero;
    self.twoPersonTotal.text = zero;
    self.threePersonTotal.text = zero;
    self.fourPersonTotal.text = zero;
    
    // set up navigation items
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark - Private methods

- (void)onViewTap:(UITapGestureRecognizer *)viewGestureRecognizer {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)onTipTap:(UITapGestureRecognizer *)tipGestureRecognizer {
    [self updateValues];
}

- (void)textFieldDidChange:(id)sender {
    [self updateValues];
}

- (void)updateValues {
    float subtotal = [self.subtotal.text floatValue];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tipPercentages = [defaults objectForKey:@"tipPercentFloats"];
    float tip = subtotal * [tipPercentages[self.tipControl.selectedSegmentIndex] floatValue];
    float onePersonTotal = tip + subtotal;
    float twoPersonTotal = (onePersonTotal / 2);
    float threePersonTotal = (onePersonTotal / 3);
    float fourPersonTotal = (onePersonTotal / 4);
    
    self.tip.text = [NSString stringWithFormat:@"$%0.2f", tip];
    self.onePersonTotal.text = [NSString stringWithFormat:@"$%0.2f", onePersonTotal];
    self.twoPersonTotal.text = [NSString stringWithFormat:@"$%0.2f", twoPersonTotal];
    self.threePersonTotal.text = [NSString stringWithFormat:@"$%0.2f", threePersonTotal];
    self.fourPersonTotal.text = [NSString stringWithFormat:@"$%0.2f", fourPersonTotal];
}

@end
