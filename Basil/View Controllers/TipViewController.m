//
//  TipViewController.m
//  Basil
//
//  Created by Stephanie Szeto on 5/14/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UIButton *splitBillButton;
@property (weak, nonatomic) IBOutlet UIStepper *personControl;

@property (weak, nonatomic) IBOutlet UITextField *subtotal;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *perPersonTotal;
@property (weak, nonatomic) IBOutlet UILabel *perPersonLabel;

@property (nonatomic, assign) BOOL showTotal;

- (IBAction)onSplitBillButton:(id)sender;
- (IBAction)onStepper:(id)sender;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
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
    
    // set first responder
    //[self.subtotal becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.subtotal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set coloring - main color is #16A085
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIColor *greenColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
    UIColor *whiteColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = greenColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : whiteColor};
    self.view.backgroundColor = greenColor;
    self.subtotal.backgroundColor = [UIColor clearColor];
    
    // set all text coloring white
    self.subtotal.textColor = whiteColor;
    self.tipControl.tintColor = whiteColor;
    self.tip.textColor = whiteColor;
    self.total.textColor = whiteColor;
    self.perPersonTotal.textColor = whiteColor;
    self.subtotalLabel.textColor = whiteColor;
    self.tipLabel.textColor = whiteColor;
    self.totalLabel.textColor = whiteColor;
    self.perPersonLabel.textColor = whiteColor;
    self.personLabel.textColor = whiteColor;
    self.personControl.tintColor = whiteColor;
    
    // set up navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    self.navigationItem.rightBarButtonItem.tintColor = whiteColor;
    
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
    self.total.text = zero;
    self.perPersonTotal.text = zero;
    
    // set up scroll view
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize = CGSizeMake(320,600);
    [scrollView addSubview:self.subtotal];
    [scrollView addSubview:self.tipControl];
    [scrollView addSubview:self.tip];
    [scrollView addSubview:self.total];
    [scrollView addSubview:self.perPersonTotal];
    [scrollView addSubview:self.subtotalLabel];
    [scrollView addSubview:self.tipLabel];
    [scrollView addSubview:self.totalLabel];
    [scrollView addSubview:self.perPersonLabel];
    [scrollView addSubview:self.personLabel];
    [scrollView addSubview:self.splitBillButton];
    [scrollView addSubview:self.personControl];
    [self.view addSubview:scrollView];
    
    // by default, hide per person options
    self.showTotal = NO;
    [self onSplitBillButton:self];
}

//- (void)loadView {
//    // set up scroll view
//    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
//    scrollView.contentSize=CGSizeMake(320,758);
//    
//    // add components to view
//    [scrollView addSubview:self.subtotal];
//    [scrollView addSubview:self.tipControl];
//    [scrollView addSubview:self.tip];
//    [scrollView addSubview:self.onePersonTotal];
//    [scrollView addSubview:self.twoPersonTotal];
//    [scrollView addSubview:self.threePersonTotal];
//    [scrollView addSubview:self.fourPersonTotal];
//    [scrollView addSubview:self.onePersonIcon];
//    [scrollView addSubview:self.twoPersonIcon];
//    [scrollView addSubview:self.threePersonIcon];
//    [scrollView addSubview:self.fourPersonIcon];
//    [scrollView addSubview:self.onePersonLabel];
//    [scrollView addSubview:self.twoPersonLabel];
//    [scrollView addSubview:self.threePersonLabel];
//    [scrollView addSubview:self.fourPersonLabel];
//    
//    self.view = scrollView;
//}

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
    
    int numPeople = (int) self.personControl.value;
    float multiplePersonTotal;
    if (numPeople) {
        multiplePersonTotal = (onePersonTotal / numPeople);
    } else {
        multiplePersonTotal = onePersonTotal;
    }
    
    self.tip.text = [NSString stringWithFormat:@"$%0.2f", tip];
    self.total.text = [NSString stringWithFormat:@"$%0.2f", onePersonTotal];
    self.perPersonTotal.text = [NSString stringWithFormat:@"$%0.2f", multiplePersonTotal];
}

- (IBAction)onSplitBillButton:(id)sender {
    if (self.showTotal) {
        [self.personLabel setHidden:NO];
        [self.perPersonTotal setHidden:NO];
        [self.perPersonLabel setHidden:NO];
        [self.personControl setHidden:NO];
    
        [self.total setHidden:YES];
        [self.totalLabel setHidden:YES];
    } else {
        [self.total setHidden:NO];
        [self.totalLabel setHidden:NO];
        
        [self.personLabel setHidden:YES];
        [self.perPersonTotal setHidden:YES];
        [self.perPersonLabel setHidden:YES];
        [self.personControl setHidden:YES];
    }
    
    self.showTotal = !self.showTotal;
}

- (IBAction)onStepper:(id)sender {
    int numPeople = (int) self.personControl.value;
    if (numPeople == 1) {
        self.personLabel.text = [NSString stringWithFormat:@"%d PERSON", numPeople];
    } else {
        self.personLabel.text = [NSString stringWithFormat:@"%d PEOPLE", numPeople];
    }
    
    [self updateValues];
}

- (void)onSettingsButton {
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:svc animated:NO];
}

@end
