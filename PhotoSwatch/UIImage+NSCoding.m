//
//  UIImage+NSCoding.m
//  Draw2D
//
//  Created by Michael Lawrence on 7/1/12.
//  Copyright (c) 2012 Aurlaw Solutions. All rights reserved.
//

#import "UIImage+NSCoding.h"


@implementation UIImage (NSCoding)
- (id)initWithCoder:(NSCoder *)decoder {
	NSData *pngData = [decoder decodeObjectForKey:@"PNGRepresentation"];
		//	[self autorelease];
	self = [[UIImage alloc] initWithData:pngData];
	return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:UIImagePNGRepresentation(self) forKey:@"PNGRepresentation"];
}
@end