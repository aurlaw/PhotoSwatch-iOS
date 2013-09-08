//
//  PhotoEditViewController.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/28/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFCropInterface.h"

@class PhotoEditViewController;

@protocol PhotoEditViewControllerDelegate <NSObject>
- (void)photoEditViewControllerDidCancel:(PhotoEditViewController *)controller;
- (void)photoEditViewControllerDidSave: (PhotoEditViewController *)controller withImage:(UIImage *)image;
@end


@interface PhotoEditViewController : UIViewController 

@property (nonatomic, weak) id <PhotoEditViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *editPhotoView;
@property (nonatomic, strong) BFCropInterface *cropper;


@property (strong, nonatomic) UIImage *selectedImage;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;


@end
