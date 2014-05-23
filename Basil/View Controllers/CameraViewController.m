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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up views
    self.buttonBox.layer.cornerRadius = 20;
    self.buttonBox.layer.borderWidth = 1;
    self.buttonBox.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.takePhotoButton.tintColor = [UIColor whiteColor];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device has no camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self onTakePhotoButton:self];
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
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = img;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
