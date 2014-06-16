//
//  Project.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"

typedef void(^SaveImageCompletion)(NSURL* assetURL, NSError* error);
@interface Project : DAO
{
	NSURL *imageFileName;
}

@property  NSUInteger projectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *swatchesArray;
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *dateModified;

-(void)saveProject;
-(void)deleteProject;
	//-(void)addSwatches:(NSArray *)arr;

+(NSArray*)getAllProjects;


@end
