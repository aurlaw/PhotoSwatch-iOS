//
//  Project.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property  NSUInteger *projectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *swatchesArray;

@end
