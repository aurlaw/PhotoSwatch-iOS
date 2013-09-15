//
//  SwatchProcessor.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/27/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "SwatchProcessor.h"

#import "LEColorPicker.h"
#import "AURColor.h"
#import "ColorMaster.h"

@interface SwatchProcessor(hidden)

	-(NSArray*)createColorsFromSchemeArray:(NSArray*)arrayOfScheme;
	-(NSArray*)createAURColorsFromColorArray:(NSArray*)arrayOfColor;
@end

@implementation SwatchProcessor


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

    }
    return self;
}
- (void)dealloc {
		//[super dealloc];
}


#pragma mark - Process
-(void)processWithImage:(UIImage *)image withCompletetion:(void (^)(NSArray* arrColors))completionBlock {
	
		// perform on bg thread
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		// create array to store image slidces using rule of thirds: 3 x 3 slices
		NSMutableArray *imgArr = [[NSMutableArray alloc] initWithCapacity:9];
		
		CGFloat w = image.size.width;
		CGFloat h  = image.size.height;
		
		CGFloat secW = w / 3;
		CGFloat secH = h / 3;
		
		
		CGImageRef tmpImgRef = image.CGImage;
		
			// top row
		CGImageRef topLeftImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, 0, secW, secH));
		UIImage *topLeftImage = [UIImage imageWithCGImage:topLeftImgRef];
		[imgArr addObject:topLeftImage];
		CGImageRelease(topLeftImgRef);
		
		CGImageRef topCenterImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW, 0, secW, secH));
		UIImage *topCenterImage = [UIImage imageWithCGImage:topCenterImgRef];
		[imgArr addObject:topCenterImage];
		CGImageRelease(topCenterImgRef);
		
		CGImageRef topRightImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW + secW, 0, secW, secH));
		UIImage *topRightImage = [UIImage imageWithCGImage:topRightImgRef];
		[imgArr addObject:topRightImage];
		CGImageRelease(topRightImgRef);
		
			// middle row
		CGImageRef middleLeftImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, secH, secW, secH));
		UIImage *middleLeftImage = [UIImage imageWithCGImage:middleLeftImgRef];
		[imgArr addObject:middleLeftImage];
		CGImageRelease(middleLeftImgRef);
		
		CGImageRef middleCenterImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW, secH, secW, secH));
		UIImage *middleCenterImage = [UIImage imageWithCGImage:middleCenterImgRef];
		[imgArr addObject:middleCenterImage];
		CGImageRelease(middleCenterImgRef);
		
		CGImageRef middleRightImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW + secW, secH, secW, secH));
		UIImage *middleRightImage = [UIImage imageWithCGImage:middleRightImgRef];
		[imgArr addObject:middleRightImage];
		CGImageRelease(middleRightImgRef);
		
			// bottom row
		CGImageRef bottomLeftImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(0, secH, secW, secH));
		UIImage *bottomLeftImage = [UIImage imageWithCGImage:bottomLeftImgRef];
		[imgArr addObject:bottomLeftImage];
		CGImageRelease(bottomLeftImgRef);
		
		CGImageRef bottomCenterImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW, secH, secW, secH));
		UIImage *bottomCenterImage = [UIImage imageWithCGImage:bottomCenterImgRef];
		[imgArr addObject:bottomCenterImage];
		CGImageRelease(bottomCenterImgRef);
		
		CGImageRef bottomRightImgRef = CGImageCreateWithImageInRect(tmpImgRef, CGRectMake(secW + secW, secH, secW, secH));
		UIImage *bottomRightImage = [UIImage imageWithCGImage:bottomRightImgRef];
		[imgArr addObject:bottomRightImage];
		CGImageRelease(bottomRightImgRef);
		
		
			// process each slide to get bg, primary and secondary colors - add to array
		LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
		LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:image];
		
//		
//		AURLog(@"Primary: %@", [colorScheme.primaryTextColor hexStringValue] );
//		AURLog(@"Background: %@", [colorScheme.backgroundColor hexStringValue] );
//		AURLog(@"Secondary: %@", [colorScheme.secondaryTextColor hexStringValue] );
//		
//		AURLog(@"Using adv rule of thirds");
		NSMutableArray *schemeArray = [[NSMutableArray alloc] init];
		
		[imgArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			UIImage *i = obj;
			LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:i];
			[schemeArray addObject:colorScheme];
//			AURLog(@"%i = Primary: %@", idx, [colorScheme.primaryTextColor hexStringValue] );
//			AURLog(@"%i = Background: %@", idx, [colorScheme.backgroundColor hexStringValue] );
//			AURLog(@"%i = Secondary: %@", idx, [colorScheme.secondaryTextColor hexStringValue] );
		}];
		
			// extract, remove dups and return just an array of distinct UIColors
		NSArray *arr = [self createColorsFromSchemeArray:schemeArray];
			// create AURcolor array based on color master list
		NSArray *cmArr = [self createAURColorsFromColorArray:arr];
		if(completionBlock != Nil) completionBlock(cmArr);
			//if (completionBlock != nil) completionBlock(loginSuccessful);
//		[arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//				UIColor *c = obj;
//			AURLog(@"%i = Color: %@", idx, [c hexStringValue]);
//		}];
	 });
}

-(NSArray*)createColorsFromSchemeArray:(NSArray*)arrayOfScheme {
	NSMutableArray *newArry = [NSMutableArray array];
	[arrayOfScheme enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		LEColorScheme *scheme = obj;
		if(![newArry containsObject:scheme.backgroundColor]) {
			[newArry addObject:scheme.backgroundColor];
		}
		if(![newArry containsObject:scheme.primaryTextColor]) {
			[newArry addObject:scheme.primaryTextColor];
		}
		if(![newArry containsObject:scheme.secondaryTextColor]) {
			[newArry addObject:scheme.secondaryTextColor];
		}
	}];
	
	return newArry;
	
}
-(NSArray*)createAURColorsFromColorArray:(NSArray*)arrayOfColor {
	NSMutableArray *newArry = [NSMutableArray array];
	NSArray *arrColors = [[ColorMaster sharedManager] getColorMaster];
		// lookup arr of UICOlors against color master
	[arrayOfColor enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIColor *color = obj;
		AURColor *ac = nil;
		BOOL isFound = NO;
		AURLog(@"Check: %@", [color hexStringValue]);
		for (AURColor *a in arrColors) {
//			AURLog(@"Colormaster: %@", a.hex);
//			AURLog(@"Processed: %@", [color hexStringValue]);
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
			ac.name = ac.hex;
		}
		[newArry addObject:ac];
	}];
	return newArry;
}



@end
