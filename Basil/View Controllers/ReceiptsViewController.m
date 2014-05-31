//
//  ReceiptsViewController.m
//  Basil
//
//  Created by Stephanie Szeto on 5/30/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "ReceiptsViewController.h"

@interface ReceiptsViewController ()

@end

@implementation ReceiptsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Receipts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
