//
//  FGInsetsLabel.m
//  quanminyuanchuang
//
//  Created by Eric on 2018/8/20.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//

#import "FGInsetsLabel.h"

@implementation FGInsetsLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setEdgeInsets:(CGPoint)edgeInsets{
    _edgeInsets = edgeInsets;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect r = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    return CGRectInset(r, -_edgeInsets.x, -_edgeInsets.y);
}

@end
