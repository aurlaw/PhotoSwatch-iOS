//
//  ColorMaster.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/13/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "DAO.h"

@interface ColorMaster : DAO {
	NSArray *colorList;
}

+(id)sharedManager;

-(NSArray *)getColorMaster;

@end
