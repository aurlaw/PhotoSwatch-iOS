//
//  PhotoViewController.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/22/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoViewController;

@protocol PhotoViewControllerDelegate <NSObject>
- (void)photoViewControllerDidCancel:
(PhotoViewController *)controller;
- (void)photoViewControllerDidSave:
(PhotoViewController *)controller;
@end

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
