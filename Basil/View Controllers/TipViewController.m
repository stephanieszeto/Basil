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
@property (weak, nonatomic) IBOutlet UILabel *multiplePersonTotal;
@property (weak, nonatomic) IBOutlet UITextField *multiplePerson;

@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *perPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;

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

    // set coloring - main color is #16A085
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIColor *greenColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
    UIColor *whiteColor = [UIColor whiteColor];
    self.view.backgroundColor = greenColor;
    self.subtotal.backgroundColor = [UIColor clearColor];
    self.tabBarController.tabBar.tintColor = whiteColor;
    self.tabBarController.tabBar.barTintColor = greenColor;
    
    // set all text coloring white
    self.subtotal.textColor = whiteColor;
    self.tipControl.tintColor = whiteColor;
    self.tip.textColor = whiteColor;
    self.onePersonTotal.textColor = whiteColor;
    self.multiplePersonTotal.textColor = whiteColor;
    self.subtotalLabel.textColor = whiteColor;
    self.tipLabel.textColor = whiteColor;
    self.totalLabel.textColor = whiteColor;
    self.perPersonLabel.textColor = whiteColor;
    self.personLabel.textColor = whiteColor;
    
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
    self.multiplePersonTotal.text = zero;
    
    // set up scroll view
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize = CGSizeMake(320,700);
    [scrollView addSubview:self.subtotal];
    [scrollView addSubview:self.tipControl];
    [scrollView addSubview:self.tip];
    [scrollView addSubview:self.onePersonTotal];
    [scrollView addSubview:self.multiplePersonTotal];
    [scrollView addSubview:self.multiplePerson];
    [scrollView addSubview:self.subtotalLabel];
    [scrollView addSubview:self.tipLabel];
    [scrollView addSubview:self.totalLabel];
    [scrollView addSubview:self.perPersonLabel];
    [scrollView addSubview:self.personLabel];
    [self.view addSubview:scrollView];
    
    // by default, hide per person options
    [self.multiplePerson setHidden:YES];
    [self.personLabel setHidden:YES];
    [self.multiplePersonTotal setHidden:YES];
    [self.perPersonLabel setHidden:YES];
    
    // set up navigation items
    self.navigationController.navigationBarHidden = YES;
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
    
    NSInteger multiplePerson = [self.multiplePerson.text integerValue];
    float multiplePersonTotal;
    if (multiplePerson) {
        multiplePersonTotal = (onePersonTotal / multiplePerson);
    } else {
        multiplePersonTotal = onePersonTotal;
    }
    
    self.tip.text = [NSString stringWithFormat:@"$%0.2f", tip];
    self.onePersonTotal.text = [NSString stringWithFormat:@"$%0.2f", onePersonTotal];
    self.multiplePersonTotal.text = [NSString stringWithFormat:@"$%0.2f", multiplePersonTotal];
}

@end
