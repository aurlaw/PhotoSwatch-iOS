//
//  SwatchCell.m
//  PhotoSwatch
//
//  Created by Michael Lawrence on 9/8/13.
//  Copyright (c) 2013 Michael Lawrence. All rights reserved.
//

#import "SwatchCell.h"

@implementation SwatchCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setSwatchColor:(UIColor *)swatchColor {
	
    if(_swatchColor != swatchColor) {
        _swatchColor = swatchColor;
    }
	AURLog(@"Set swatch");
	self.swatchTitle.text = [_swatchColor hexStringValue];
	self.backgroundColor = _swatchColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
