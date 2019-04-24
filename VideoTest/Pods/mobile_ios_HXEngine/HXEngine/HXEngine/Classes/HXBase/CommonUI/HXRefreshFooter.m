//
//  HXRefreshFooter.m
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXRefreshFooter.h"
//#import <FLAnimatedImage.h>
#import "UIDevice+Helpers.h"
#import "HXUIDefines.h"

#define gitImageCount 14

@interface HXRefreshFooter ()

//@property (strong, nonatomic) FLAnimatedImageView *gifView;
@property (strong, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) UILabel *noDataLabel;

@end

@implementation HXRefreshFooter

//- (UIImageView *)gifImage
//{
////    NSBundle *bundle = [NSBundle mainBundle];
////    
////    NSString *gifName = @"";
////    if([UIDevice isAppleIphone6plus])
////    {
////        gifName = @"loading@3x";
////    }
////    else
////    {
////        gifName = @"loading@2x";
////    }
//
////    NSString *path = [bundle pathForResource:gifName ofType:@"gif"];
////    
////    NSData *data = [NSData dataWithContentsOfFile:path];
//    
////    FLAnimatedImage *image = [[FLAnimatedImage alloc]initWithAnimatedGIFData:data];
//    if(_gifView)return _gifView;
//    _gifView.animationImages = imageArray;
//    
//    return _gifView;
//}

- (NSArray <UIImage *> *)animatedImages{
    NSMutableArray *imageArray = [NSMutableArray array];
    for(int i = 1;i<=gitImageCount;i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_Refreshing%d",i]];
        [imageArray addObject:image];
    }
    return imageArray;
}

- (void)setNoDataText:(NSString *)text
{
    self.noDataLabel.text = text;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 24;
//    
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc]init];
//    
//    imageView.image = [UIImage imageNamed:@"icon_Refreshing"];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_Refreshing"];
    [self addSubview:imageView];
    self.gifView = imageView;
    self.gifView.animationDuration = 2;
    
    self.noDataLabel = [[UILabel alloc]init];
    self.noDataLabel.frame = CGRectMake(0, 0, ScreenWidth, self.mj_h);
    [self.noDataLabel setText:@"没有更多数据"];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    self.noDataLabel.hidden = YES;
    self.noDataLabel.numberOfLines = 0;
    self.noDataLabel.font = [UIFont systemFontOfSize:14];
    self.noDataLabel.textColor = [UIColor colorWithRGB:0x999999];
    [self addSubview:self.noDataLabel];
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.gifView.frame = CGRectMake(0, 0, ScaleWidth(24), ScaleHeight(8));
    self.gifView.center = CGPointMake(self.mj_w * 0.5,self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.gifView stopAnimating];
            self.gifView.image = [UIImage imageNamed:@"icon_Refreshing"];
            self.gifView.hidden = NO;
            self.noDataLabel.hidden = YES;
        }
            break;
        case MJRefreshStatePulling:
        {
            [self.gifView stopAnimating];
            self.gifView.image = [UIImage imageNamed:@"icon_Refreshing"];
            self.gifView.hidden = NO;
            self.noDataLabel.hidden = YES;
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.gifView.animationImages = [self animatedImages];
            self.gifView.hidden = NO;
            self.noDataLabel.hidden = YES;
            [self.gifView startAnimating];
        }
            break;
        case MJRefreshStateNoMoreData:
        {
            self.gifView.hidden = YES;
            self.noDataLabel.hidden = NO;
            [self.gifView startAnimating];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}

@end
