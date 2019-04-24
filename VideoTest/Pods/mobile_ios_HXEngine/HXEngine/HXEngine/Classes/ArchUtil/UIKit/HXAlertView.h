//
//  HXAlertView.h
//  newHfax
//
//  Created by sh on 2017/7/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "ModalView.h"
#import "UIKitMacros.h"

@interface HXAlertView : ModalView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIView *contenView; // 中间需要覆盖的view


@property (nonatomic, strong) UIFont *cancleAndSureFont;
@property (nonatomic, strong) UIColor *cancelBtnColor;
@property (nonatomic, strong) UIColor *confirmBtnColor;

@property (nonatomic, assign) BOOL confirmBtnEnable; //
@property (nonatomic, assign) BOOL confirmCompleteDismiss; //

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      content:(NSString *)content
                  cancelTitle:(NSString *)cancelTitle
                 confirmTitle:(NSString *)confirmTitle
                  cancelBlock:(CompletionBlock)cancelBlock
                 confirmBlock:(CompletionBlock)confirmBlock;

- (void)resetContentView;
- (void)configParas;

@end
