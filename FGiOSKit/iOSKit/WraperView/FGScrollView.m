//
//  ICScrollView.m
//  ichezhidao
//
//  Created by qiuxiaofeng on 16/7/8.
//  Copyright © 2016年 figo. All rights reserved.
//

#import "FGScrollView.h"

@implementation FGScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.alwaysBounceVertical = YES;
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            //必须要约束宽度
            make.width.equalTo(self.mas_width);
//            make.height.equalTo(self.mas_height).priorityLow();
        }];
    }
    return self;
}

@end
