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
@class Project;

@protocol PhotoViewControllerDelegate <NSObject>
- (void)photoViewControllerDidCancel:
(PhotoViewController *)controller;
- (void)photoViewControllerDidSave:
(PhotoViewController *)controller;
@end

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, PhotoEditViewControllerDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *swatchCollectionView;
@property (strong, nonatomic) Project *project;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

-(void)prepareChooser;

-(void)launchImageChooser:(BOOL)withCameraRoll;

@end
