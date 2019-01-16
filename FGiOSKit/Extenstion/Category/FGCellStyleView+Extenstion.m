//
//  FGCellStyleView+Extenstion.m
//  yulala
//
//  Created by Eric on 2018/11/5.
//  Copyright © 2018 YangWeiCong. All rights reserved.
//

#import "FGCellStyleView+Extenstion.h"

@implementation FGCellStyleView (Extenstion)

- (void)setBackgroundColorWithUnit:(NSString *)unit
{
    UITextField *textField = self.textFeild;
    if (!IsEmpty(textField)) {
        UITextField *textField = self.textFeild;
        
        //光标右移 16像素
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AdaptedWidth(16), kOnePixel)];
        
        textField.backgroundColor = UIColorFromHex(0xf9f9f9);
        [textField fg_cornerRadius:3 borderWidth:kOnePixel borderColor:0xdddddd];
        [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.top.offset(AdaptedWidth(8));
            make.left.offset(AdaptedWidth(112));
            make.right.offset(AdaptedWidth(-16));
        }];
        
        if (!IsEmpty(unit)) {
            NSString *title = [NSString stringWithFormat:@"  %@",unit];
            UILabel *label = [UILabel fg_text:title fontSize:16 colorHex:0x333333];
            label.frame = CGRectMake(0, 0, 40, 40);
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.rightView = label;
        }
    }
}

@end
