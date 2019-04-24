//
//  HXBaseTableViewCell.m
//  newHfax
//
//  Created by lly on 2017/10/12.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTableViewCell.h"
#import <Masonry/Masonry.h>
#import "HXUIDefines.h"
#import "UIView+BFExtension.h"
#import "UILabel+Factory.h"

@interface HXTableViewCell()

@end

@implementation HXTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initDefault];
        [self setupUI];
        [self configureConstraints];
        
        [self addSubview:self.separatorLine];
        
        [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(_separatorLeft));
            make.right.equalTo(@(-_separatorRight));
            make.height.equalTo(@(_separatorHeight));
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setupUI{
    
}
- (void)configureConstraints{
    
}

- (void)bindModel:(id)model{
    if([model isKindOfClass:[NSString class]]){
        self.textLabel.text = model;
    }else {
        self.textLabel.text = [model valueForKey:@"text"];
        self.detailTextLabel.text = [model valueForKey:@"detailText"];
        self.accessoryType = [[model valueForKey:@"accessoryType"] integerValue];
    }
}

#pragma mark - default
- (UIView *)separatorLine{
    if(!_separatorLine){
        _separatorLine = [[UIView alloc]init];
        _separatorLine.backgroundColor = _separatorColor;
    }
    return _separatorLine;
}
- (void)initDefault{
    self.textLabel.textColor = HXFontColor;
    self.defaultTextFont = HXFont(14);
    self.defaultDetailtextFont = HXFont(12);
    self.separatorColor = HXPartingLineColor;
    self.separatorHeight = 1;
    self.separatorLeft = 15;
    self.showSeparator = YES;
}

#pragma mark - getter and setter
- (void)setDefaultTextFont:(UIFont *)defaultTextFont{
    self.textLabel.font = defaultTextFont;
}

- (void)setDefaultDetailtextFont:(UIFont *)defaultDetailtextFont{
    self.detailTextLabel.font = defaultDetailtextFont;
}

- (void)setShowSeparator:(BOOL)showSeparator{
    _showSeparator = showSeparator;
    self.separatorLine.hidden = !showSeparator;
}
@end

#pragma mark - HXTableViewStaticCell
@implementation HXTableViewStaticCell

- (void)setupUI{
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.rightImageView];
}

- (void)configureConstraints{
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.textLabel.mas_right).offset(5);
    }];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.textLabel.mas_right).offset(5);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(5, 5));
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView);
    }];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_rightLabel);
    }];
}

- (UILabel *)leftLabel{
    if(!_leftLabel){
        _leftLabel = [UILabel newWithFont:self.defaultTextFont textColor:HXFontColor];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UIImageView *)leftImageView{
    if(!_leftImageView){
        _leftImageView = [UIImageView new];
    }
    return _leftImageView;
}

- (UILabel *)rightLabel{
    if(!_rightLabel){
        _rightLabel = [UILabel newWithFont:HXFont(11.0f) textColor:HXFontReadingColor];
        _rightLabel.adjustsFontSizeToFitWidth = YES;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UIImageView *)rightImageView{
    if(!_rightImageView){
        _rightImageView = [UIImageView new];
    }
    return _rightImageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.bounds.size.height/2;
    if (self.accessoryType == UITableViewCellAccessoryNone) {
        [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).offset(-15);
        }];
    } 
}
@end
