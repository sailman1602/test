//
//  HXTagListView.m
//  newHfax
//
//  Created by lly on 2017/12/5.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTagListView.h"
#import "HXEdgeInsetLabel.h"
#import "UIView+Util.h"
#import "UIView+BFExtension.h"
#import "HXUIDefines.h"

@interface HXTagListView ()

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSArray <HXEdgeInsetLabel *> *labelList;
@property (nonatomic,strong) NSArray <UIImageView *> *imageViewList;
@property (nonatomic,assign) CGFloat space;

@end

@implementation HXTagListView

+(instancetype)newWithCount:(NSInteger)count space:(CGFloat)space font:(UIFont *)font textColor:(UIColor *)textColor{
    return [self newWithCount:count space:space font:font borderColor:nil textColor:textColor];
}

+(instancetype)newWithCount:(NSInteger)count space:(CGFloat)space font:(UIFont *)font borderColor:(UIColor *)borderColor textColor:(UIColor *)textColor{
    HXTagListView *listView = [[HXTagListView alloc] initWithCount:count space:space font:font borderColor:borderColor textColor:textColor];
    return listView;
}

+(instancetype)newWithLabelCount:(NSInteger)labelCount space:(CGFloat)space font:(UIFont *)font textColor:(UIColor *)textColor imageCount:(NSInteger)imageCount{
    HXTagListView *listView = [[HXTagListView alloc] initWithCount:labelCount space:space font:font borderColor:nil textColor:textColor];
    NSMutableArray *imageViewList = [NSMutableArray array];
    for(NSInteger i=0;i<imageCount;i++){
        UIImageView *view = [[UIImageView alloc]init];
        view.hidden = YES;
        [imageViewList addObject:view];
        [listView addSubview:view];
    }
    listView.imageViewList = imageViewList;
    return listView;
    
}

- (instancetype)initWithCount:(NSInteger)count space:(CGFloat)space font:(UIFont *)font borderColor:(UIColor *)borderColor textColor:(UIColor *)textColor{
    if(self = [super init]){
        _count = count;
        NSMutableArray *array = [NSMutableArray array];
        for(int i=0;i<_count;i++){
            HXEdgeInsetLabel *label = [self createTagWithBorderColor:borderColor textColor:textColor font:font];
            [self addSubview:label];
            [array addObject:label];
        }
        _labelList = array;
        _space = space;
    }
    return self;
}

- (HXEdgeInsetLabel *)createTagWithBorderColor:(UIColor *)borderColor textColor:(UIColor *)textColor font:(UIFont *)font{
    HXEdgeInsetLabel *label = [HXEdgeInsetLabel newWithFont:font textColor:textColor bgColor:[UIColor whiteColor]];
    if(borderColor){
        [label cySetBorderColor:borderColor width:1];
    }
    return label;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = 0;
    for(NSInteger i=0;i<self.labelList.count;i++){
        HXEdgeInsetLabel *label = self.labelList[i];
        [label sizeToFit];
        if(label.hidden){
            label.frame = CGRectZero;
        }else{
            label.top = 0;
            label.left = (i==0)?0:(CGRectGetMaxX(self.labelList[i-1].frame)+_space);
            width = width +label.width;// ((i==0)?label.width:(label.width+_space));
            if(i!=0){
                width = width +_space;
            }
        }
    }
    HXEdgeInsetLabel *lastLabel = self.labelList.lastObject;
    if(self.maxWidth&&width>self.maxWidth){
        CGFloat lastLabelWidth = lastLabel.width;
        lastLabel.width = lastLabelWidth- (width-self.maxWidth);
        width = width - lastLabelWidth + lastLabel.width;
    }
    
    if(!self.imageViewList.count) return;
    CGFloat left = width+ScaleWidth(2);
    for(NSInteger i=0;i<self.imageViewList.count;i++){
        UIView *v = self.imageViewList[i];
        if(v.hidden) {
            v.frame = CGRectZero;
            continue;
        }
        if(i==0){
            v.frame = CGRectMake(left, 0, ScaleWidth(48.5f), ScaleHeight_568(14.5f));
        }else{
            v.frame = CGRectMake(CGRectGetMaxX(self.imageViewList[i-1].frame)+ScaleWidth(2), 0, ScaleWidth(48.5f), ScaleHeight_568(14.5f));
        }
    }
}

#pragma mark - getter and setter
- (void)setTextColor:(UIColor *)textColor{
    [self.labelList enumerateObjectsUsingBlock:^(HXEdgeInsetLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = textColor;
    }];
}

- (void)setTextColor:(UIColor *)textColor atIndex:(NSInteger)index{
    self.labelList[index].textColor = textColor;
}

- (void)setBorderColor:(UIColor *)borderColor atIndex:(NSInteger)index{
    [self.labelList[index] cySetBorderColor:borderColor width:1];
}

- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth atIndex:(NSInteger)index{
    [self.labelList[index] cySetBorderColor:borderColor width:borderWidth];
}

- (void)setBgColor:(UIColor *)bgColor{
    [self.labelList enumerateObjectsUsingBlock:^(HXEdgeInsetLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = bgColor;
    }];
}
- (void)setBgColor:(UIColor *)bgColor atIndex:(NSInteger)index{
    self.labelList[index].backgroundColor = bgColor;
}

- (void)setText:(NSString *)text atIndex:(NSInteger)index{
    self.labelList[index].text = text;
}

- (void)setTexts:(NSArray <NSString *> *)textArray{
    [self setTexts:textArray bgColors:nil];
    
}

- (void)setTexts:(NSArray <NSString *> *)textArray imageStrings:(NSArray <NSString *> *)imageStrings{
    [self setTexts:textArray bgColors:nil imageStrings:imageStrings];
}
- (void)setTexts:(NSArray <NSString *> *)textArray bgColors:(NSArray <UIColor *> *)bgColors{
    [self setTexts:textArray bgColors:bgColors imageStrings:nil];
}

- (void)setTexts:(NSArray <NSString *> *)textArray  bgColors:(NSArray <UIColor *> *)bgColors imageStrings:(NSArray <NSString *> *)imageStrings{
    NSInteger realCount = MIN(textArray.count,_count);
    for(NSInteger i =0;i<realCount;i++){
        self.labelList[i].hidden = false;
        [self setText:textArray[i] atIndex:i];
    }
    for(NSInteger i =textArray.count;i<_count;i++){
        self.labelList[i].hidden = YES;
    }
    
    if(bgColors.count){
        BOOL needRecyle = bgColors.count< textArray.count;
        for(NSInteger i =0;i<realCount;i++){
            [self setBgColor:bgColors[needRecyle?(i%bgColors.count):i] atIndex:i];
        }
    }
    
    for(NSInteger i=0;i<self.imageViewList.count;i++){
        UIImageView *imageView = self.imageViewList[i];
        if(i<imageStrings.count){
            imageView.image = [UIImage imageNamed:imageStrings[i]];
            imageView.hidden = false;
        }else{
            imageView.image = nil;
            imageView.hidden = true;
        }
    }
    
    [self setNeedsLayout];
}

- (CGFloat)realWidth{
    CGFloat width = 0;
    for(NSInteger i = 0;i<self.labelList.count;i++){
        UILabel *label = self.labelList[i];
        if(label.hidden) continue;
        width = width + [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}].width+10;
        if(i>0&&i<self.labelList.count-1)
            width = width+5;
    }
    
    for(UIImageView *imageView in self.imageViewList){
        if(imageView.hidden) continue;
        width = width +(ScaleWidth(48.5f)+ScaleWidth(2));
    }
    return width;
}
@end
