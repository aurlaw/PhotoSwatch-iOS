//
//  AURCommonUtils.h
//  PhotoSwatch
//
//  Created by Michael Lawrence on 8/27/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifdef DEBUG
#	define AURLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define AURLogCall FAFLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#	define AURLog(...)
#endif

	// ALog always displays output regardless of the DEBUG setting
#define AURLogAlways(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)
#define DEGREES_TO_RADIANS(__ANGLE__) ((float)M_PI * (__ANGLE__) / 180.0f)
