//
//  HXRefreshHeader.m
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXRefreshHeader.h"
#import "UIDevice+Helpers.h"
#import "HXUIDefines.h"

#define gitImageCount 14

@interface HXRefreshHeader()

@property (strong, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) UILabel *tipContent;
@property (assign, nonatomic) NSUInteger loadedCount;

@end

@implementation HXRefreshHeader

#pragma mark 在这里做一些初始化配置（比如添加子控件）

//- (FLAnimatedImage *)gifImage
//{
//    NSBundle *bundle = [NSBundle mainBundle];
//
//    NSString *gifName = @"";
//    if([UIDevice isAppleIphone6plus])
//    {
//        gifName = @"loading@3x";
//    }
//    else
//    {
//        gifName = @"loading@2x";
//    }
//
//    NSString *path = [bundle pathForResource:gifName ofType:@"gif"];
//
//    NSData *data = [NSData dataWithContentsOfFile:path];
//
//    FLAnimatedImage *image = [[FLAnimatedImage alloc]initWithAnimatedGIFData:data];
//    return image;
//}

- (NSArray <UIImage *> *)animatedImages{
    NSMutableArray *imageArray = [NSMutableArray array];
    for(int i = 1;i<=gitImageCount;i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_Refreshing%d",i]];
        [imageArray addObject:image];
    }
    return imageArray;
}

- (NSArray <UIImage *> *)newAnimatedImages{
    NSMutableArray *imageArray = [NSMutableArray array];
    for(int i = 1;i<=5;i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon2_Refreshing%d",i]];
        [imageArray addObject:image];
    }
    return imageArray;
}

- (NSArray <UIImage *> *)newEndAnimatedImages{
    NSMutableArray *imageArray = [NSMutableArray array];
    for(int i = 1;i<=10;i++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon2_RefreshEnd%d",i]];
        [imageArray addObject:image];
    }
    return imageArray;
}

- (void)prepare
{
    [super prepare];
    
    self.loadedCount = 0;
    self.extraAddHeight = 0;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    self.gifView = imageView;
    
    self.tipContent = [UILabel mj_label];
    self.tipContent.text = [self getNeedShowContentTip];
    self.tipContent.textColor = UIColorFromRGB(0xAAABBA);
    self.tipContent.font = HXFont(12);
    self.tipContent.hidden = YES;
    [self addSubview:self.tipContent];
}

- (void)setIsNewRefreshHeaderType:(BOOL)isNewRefreshHeaderType{
    _isNewRefreshHeaderType = isNewRefreshHeaderType;
    if (_isNewRefreshHeaderType) {
        // 设置控件的高度
        self.mj_h = [self getNewRefreshHeight];
        self.gifView.image = [UIImage imageNamed:@"icon2_RefreshBegin"];
    }else{
        // 设置控件的高度
        self.mj_h = 24 + self.extraAddHeight;
        self.gifView.image = [UIImage imageNamed:@"icon_Refreshing"];
        self.gifView.animationDuration = 2;
    }
}

- (void)setIsShowTextLabel:(BOOL)isShowTextLabel{
    _isShowTextLabel = isShowTextLabel;
    if (_isShowTextLabel) {
        self.tipContent.hidden = NO;
    }else{
        self.tipContent.hidden = YES;
    }
    self.mj_h = [self getNewRefreshHeight];
}

//展示需要显示的内容
- (NSString *)getNeedShowContentTip{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSArray *array = [store objectForKey:StoreRefreshContentKey];
    if (array && array.count>0) {
        NSUInteger contentIndex = (array.count + self.loadedCount) % array.count;
        if (contentIndex>array.count-1) {
            contentIndex = array.count - 1;
        }
        return [array objectAtIndex:contentIndex];
    }
    return @"";
}

