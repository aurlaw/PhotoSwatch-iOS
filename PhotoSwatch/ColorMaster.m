//
//  ColorMaster.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/13/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//
#import "DAO.h"
#import "ColorMaster.h"

#import "AURColor.h"
#include "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

//@interface ColorMaster(hidden)
//
//	@property (nonatomic, strong) NSArray *colorList;
//@end


@implementation ColorMaster


#pragma mark -
#pragma mark Singleton Methods
+ (id)sharedManager {
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (id)init {
    if ((self = [super init])) {
		colorList = [[NSArray alloc] init];
    }
    return self;
}
- (void)dealloc {
		//[super dealloc];
}

#pragma mark - DB Methods
 
-(NSArray *)getColorMaster {
	if(colorList.count == 0) {
		NSMutableArray *tem = [[NSMutableArray alloc] init];
		FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DAO databaseFilePath]];

		[queue inDatabase:^(FMDatabase *db) {
			 FMResultSet *rs = [db executeQuery:@"select name, hex from color_master"];
			 while ([rs next]) {
				 AURColor *ac = [AURColor new];
				 ac.name = [rs stringForColumn:@"name"];
				 ac.hex = [rs stringForColumn:@"hex"];
				 [tem addObject:ac];
			 }
		 }];
		colorList = tem;
	}

	return colorList;
}

@end
