//
//  HXBaseNavigationBar.m
//  newHfax
//
//  Created by lly on 2017/9/27.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXBaseNavigationBar.h"
#import "HXUIDefines.h"
#import <Masonry/Masonry.h>
#import "UILabel+Factory.h"

@interface HXBaseNavigationBar (){
    BOOL _isButtonActioning;
}
@property (nonatomic,strong,readwrite) UIView *bgView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong,readwrite) UILabel *titleLabel;

@end

@implementation HXBaseNavigationBar

- (instancetype)initWithHeight:(CGFloat)height viewController:(__kindof HXBaseViewController *)vc{
    if(self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, height)]){
        _vc = vc;
        _bgView = [[UIView alloc]initWithFrame:self.bounds];
        _bgView.backgroundColor = HXThemeColor;
        [self addSubview:_bgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.backBtn];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20+IphoneXStateHeight);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
        }];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
    }
    return self;
}

+ (instancetype)defaultNavigationBarWithHeight:(CGFloat)height viewController:(UIViewController<HXBaseNavigationDelegate> *)vc hideBottomLine:(BOOL)hide{
    HXBaseNavigationBar *navgationBar = [[HXBaseNavigationBar alloc]initWithHeight:height viewController:vc];
    navgationBar.backgroundColor = [UIColor whiteColor];
    navgationBar.titleLabel.textColor = [UIColor blackColor];
    [navgationBar.backBtn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    if (!hide) {
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, ScreenWidth, 0.5)];
        bottomLine.backgroundColor = [UIColor blackColor];
        bottomLine.alpha = 0.2;
        [navgationBar addSubview:bottomLine];
    }
    return navgationBar;
}
#pragma mark - getter and setter
- (void)setAlpha:(CGFloat)alpha{
    self.bgView.alpha = alpha;
    self.titleLabel.alpha = alpha;
    //    self.hidden = (alpha<0);
}

- (void)setShowBackBtn:(BOOL)showBackBtn{
    _showBackBtn = showBackBtn;
    self.backBtn.hidden = !_showBackBtn;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel newWithFont:HXFont(17) textColor:[UIColor whiteColor]];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [_backBtn setImage:[UIImage imageNamed:@"wealth_backButton"] forState:UIControlStateNormal];
        [_backBtn addTarget:_vc action:@selector(backToLastController:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = true;
        _backBtn.userInteractionEnabled = YES;
    }
    return _backBtn;
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (UIButton *)navigationButtonWithImageStr:(NSString *)imageStr tag:(NSInteger)tag{
    UIButton *setingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setingBtn.tag = tag;
    [setingBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [setingBtn addTarget:self action:@selector(navgationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return setingBtn;
}

- (UIButton *)navigationButtonWithBackImageString:(NSString *)imageStr title:(NSString *)title tag:(NSInteger)tag{
    UIButton *setingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setingBtn.tag = tag;
    [setingBtn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [setingBtn addTarget:self action:@selector(navgationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [setingBtn setTitle:title forState:UIControlStateNormal];
    [setingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setingBtn.titleLabel.font = HXBoldFont(11);
    return setingBtn;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _bgView.backgroundColor = backgroundColor;
}

- (void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor = titleColor;
}

- (UILabel *)unReadLabel{
    if(!_unReadLabel){
        _unReadLabel = [UILabel newWithFont:HXBoldFont(10) textColor:[UIColor redColor]];
        _unReadLabel.backgroundColor = UIColorFromRGB(0xfde803);
        _unReadLabel.textAlignment = NSTextAlignmentCenter;
        _unReadLabel.layer.masksToBounds = YES;
        _unReadLabel.layer.cornerRadius = 6.5;
        _unReadLabel.frame = CGRectMake(13, 0, 13, 13);
    }
    return _unReadLabel;
}

- (void)setUnReadMsgCount:(long)unReadCount{
    [_unReadLabel removeFromSuperview];
    if(unReadCount<=0){
        return;
    }else{
        [self addUnreadLabel];
        NSString *text = @(unReadCount).stringValue;
        if(unReadCount<10){
            _unReadLabel.font = HXBoldFont(9);
        }else if (unReadCount<99){
            _unReadLabel.font = HXBoldFont(8);
        }else{
            text = @"99+";
            _unReadLabel.font = HXBoldFont(6);
        }
        _unReadLabel.text = text;
    }
}

- (void)addUnreadLabel{
//    [self.msgBtn addSubview:self.unReadLabel];
}

#pragma mark - action
- (void)navgationButtonAction:(UIButton *)sender{
   
}

@end
