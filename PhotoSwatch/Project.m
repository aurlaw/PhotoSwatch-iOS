//
//  Project.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "Project.h"


#import "DAO.h"
#include "ColorMaster.h"
#import "AURColor.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

@interface Project (hidden)

@end

@implementation Project

@synthesize projectId, name, image, dateCreated, dateModified, image_name, swatchesArray;


- (id)init {
    if ((self = [super init])) {
			//self.swatchesArray = [[NSMutableArray alloc] init];
		self.swatchesArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dealloc {
	self.swatchesArray = nil;
	self.image = nil;
}

-(void)addSwatches:(NSArray *)arr {
	NSArray *arrColors = [[ColorMaster sharedManager] getColorMaster];
		// lookup arr of UICOlors against color master
	[arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIColor *color = obj;
		AURColor *ac = nil;
		BOOL isFound = NO;
		for (AURColor *a in arrColors) {
			if([a.hex isEqualToString:[color hexStringValue]]) {
				ac = a;
				ac.color = color;
				isFound = YES;
				break;
			}
		}
		if(isFound == NO) {
			ac = [AURColor new];
			ac.hex = [color hexStringValue];
			ac.color = color;
			ac.name = @"";
		}
		[self.swatchesArray addObject:ac];
	}];
	
}

#pragma mark - DB: Save & Delete
/*
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "name" TEXT NOT NULL , "image_name" TEXT NOT NULL , "color_data" BLOB NOT NULL, "date_created" DATETIME NOT NULL,  "date_modified" DATETIME NOT NULL ) */
-(void)saveProject {
	AURLog(@"Saving: %@", self.name);
	
		// extract UIColor and convert to NSData for storing in SQLite as serialized data
//	NSMutableArray *colorArr = [[NSMutableArray alloc] initWithCapacity:self.swatchesArray.count];
//	[self.swatchesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		AURColor *ac = obj;
//		[colorArr addObject:ac.color];
//	}];
	NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: self.swatchesArray];
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DAO databaseFilePath]];
	if(self.projectId == 0) {
		 NSString *sqlStatement = @"INSERT INTO projects(name, image_name, color_data, date_created, date_modified) VALUES(?, ?, ?, 'now', 'now')";
		
			//
		[queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
			[db executeUpdate:sqlStatement, self.name, self.image_name, colorData, self.projectId];
			FMResultSet *rs = [db executeQuery:@"SELECT last_insert_rowid() FROM projects"];
			while ([rs next]) {
				self.projectId = (NSUInteger)[rs intForColumnIndex:0];
			}
		}];
	} else {
		NSString *sqlStatement = @"UPDATE projects SET name = ?, image_name = ?, color_data = ?, date_modified = 'now' WHERE id = ?)";
		
		[queue inDatabase:^(FMDatabase *db) {
			[db executeUpdate:sqlStatement, self.name, self.image_name, colorData, self.projectId];
		}];
		
	}
}

-(void)deleteProject {
	AURLog(@"Deleting: %@", self.name);
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DAO databaseFilePath]];
	[queue inDatabase:^(FMDatabase *db) {
		NSString *sqlStatement = @"DELETE FROM projects WHERE id = ?)";
		
		[queue inDatabase:^(FMDatabase *db) {
			[db executeUpdate:sqlStatement, self.projectId];
		}];

	}];

}

#pragma mark - Static
/*
 CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "name" TEXT NOT NULL , "image_name" TEXT NOT NULL , "color_data" BLOB NOT NULL, "date_created" DATETIME NOT NULL,  "date_modified" DATETIME NOT NULL ) */

+(NSArray*)getAllProjects {
	NSMutableArray *list = [[NSMutableArray alloc] init];
	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DAO databaseFilePath]];
	[queue inDatabase:^(FMDatabase *db) {
		FMResultSet *rs = [db executeQuery:@"select id, name, image_name, color_data, date_created, date_modified from projects"];
		while ([rs next]) {
			Project *p = [Project new];
			p.projectId = [rs intForColumn:@"id"];
			p.name = [rs stringForColumn:@"name"];
			p.image_name = [rs stringForColumn:@"image_name"];
			NSData *colorData = [rs dataForColumn:@"color_data"];
			p.swatchesArray = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
			p.dateCreated = [rs dateForColumn:@"date_created"];
			p.dateModified = [rs dateForColumn:@"date_modified"];
			[list addObject:p];
		}
	}];

	return list;
}


@end
