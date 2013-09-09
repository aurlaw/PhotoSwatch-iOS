//
//  PhotoViewController.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/22/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEditViewController.h"
@class PhotoViewController;

@protocol PhotoViewControllerDelegate <NSObject>
- (void)photoViewControllerDidCancel:
(PhotoViewController *)controller;
- (void)photoViewControllerDidSave:
(PhotoViewController *)controller;
@end

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, PhotoEditViewControllerDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) IBOutlet UICollectionView *swatchCollectionView;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
