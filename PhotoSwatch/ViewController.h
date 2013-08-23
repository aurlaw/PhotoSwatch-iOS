//
//  ViewController.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/18/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewController.h"


@interface ViewController : UIViewController <UIActionSheetDelegate, PhotoViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *photoChooser;
- (IBAction)doChooser:(id)sender;

@end
