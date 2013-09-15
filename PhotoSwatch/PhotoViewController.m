//
//  PhotoViewController.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/22/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "PhotoViewController.h"

#import "SwatchProcessor.h"
#import "SVProgressHUD.h"
#import "SwatchCell.h"
#import "Project.h"
#import "AURColor.h"

@interface PhotoViewController ()

@property bool hasLaunched;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIImageView *projectImage;
@property (strong, nonatomic) IBOutlet UITextField *projectName;

	//@property (strong, nonatomic) NSArray *swatchArr;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation PhotoViewController

@synthesize delegate, selectedImage, project;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_texture"]];

	if(!self.project) {
		self.project = [Project new];
	}
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
	
	[self dismissViewControllerAnimated:YES completion:NULL];
	
	[self performSegueWithIdentifier:@"PhotoEditController" sender:self];
	
			
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PhotoEditController"])
	{

		PhotoEditViewController *editController  = segue.destinationViewController;
		editController.delegate = self;
		editController.selectedImage = self.selectedImage;
	}
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - UICollectionView Datasource
	// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	AURLog(@"Total Count: %i", [self.project.swatchesArray count]);
	return [self.project.swatchesArray count];
}
	// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
	// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if(self.project.swatchesArray.count > 0 && indexPath.row == 0) {
			//[SVProgressHUD showSuccessWithStatus:@"Completed"];
		[SVProgressHUD dismiss];
		AURLog(@"Dismiss HUD");
		
	}
	AURLog(@"Create cell for index %i", indexPath.row);
	SwatchCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SwatchCell" forIndexPath:indexPath];
	
	AURColor *swatch = self.project.swatchesArray[indexPath.row];
	cell.swatchColor = swatch;
	AURLog(@"Set cell with %@", swatch.hex);

    return cell;
}

#pragma mark - Collection View delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
		// TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
		// TODO: Deselect item
}
#pragma mark – UICollectionViewDelegateFlowLayout

	// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
//    self.searchResults[searchTerm][indexPath.row];
//		// 2
//    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
//    retval.height += 35; retval.width += 35; return retval;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat w = (screenRect.size.width / 3) - 20;
	return CGSizeMake(w, 100);
}

	// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
		//    return UIEdgeInsetsMake(50, 20, 50, 20);

    return UIEdgeInsetsMake(20, 20, 20, 20);
}


#pragma mark - Photo Controller delegate
- (IBAction)cancel:(id)sender
{
	[self.delegate photoViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
		//----this will process the button function if the textfield is not empty
	if(![self.projectName.text isEqualToString:@""])
	{
		
		AURLog(@"Project Name: %@", self.projectName.text);
		self.project.name = self.projectName.text;
			//TODO Save Project to DB
		[self.project saveProject];
		[self.delegate photoViewControllerDidSave:self];

	}
	else
	{
			//----this will show an alert message when the user tries to click button without filling the textfield

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error", nil)
														message:NSLocalizedString(@"Please enter Project Name", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Ok", nil)
											  otherButtonTitles:nil];
		[alert show];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Photo Edit controller delegate
-(void)photoEditViewControllerDidCancel:(PhotoEditViewController *)controller {
	
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)photoEditViewControllerDidSave:(PhotoEditViewController *)controller withImage:(UIImage *)image {
	
	self.project.image = image;
	[self.projectImage setImage:image];
	
	[self.navigationController popViewControllerAnimated:YES];
	
	
	[SVProgressHUD showWithStatus:@"Processing Image..." maskType:SVProgressHUDMaskTypeBlack];


		[[SwatchProcessor sharedManager] processWithImage:image withCompletetion:^(NSArray *arrColors) {
			AURLog(@"Total Colors: %i", [arrColors count]);
			self.project.swatchesArray = arrColors;
			[self.swatchCollectionView reloadData];
		}];
}

@end
