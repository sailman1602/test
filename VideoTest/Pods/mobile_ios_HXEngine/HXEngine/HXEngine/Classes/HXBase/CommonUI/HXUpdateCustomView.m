//
//  HXUpdateCustomView.m
//  newHfax
//
//  Created by 张驰 on 2017/11/17.
//  Copyright © 2017年 hfax. All rights reserved.
//
#define ContentViewHeight (self.isBigVersionUpdate?343:270)
#import "HXUpdateCustomView.h"
#if COCOAPODS_USE_FRAMEWORK
#import <TYAlertController_lly/UIView+TYAlertView.h>
#elif COCOAPODS
#import "UIView+TYAlertView.h"
#else
#import <TYAlertController/UIView+TYAlertView.h>
#endif
#import <Masonry/Masonry.h>
#import "HXUIDefines.h"
#import "UIColor+Factory.h"
#import "UILabel+Factory.h"
#import "UIButton+Factory.h"
#import "UIImage+Factory.h"

@interface HXUpdateCustomView()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *versionLabel;
@property (nonatomic,strong) UITextView *mesageTextView;
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UIButton *updateButton;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *bannerImage;
@property (nonatomic,assign) BOOL isBigVersionUpdate;
@property (nonatomic,assign) BOOL isForceUpdate;

@end
@implementation HXUpdateCustomView
-(instancetype)initWithSubTitle:(NSString *)subTitle message:(NSString *)message isForceUpdate:(BOOL)isForceUpdate isBigVersionUpdate:(BOOL)isBigVersionUpdate{
    if (self=[super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.isForceUpdate = isForceUpdate;
        self.isBigVersionUpdate = isBigVersionUpdate;
        self.frame = CGRectMake(0, 0, 260, ContentViewHeight+100);
        [self setUpCustomViews];
        [self configureSubTitle:subTitle message:message];
        
    }
    return self;
}
-(void)setUpCustomViews{
    [self addSubview:self.contentView];
    if (_isBigVersionUpdate) {
        [self.contentView addSubview:self.bannerImage];
        [self.bannerImage addSubview:self.titleLabel];
        [self.bannerImage addSubview:self.versionLabel];
    }else{
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.versionLabel];
        [self.contentView addSubview:self.line];
    }
    [self.contentView addSubview:self.mesageTextView];
    [self.contentView addSubview:self.updateButton];
    [self.contentView addSubview:self.tipsLabel];
    [self addSubview:self.closeButton];
    if (_isForceUpdate) {
        self.closeButton.hidden = YES;
    }
    [self setUpConstraints];
}
-(void)setUpConstraints{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(ContentViewHeight));
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(20.0f));
        make.height.equalTo(@(20.0f));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);;
    }];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.tipsLabel.mas_top).offset(-10.0f);
        make.width.equalTo(@(200.0f));
        make.height.equalTo(@(36.0f));
        
    }];
    [self.mesageTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-92.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@(97.0f));
        make.width.equalTo(@(230));
    }];
    if (_isBigVersionUpdate) {
        [self.bannerImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(@(140.0f));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.bannerImage.mas_right).offset(-24.0);
            make.top.equalTo(self.bannerImage.mas_top).offset(40.0f);
        }];
    }else{
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).offset(15.0f);
            make.height.equalTo(@(21.0f));
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(28.0f);
            make.height.equalTo(@(1.0f));
            make.width.equalTo(@(230));
        }];
        
    }
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.titleLabel.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1.0f);
        make.height.equalTo(@(17.0f));
    }];
    
    
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        if (_isBigVersionUpdate) {
            _titleLabel = [UILabel newWithFont:HXBoldFont(24) textColor:[UIColor whiteColor]];
            _titleLabel.text = @"发现新版本";
        }else{
            _titleLabel = [UILabel newWithFont:HXBoldFont(15) textColor:HXFontColor];
            _titleLabel.text =@"发现有新版本可升级";
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UILabel *)versionLabel{
    if (!_versionLabel) {
        if (_isBigVersionUpdate) {
            _versionLabel = [UILabel newWithFont:HXBoldFont(20) textColor:[UIColor whiteColor]];
        }else{
            _versionLabel = [UILabel newWithFont:HXBoldFont(12) textColor:HXFontColor];
        }
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}
-(UITextView *)mesageTextView{
    if (!_mesageTextView) {
        _mesageTextView = [UITextView new];
        _mesageTextView.textAlignment = NSTextAlignmentLeft;
        _mesageTextView.textColor = UIColorFromRGB(0x686868);
        _mesageTextView.font =HXFont(12);
        _mesageTextView.editable = NO;
        _mesageTextView.scrollEnabled = YES;
    }
    return _mesageTextView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel newWithFont:HXFont(10) textColor:HXFontReadingColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"建议在wifi环境下更新哦~";
    }
    return _tipsLabel;
}
-(UIButton *)updateButton{
    if (!_updateButton) {
        _updateButton = [UIButton newWithBgImage:[UIImage newWithColors:@[UIColorFromRGB(0x333CE9),UIColorFromRGB(0x59A4FF)] gradientType:leftToRight size:CGSizeMake(ScreenWidth, 36.0f)] selectedBgImage:[UIImage newWithColors:@[HXButtonBGGradientStartColor,HXButtonBGGradientEndColor] gradientType:leftToRight size:CGSizeMake(ScreenWidth, 36.0f)]];
        [_updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
        [_updateButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _updateButton.titleLabel.font = HXFont(15.0f);
        _updateButton.layer.cornerRadius = 18;
        _updateButton.layer.masksToBounds = YES;
    }
    return _updateButton;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton =[UIButton new];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"updateVersion_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
-(UIImageView *)bannerImage{
    if (!_bannerImage) {
        _bannerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"updateVerson_banner"]];
    }
    return _bannerImage;
}
-(UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor phc_lightGray];
    }
    return _line;
}
-(void)configureSubTitle:(NSString *)subTitle message:(NSString *)message{
    self.versionLabel.text = subTitle;
    self.mesageTextView.text = message;
}
-(void)confirmButtonClick{
    if (self.okAcionBlock) {
        self.okAcionBlock();
    }
}
-(void)closeButtonClick{
    [self hideView];
    
}
@end