- (CGFloat)getNewRefreshHeight{
    if (self.isShowTextLabel) {
        NSString *needShowString = [self getNeedShowContentTip];
        if (needShowString && needShowString.length>0) {
            return 80 + self.extraAddHeight;
        }
    }
    return 55 + self.extraAddHeight;
}

- (void)startEndAnimating{
    [self.gifView stopAnimating];
    [self layoutIfNeeded];
    self.gifView.animationImages = [self newEndAnimatedImages];
    self.gifView.animationDuration = self.gifView.animationImages.count * 0.06;
    [self.gifView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.gifView.image = [UIImage imageNamed:@"icon2_RefreshEnd10"];
        [self.gifView stopAnimating];
    });
}

- (void)endHeaderRefresh{
    if (self.isNewRefreshHeaderType) {
        [self startEndAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endRefreshing];
        });
    }else{
        [self endRefreshing];
    }
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    if (self.isNewRefreshHeaderType) {
        self.mj_h = [self getNewRefreshHeight];
        self.gifView.frame = CGRectMake(0, 0, ScaleWidth(21), ScaleHeight(21));
        self.gifView.center = CGPointMake(self.mj_w * 0.5,[self getNewRefreshHeight] - (12+ScaleHeight(10.5)));
        self.tipContent.frame = CGRectMake(0, 0, ScreenWidth, 18);
        self.tipContent.center = CGPointMake(self.mj_w * 0.5,self.gifView.center.y - (17 + ScaleHeight(10.5)));
    }else{
        self.mj_h = 24 + self.extraAddHeight;
        self.gifView.frame = CGRectMake(0, 0, ScaleWidth(24), ScaleHeight(8));
        self.gifView.center = CGPointMake(self.mj_w * 0.5,self.extraAddHeight + 24 * 0.5);
    }
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
    if (self.isNewRefreshHeaderType) {
        switch (state) {
            case MJRefreshStateIdle:
                [self.gifView stopAnimating];
                if (oldState != MJRefreshStateRefreshing) {
                    self.gifView.image = [UIImage imageNamed:@"icon2_RefreshBegin"];
                }else{
                    NSString *needShowString = [self getNeedShowContentTip];
                    if (needShowString && needShowString.length>0) {
                        self.loadedCount++;
                    }else{
                        self.loadedCount = 0;
                    }
                }
                break;
            case MJRefreshStatePulling:
                [self.gifView stopAnimating];
                //                self.gifView.image = [UIImage imageNamed:@"icon2_RefreshBegin"];
                break;
            case MJRefreshStateRefreshing:
                self.gifView.animationImages = [self newAnimatedImages];
                self.gifView.animationRepeatCount = 0;
                self.gifView.animationDuration = self.gifView.animationImages.count * 0.1;
                [self.gifView startAnimating];
                break;
            default:
                break;
        }
    }else{
        switch (state) {
            case MJRefreshStateIdle:
                [self.gifView stopAnimating];
                self.gifView.image = [UIImage imageNamed:@"icon_Refreshing"];
                break;
            case MJRefreshStatePulling:
                [self.gifView stopAnimating];
                self.gifView.image = [UIImage imageNamed:@"icon_Refreshing"];
                break;
            case MJRefreshStateRefreshing:
                self.gifView.animationImages = [self animatedImages];
                self.gifView.animationDuration = 2;
                [self.gifView startAnimating];
                break;
            default:
                break;
        }
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (self.isNewRefreshHeaderType) {
        if (self.state == MJRefreshStateIdle) {
            if (pullingPercent > 0) {
                [self.gifView stopAnimating];
                self.gifView.image = [UIImage imageNamed:@"icon2_RefreshBegin"];
                if (self.isShowTextLabel) {
                    NSString *needShowString = [self getNeedShowContentTip];
                    if (needShowString && needShowString.length>0) {
                        self.tipContent.hidden = NO;
                        self.tipContent.text = needShowString;
                    }
                }else{
                    self.tipContent.hidden = YES;
                }
            }
        }
    }
}

@end
