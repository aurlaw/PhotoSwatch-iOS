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

@synthesize delegate, selectedImage;

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
	
    self.selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
	
		// show HUD
		//+ (void)showWithStatus:(NSString*)string maskType:(SVProgressHUDMaskType)maskType;
	
	[self dismissViewControllerAnimated:YES completion:NULL];
	
	[self performSegueWithIdentifier:@"PhotoEditController" sender:self];
	
			
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PhotoEditController"])
	{
			//		PhotoViewController *photoViewController = segue.destinationViewController;
			//		photoViewController.delegate = self;
		
//		UINavigationController *navigationController = segue.destinationViewController;
		PhotoEditViewController *editController  = segue.destinationViewController;
		editController.delegate = self;
		editController.selectedImage = self.selectedImage;
		/*
		 PhotoEditViewController *editController = [[PhotoEditViewController alloc] init];
		 editController.delegate = self;
		 editController.selectedImage = image;
		 [self.navigationController pushViewController:editController animated:YES];
		 
		 */
		
	}
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

#pragma mark - Photo Edit controller delegate
-(void)photoEditViewControllerDidCancel:(PhotoEditViewController *)controller {
	
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)photoEditViewControllerDidSave:(PhotoEditViewController *)controller withImage:(UIImage *)image {
	
	[self.mainImage setImage:image];
	
	[self.navigationController popViewControllerAnimated:YES];
	
	
	[SVProgressHUD showWithStatus:@"Processing Image..." maskType:SVProgressHUDMaskTypeBlack];


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

				[SVProgressHUD showSuccessWithStatus:@"Completed"];
				AURLog(@"Dismiss HUD");
			}];

	
}

@end
