//
//  Project.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAO.h"

@interface Project : DAO
{
}
@property  NSUInteger projectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *image_name;
@property (strong, nonatomic) NSMutableArray *swatchesArray;
@property (strong, nonatomic) NSDate *dateCreated;
@property (strong, nonatomic) NSDate *dateModified;

-(void)saveProject;
-(void)deleteProject;
-(void)addSwatchs:(NSArray *)arr;

+(NSArray*)getAllProjects;


@end
