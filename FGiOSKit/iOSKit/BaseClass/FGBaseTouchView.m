//
//  FGBaseTouchView.m
//  jingpai
//
//  Created by qiuxiaofeng on 2018/5/30.
//  Copyright © 2018年 JP. All rights reserved.
//

#import "FGBaseTouchView.h"

@implementation FGBaseTouchView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setHighlighted: (BOOL) highlighted
{
    [super setHighlighted: highlighted];
    
    self.backgroundColor = highlighted ?UIColorFromHexWithAlpha(0x000000, 0.05) : [UIColor whiteColor];
}


@end
