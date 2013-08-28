//
//  PhotoViewController.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/22/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "PhotoViewController.h"

	//#import "LEColorPicker.h"
#import "SwatchProcessor.h"
#import "SVProgressHUD.h"

@interface PhotoViewController ()

@property bool hasLaunched;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIWebView *mainWebView;


@end

@implementation PhotoViewController

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if(self.hasLaunched == NO) {
	UIImagePickerController *mgPickerController = [[UIImagePickerController alloc] init];
    mgPickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    mgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mgPickerController.delegate = self;
	
	self.imagePickerController = mgPickerController;
	
		self.hasLaunched = YES;
		[self presentViewController:self.imagePickerController animated:YES completion:nil];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePicker delegates
	// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	
		// show HUD
		//+ (void)showWithStatus:(NSString*)string maskType:(SVProgressHUDMaskType)maskType;
	[SVProgressHUD showWithStatus:@"Processing Image..." maskType:SVProgressHUDMaskTypeBlack];
	
	
	[self.mainImage setImage:image];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
	
		//[[SwatchProcessor sharedManager] processWithImage:image];

	NSMutableString *str = [NSMutableString string];
	[[SwatchProcessor sharedManager] processWithImage:image withCompletetion:^(NSArray *arrColors) {
		AURLog("@Total Colors: %i", [arrColors count]);
		[arrColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				UIColor *c = obj;
				//AURLog(@"%i = Color: %@", idx, [c hexStringValue]);
			[str appendString:[NSString stringWithFormat:@"<span style=\"color:#%@\">%@</span><br>", [c hexStringValue], [c hexStringValue]]];
		}];
		[self.mainWebView loadHTMLString:str baseURL:nil];
			// dismiss
			//[SVProgressHUD dismiss];
		[SVProgressHUD showSuccessWithStatus:@"Completed"];
		AURLog(@"Dismiss HUD");
	}];
	
//	NSMutableArray *imgArr = [[NSMutableArray alloc] initWithCapacity:27];
//	
//	CGFloat w = image.size.width;
//	CGFloat h  = image.size.height;
//	
//	CGFloat secW = w / 3;
//	CGFloat secH = h / 3;
//	 
//	
//	CGImageRef tmpImgRef = image.CGImage;
//	
//		// top row
//	CGImageRef topLeftImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, 0, secW, secH));
//	UIImage *topLeftImage = [UIImage imageWithCGImage:topLeftImgRef];
//	[imgArr addObject:topLeftImage];
//	CGImageRelease(topLeftImgRef);
//
//	CGImageRef topCenterImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW, 0, secW, secH));
//	UIImage *topCenterImage = [UIImage imageWithCGImage:topCenterImgRef];
//	[imgArr addObject:topCenterImage];
//	CGImageRelease(topCenterImgRef);
//
//	CGImageRef topRightImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW + secW, 0, secW, secH));
//	UIImage *topRightImage = [UIImage imageWithCGImage:topRightImgRef];
//	[imgArr addObject:topRightImage];
//	CGImageRelease(topRightImgRef);
//	
//		// middle row
//	CGImageRef middleLeftImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, secH, secW, secH));
//	UIImage *middleLeftImage = [UIImage imageWithCGImage:middleLeftImgRef];
//	[imgArr addObject:middleLeftImage];
//	CGImageRelease(middleLeftImgRef);
//	
//	CGImageRef middleCenterImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW, secH, secW, secH));
//	UIImage *middleCenterImage = [UIImage imageWithCGImage:middleCenterImgRef];
//	[imgArr addObject:middleCenterImage];
//	CGImageRelease(middleCenterImgRef);
//	
//	CGImageRef middleRightImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW + secW, secH, secW, secH));
//	UIImage *middleRightImage = [UIImage imageWithCGImage:middleRightImgRef];
//	[imgArr addObject:middleRightImage];
//	CGImageRelease(middleRightImgRef);
//	
//		// bottom row
//	CGImageRef bottomLeftImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, secH, secW, secH));
//	UIImage *bottomLeftImage = [UIImage imageWithCGImage:bottomLeftImgRef];
//	[imgArr addObject:bottomLeftImage];
//	CGImageRelease(bottomLeftImgRef);
//	
//	CGImageRef bottomCenterImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW, secH, secW, secH));
//	UIImage *bottomCenterImage = [UIImage imageWithCGImage:bottomCenterImgRef];
//	[imgArr addObject:bottomCenterImage];
//	CGImageRelease(bottomCenterImgRef);
//	
//	CGImageRef bottomRightImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW + secW, secH, secW, secH));
//	UIImage *bottomRightImage = [UIImage imageWithCGImage:bottomRightImgRef];
//	[imgArr addObject:bottomRightImage];
//	CGImageRelease(bottomRightImgRef);
//	
//	
//	
//	
//	
//	LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
//	LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:image];
//
//	 self.view.backgroundColor = colorScheme.backgroundColor;
//	 self.mainText.textColor = colorScheme.primaryTextColor;
//	self.mainText.backgroundColor = colorScheme.backgroundColor;
//	 self.secondText.textColor = colorScheme.secondaryTextColor;
//	self.secondText.backgroundColor = colorScheme.backgroundColor;
//	
//	NSLog(@"Primary: %@", [colorScheme.primaryTextColor hexStringValue] );
//	NSLog(@"Background: %@", [colorScheme.backgroundColor hexStringValue] );
//	NSLog(@"Secondary: %@", [colorScheme.secondaryTextColor hexStringValue] );
//
//	NSLog(@"Using adv rule of thirds");
//	[imgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		UIImage *i = obj;
//		LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:i];
//
//		NSLog(@"%i = Primary: %@", idx, [colorScheme.primaryTextColor hexStringValue] );
//		NSLog(@"%i = Background: %@", idx, [colorScheme.backgroundColor hexStringValue] );
//		NSLog(@"%i = Secondary: %@", idx, [colorScheme.secondaryTextColor hexStringValue] );	}];
//	
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - Photo Controller delegate
- (IBAction)cancel:(id)sender
{
	[self.delegate photoViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate photoViewControllerDidSave:self];
}
@end
