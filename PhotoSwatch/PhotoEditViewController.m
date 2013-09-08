//
//  PhotoEditViewController.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/28/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "PhotoEditViewController.h"

#import "BFCropInterface.h"

@interface PhotoEditViewController ()


-(void)addCropOverlay;

@end

@implementation PhotoEditViewController

@synthesize delegate, selectedImage, cropper;

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
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	AURLog(@"Load Image");
	
	if(self.selectedImage != nil) {
		[self.editPhotoView setImage:self.selectedImage];
		[self addCropOverlay];
		AURLog(@"Loaded Image");
	}

}

-(void)addCropOverlay {
	self.editPhotoView.userInteractionEnabled = YES;

	    // allocate crop interface with frame and image being cropped
    self.cropper = [[BFCropInterface alloc]initWithFrame:self.editPhotoView.bounds andImage:self.selectedImage];
		// this is the default color even if you don't set it
    self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
		// white is the default border color.
    self.cropper.borderColor = [UIColor photoSwatchSecondaryColor];
		// add interface to superview. here we are covering the main image view.
    [self.editPhotoView addSubview:self.cropper];

	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Photo Controller delegate
- (IBAction)cancel:(id)sender
{

	[delegate photoEditViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
//	AURLog(@"Original Image");
//	AURLog(@"wxh: %f x %f", self.selectedImage.size.width, self.selectedImage.size.height);
//	AURLog(@"UIIMane View");
//	AURLog(@"wxh: %f x %f", self.gripFrame.size.width, self.gripFrame.size.height);
//	AURLog(@"x/y: %f/%f", self.gripFrame.origin.x, self.gripFrame.origin.y);
//	
//	AURLog(@"Resize View");
//	AURLog(@"wxh: %f x %f", self.userResizableView.frame.size.width, self.userResizableView.frame.size.height);
//	AURLog(@"x/y: %f/%f", self.userResizableView.frame.origin.x, self.userResizableView.frame.origin.y);
//
//		// compare UImage size with UIImageViewSize size to get the ratio
//	CGFloat widthRatio = self.selectedImage.size.width / self.gripFrame.size.width;
//	CGFloat heightRatio = self.selectedImage.size.height / self.gripFrame.size.height;
//		// calculate Resize View size and origin based on ratio
//	CGFloat cropWidth = self.userResizableView.frame.size.width * widthRatio;
//	CGFloat cropHeight = self.userResizableView.frame.size.height * heightRatio;
//	CGFloat cropX = self.userResizableView.frame.origin.x * widthRatio;
//	CGFloat cropY = self.userResizableView.frame.origin.y * heightRatio;
//	
//		// perform crop
//	AURLog(@"Cropped Image");
//	AURLog(@"wxh: %f x %f", cropWidth, cropHeight);
//	AURLog(@"x/y: %f/%f", cropX, cropY);
//	
//	CGImageRef tmpImgRef = self.selectedImage.CGImage;
//
//	CGImageRef cropImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(cropX, cropY, cropWidth, cropHeight));
//	UIImage *croppedImage = [UIImage imageWithCGImage:cropImgRef];
//	CGImageRelease(cropImgRef);
//
	UIImage *croppedImage = [self.cropper getCroppedImage];

	[delegate photoEditViewControllerDidSave:self withImage:croppedImage];
}

#pragma mark - Crop Overlay


@end
