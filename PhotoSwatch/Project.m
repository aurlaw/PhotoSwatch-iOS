//
//  Project.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize projectId, name, image, swatchesArray;


- (id)init {
    if ((self = [super init])) {
		self.swatchesArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dealloc {
	self.swatchesArray = nil;
	self.image = nil;
}


@end
