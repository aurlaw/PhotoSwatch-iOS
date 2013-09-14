//
//  DAO.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/13/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "DAO.h"

@interface DAO()

	//-(void) copyDatabaseIfNeeded;

@end

@implementation DAO

	//@synthesize dbFile;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}


#pragma mark -
#pragma mark Database File Methods

+(NSString *) databaseFilePath {
		//Using NSFileManager we can perform many file system operations.
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
    
		// check for container folder, create if it does not exist
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	
	NSString *tempdbPath = [documentsDir stringByAppendingPathComponent:@"/photoswatch"];
    
	BOOL success = [fileManager fileExistsAtPath:tempdbPath];
    
	
	if(!success) {
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database/photoswatch.sqlite"];
        
        AURLog(@"Copy file %@", defaultDBPath);
        AURLog(@"To file %@", tempdbPath);
        
		success = [fileManager copyItemAtPath:defaultDBPath toPath:tempdbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		
	}
	return tempdbPath;
		//	AURLog(@"returning %@", self.dbFile);
}

@end
