//
//  PhotoEditViewController.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/28/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "PhotoEditViewController.h"

#import "SPUserResizableView.h"

@interface PhotoEditViewController ()


@property CGRect gripFrame;
@property (nonatomic, strong) SPUserResizableView *userResizableView;
-(void)addCropOverlay;

@end

@implementation PhotoEditViewController

@synthesize delegate, selectedImage;

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
	
		// create view the same size as our photo
	CGSize imageSize = self.editPhotoView.image.size;
	CGFloat imageScale = fminf(CGRectGetWidth(self.editPhotoView.bounds)/imageSize.width, CGRectGetHeight(self.editPhotoView.bounds)/imageSize.height);
	CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
	self.gripFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(self.editPhotoView.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(self.editPhotoView.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
	
	AURLog(@"wxh: %f x %f", self.gripFrame.size.width, self.gripFrame.size.height);
	AURLog(@"x/y: %f/%f", self.gripFrame.origin.x, self.gripFrame.origin.y);
	
    self.userResizableView = [[SPUserResizableView alloc] initWithFrame:self.gripFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:self.gripFrame];
    [contentView setBackgroundColor:[UIColor clearColor]];
    self.userResizableView.contentView = contentView;
    self.userResizableView.delegate = self;
    [self.userResizableView showEditingHandles];
//    currentlyEditingView = userResizableView;
//    lastEditedView = userResizableView;
    [self.view addSubview:self.userResizableView];
	
//		// add black translucent overlay
//	CGRect overlayFrame = self.editPhotoView.frame;
//    UIView *overView = [[UIView alloc] initWithFrame:overlayFrame];
//    [overView setBackgroundColor:[UIColor blackColor]];
//	overView.alpha = 0.75f;
//	[self.view addSubview:overView];
	
	/*
	 CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	 CGRect maskRect = CGRectMake(0, 0, 50, 100);
	 
	 // Create a path with the rectangle in it.
	 CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
	 
	 // Set the path to the mask layer.
	 maskLayer.path = path;
	 
	 // Release the path since it's not covered by ARC.
	 CGPathRelease(path);
	 
	 // Set the mask of the view.
	 viewToMask.layer.mask = maskLayer;
	 
	 */
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
	AURLog(@"Original Image");
	AURLog(@"wxh: %f x %f", self.selectedImage.size.width, self.selectedImage.size.height);
	AURLog(@"UIIMane View");
	AURLog(@"wxh: %f x %f", self.gripFrame.size.width, self.gripFrame.size.height);
	AURLog(@"x/y: %f/%f", self.gripFrame.origin.x, self.gripFrame.origin.y);
	
	AURLog(@"Resize View");
	AURLog(@"wxh: %f x %f", self.userResizableView.frame.size.width, self.userResizableView.frame.size.height);
	AURLog(@"x/y: %f/%f", self.userResizableView.frame.origin.x, self.userResizableView.frame.origin.y);

		// compare UImage size with UIImageViewSize size to get the ratio
	CGFloat widthRatio = self.selectedImage.size.width / self.gripFrame.size.width;
	CGFloat heightRatio = self.selectedImage.size.height / self.gripFrame.size.height;
		// calculate Resize View size and origin based on ratio
	CGFloat cropWidth = self.userResizableView.frame.size.width * widthRatio;
	CGFloat cropHeight = self.userResizableView.frame.size.height * heightRatio;
	CGFloat cropX = self.userResizableView.frame.origin.x * widthRatio;
	CGFloat cropY = self.userResizableView.frame.origin.y * heightRatio;
	
		// perform crop
	AURLog(@"Cropped Image");
	AURLog(@"wxh: %f x %f", cropWidth, cropHeight);
	AURLog(@"x/y: %f/%f", cropX, cropY);
	
	CGImageRef tmpImgRef = self.selectedImage.CGImage;

	CGImageRef cropImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(cropX, cropY, cropWidth, cropHeight));
	UIImage *croppedImage = [UIImage imageWithCGImage:cropImgRef];
	CGImageRelease(cropImgRef);

	[delegate photoEditViewControllerDidSave:self withImage:croppedImage];
}

#pragma mark - Crop Overlay
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
//    [currentlyEditingView hideEditingHandles];
//    currentlyEditingView = userResizableView;
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
//    lastEditedView = userResizableView;
//	CGPoint pointInSubview = userResizableView.frame.origin;
//	if (CGRectContainsPoint(self.gripFrame, pointInSubview)) {
//		AURLog("@All Good...");
//	} else {
//		AURLog("@Outside...");
//	}
	
//	AURLog(@"wxh: %f x %f", userResizableView.frame.size.width, userResizableView.frame.size.height);
//	AURLog(@"x/y: %f/%f", userResizableView.frame.origin.x, userResizableView.frame.origin.y);


}

@end
