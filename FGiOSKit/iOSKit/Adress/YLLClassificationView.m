//
//  YLLClassificationView.m
//  yulala
//
//  Created by 李俊宇 on 2018/12/11.
//  Copyright © 2018年 YangWeiCong. All rights reserved.
//

#import "YLLClassificationView.h"
#import "FGCellStyleView.h"

@implementation YLLItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self setupLayout];
    }
    return self;
}

- (void)setupViews{
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = UIColorFromHex(0x000000);
    self.titleLabel.font = AdaptedFontSize(17);
    [self addSubview:self.titleLabel];
    
    self.chooseIV = [UIImageView new];
    [self addSubview:self.chooseIV];
    
}

- (void)setupLayout{
    [self.chooseIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(AdaptedWidth(19));
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(21), AdaptedWidth(21)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseIV.mas_centerY);
        make.left.equalTo(self.chooseIV.mas_right).offset(AdaptedWidth(19));
    }];
}

@end

@interface YLLClassificationView()

@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,copy)NSString *leftNorImage;
@property (nonatomic,copy)NSString *leftSelImage;
@property (nonatomic, assign) NSInteger num;  ///< <#Description#>

@end

@implementation YLLClassificationView

- (instancetype)initWithTitles:(NSArray <NSString *>*)titles leftNorImage:(NSString *)leftNorImage leftSelImage:(NSString *)leftSelImage tag:(NSInteger)tag
{
    if (self = [super init]) {
        self.titles = titles;
        self.leftNorImage = leftNorImage;
        self.leftSelImage = leftSelImage;
        self.num = tag;
        
        [self setupViews];
    }
    return self;
}

+ (instancetype)classificationViewTitles:(NSArray <NSString *>*)titles leftNorImage:(NSString *)leftNorImage leftSelImage:(NSString *)leftSelImage tag:(NSInteger)tag{
    
    return [[self alloc]initWithTitles:titles leftNorImage:leftNorImage leftSelImage:leftSelImage tag:tag];
}

- (void)setupViews{
    
    
    self.backgroundColor = UIColorFromHex(0xFFFFFF);
    
    
    for (NSInteger i = 0; i < self.titles.count; i++ ) {
        YLLItemView *itemView = [YLLItemView new];
        
        itemView.tag = i;
        
        
        itemView.titleLabel.text = self.titles[i];
        itemView.chooseIV.image = UIImageWithName(self.leftNorImage);
//        [itemView setTouchDownTarget:self action:@selector(PayAction:)];
        [itemView addTarget:self action:@selector(PayAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemView];
        
        
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(i * AdaptedHeight(53));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(AdaptedHeight(53));
            
            if (i == self.titles.count-1) {
                make.bottom.offset(0);
            }
        }];
        
        
        if (i != self.titles.count-1) {
            [itemView addBottomLineWithEdge:UIEdgeInsetsMake(0, AdaptedWidth(15), 0, 0)];
        }
        
        
        if (i == self.num) {
            [self PayAction:itemView];
        }
        //默认选择第一个
//        if (i == 0) {
//            [self PayAction:itemView];
//        }
    }
    
}


- (void)PayAction:(YLLItemView *)itemView{
    
    BOOL sel = YES;
    if(self.callBackType)
    {
        if(itemView.chooseIV.image == UIImageWithName(self.leftSelImage)){
            sel = NO;
            self.callBackType(-1);
        }else{
            self.callBackType(itemView.tag);
        }
    }
    
    for (UIView *subView in self.subviews) {
        if ([subView isMemberOfClass:[YLLItemView class]]) {
            YLLItemView *itemView = (YLLItemView *)subView;
            itemView.chooseIV.image = UIImageWithName(self.leftNorImage);
        }
    }
    
    if (sel) {
        itemView.chooseIV.image = UIImageWithName(self.leftSelImage);
    }
    
}



- (void)setCancalAll:(BOOL)cancalAll{
    
    for (YLLItemView *itemView in self.subviews) {
        itemView.chooseIV.image = UIImageWithName(self.leftNorImage);
    }
}


@end
