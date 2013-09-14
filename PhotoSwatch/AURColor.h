//
//  AURColor.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/13/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AURColor : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *hex;
@property (nonatomic, strong) UIColor *color;

@end
