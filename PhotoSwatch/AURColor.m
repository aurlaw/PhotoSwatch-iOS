//
//  AURColor.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/13/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "AURColor.h"

@implementation AURColor

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject: self.name forKey: @"name"];
	[aCoder encodeObject: self.hex forKey: @"hex"];
	[aCoder encodeObject: self.color forKey:@"color"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [self init]))
	{
		self.name = [aDecoder decodeObjectForKey: @"name"];
		self.hex = [aDecoder decodeObjectForKey: @"hex"];
		self.color = [aDecoder decodeObjectForKey: @"color"];
	}
	return self;
}

@synthesize name, hex, color;
@end
