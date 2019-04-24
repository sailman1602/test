//
//  HXAlertView.m
//  newHfax
//
//  Created by sh on 2017/7/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXAlertView.h"
#import "UIView+Util.h"
#import "UIView+Factory.h"
#import <Masonry/Masonry.h>
#import "UIButton+Property.h"
#import "UILabel+Factory.h"
#import "UIButton+Factory.h"
#import "HXUIDefines.h"

@interface HXAlertView()

@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation HXAlertView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      content:(NSString *)content
                  cancelTitle:(NSString *)cancelTitle
                 confirmTitle:(NSString *)confirmTitle
                  cancelBlock:(CompletionBlock)cancelBlock
                 confirmBlock:(CompletionBlock)confirmBlock{
    
    self = [super initWithFrame:frame level:kModalViewLevelAlert];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dissmissOnBackgroundTap = YES;
        
        _titleLabel = [UILabel newWithText:title font:[UIFont systemFontOfSize:16] textColor:RGBCOLOR_HEX(0x333333)];
        [_titleLabel sizeToFit];
        _titleLabel.top = 18;
        _titleLabel.centerX = self.width / 2;
        [self addSubview:_titleLabel];
        
        [self addSubview:self.contenView];
        
        [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self setBottomViewWithCancelTitle:cancelTitle confirmTitle:confirmTitle needTitleColor:NO cancelBlock:cancelBlock confirmBlock:confirmBlock];
        [self cySetCornerRadius:4];
        [self resetContentView];
        [self configParas];
        
    }
    return self;
}


- (void)setBottomViewWithCancelTitle:(NSString *)cancelTitle
                        confirmTitle:(NSString *)confirmTitle
                      needTitleColor:(BOOL)flag
                         cancelBlock:(CompletionBlock)cancelBlock
                        confirmBlock:(CompletionBlock)confirmBlock{

    UIView *midLine = [UIView fc_viewWithFrame:CGRectZero backColor:RGBCOLOR_HEX(0xd5d5d5)];
    midLine.bottom = self.frame.size.height - 45;
    midLine.width = self.width;
    midLine.height = 1;
    [self addSubview:midLine];
    
    // 控件初始化
    WEAK_VAR(self);
    _cancleBtn = [UIButton newWithFrame:CGRectZero title:(cancelTitle ? cancelTitle : @"取消") font:16 titleColor:flag ? RGBCOLOR_HEX(0xb2b2b2) : RGBCOLOR_HEX(0x3996F2)];
    [_cancleBtn setBackgroundNormalColor:RGBCOLOR_HEX(0xffffff) highLight:RGBCOLOR_HEX(0xffffff)];
    [_cancleBtn addTapGestureWithActionBlock:^(UIGestureRecognizer *gestrue) {
        [_self dismiss];
        safe_block(cancelBlock);
    }];
    [self addSubview:_cancleBtn];

    
    UIView *line = [UIView fc_viewWithFrame:CGRectZero backColor:RGBCOLOR_HEX(0xd5d5d5)];
    [self addSubview:line];

    _confirmBtn = [UIButton newWithFrame:CGRectZero title:(confirmTitle ? confirmTitle : @"确定") font:16 titleColor:flag ? RGBCOLOR_HEX(0xf24637) : RGBCOLOR_HEX(0x3996F2)];
    _confirmBtn.titleLabel.font = HXBoldFont(15);
    [_confirmBtn setTitleColor:HXFontAssistColor forState:UIControlStateDisabled];
    [_confirmBtn setBackgroundNormalColor:RGBCOLOR_HEX(0xffffff) highLight:RGBCOLOR_HEX(0xffffff)];
    [_confirmBtn addTapGestureWithActionBlock:^(UIGestureRecognizer *gestrue) {
        safe_block(confirmBlock);
        if (!_self.confirmCompleteDismiss) {
            [_self dismiss];
        }
    }];
    [self addSubview:_confirmBtn];
    
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.width - 1) * 0.5);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(_cancleBtn.mas_right);
    }];
//
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.width - 1) * 0.5);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(line.mas_right);
    }];
    
}

- (void)show{
    [super show];
    if (self.titleColor) {
        _titleLabel.textColor = self.titleColor;
    }
    if (self.titleFont) {
        _titleLabel.font = self.titleFont;
    }
    if (self.cancelBtnColor) {
        [_cancleBtn setTitleColor:self.cancelBtnColor forState:UIControlStateNormal];
    }
    if (self.confirmBtnColor) {
        [_confirmBtn setTitleColor:self.confirmBtnColor forState:UIControlStateNormal];
    }
}

- (void)setConfirmBtnEnable:(BOOL)confirmBtnEnable {
    _confirmBtnEnable = confirmBtnEnable;
    self.confirmBtn.enabled = confirmBtnEnable;
    if (confirmBtnEnable) {
        [_confirmBtn setTitleColor:RGBCOLOR_HEX(0xf24637) forState:UIControlStateNormal];
    }else {
        [_confirmBtn setTitleColor:HXFontAssistColor forState:UIControlStateDisabled];
    }
}


#pragma mark - 用于override

- (void)resetContentView {}
- (void)configParas {}

- (UIView *)contenView {
    if (_contenView == nil) {
        _contenView = [UIView fc_viewWithFrame:CGRectZero backColor:[UIColor whiteColor]];
    }
    return _contenView;
}

@end
