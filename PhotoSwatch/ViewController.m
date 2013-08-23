//
//  ViewController.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/18/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PhotoController"])
	{
		PhotoViewController *photoViewController = segue.destinationViewController;
		photoViewController.delegate = self;
	}
}

#pragma mark - Action Sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
			//Tweet Image
	}
	if (buttonIndex == 0)
	{
			//Save Image
	}
}

- (IBAction)doChooser:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Camera Roll", @"Tweet it!", @"Cancel", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Photo Controller delegate
-(void)photoViewControllerDidSave:(PhotoViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)photoViewControllerDidCancel:(PhotoViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
	
}
@end
