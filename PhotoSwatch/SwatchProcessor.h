//
//  SwatchProcessor.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/27/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwatchProcessor : NSObject


+(id)sharedManager;

-(void)processWithImage:(UIImage *)image withCompletetion:(void (^)(NSArray* arrColors))completionBlock;


@end
