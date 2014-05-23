//
//  CameraViewController.m
//  Basil
//
//  Created by Stephanie Szeto on 5/21/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *buttonBox;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

- (IBAction)onTakePhotoButton:(id)sender;

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Receipt";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up views
    self.buttonBox.layer.cornerRadius = 20;
    self.buttonBox.layer.borderWidth = 1;
    
    // set up coloring
        UIColor *greenColor = [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1.0f];
    self.takePhotoButton.tintColor = greenColor;
    self.buttonBox.layer.borderColor = [greenColor CGColor];
    
    // set up navigation items
    self.navigationController.navigationBarHidden = YES;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device has no camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    } 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTakePhotoButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerCameraDeviceFront;
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}

# pragma mark - Image picker methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // button settings
    [self.takePhotoButton setTitle:@"Retake Photo" forState:UIControlStateNormal];
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = img;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
