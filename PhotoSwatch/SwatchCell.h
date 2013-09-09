//
//  SwatchCell.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwatchCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *swatchColor;
@property (strong, nonatomic) IBOutlet UILabel *swatchTitle;

@end
