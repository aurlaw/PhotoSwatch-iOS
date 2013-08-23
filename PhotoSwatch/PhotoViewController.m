//
//  PhotoViewController.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/22/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender
{
	[self.delegate photoViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate photoViewControllerDidSave:self];
}
@end
