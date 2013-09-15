//
//  UIImage+NSCoding.h
//  Draw2D
//
//  Created by Michael Lawrence on 7/1/12.
//  Copyright (c) 2012 Aurlaw Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NSCoding)
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end
