//
//  UIView+HXShow.h
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HXShow)

#pragma mark - loading
- (void)showLoadingView;
- (void)showLoadingView:(NSString *)loadingMsg;

- (void)hideLoadingView;

#pragma mark - toast
- (void)showToast:(NSString *)info;
- (void)showToastOnWindow:(NSString *)info;

- (void)showToast:(NSString *)info duration:(float)inDuration;
- (void)showToastOnWindow:(NSString *)info duration:(float)inDuration;

@property (nonatomic,assign) CGFloat defaultViewOffset;
@property (nonatomic,assign) CGFloat defaultViewTop;
@property (nonatomic,assign) CGFloat descMargin;
@property (nonatomic,copy)   NSString *noDataDesc;
@property (nonatomic,copy)   NSString *noDataImage;
@property (nonatomic,copy)   NSString *noNetworkImage;
@property (nonatomic,copy)   NSString *dataErrorImage;

#pragma mark - default no data
- (void)showNoDataView;
- (void)hideNoDataView;

#pragma mark - default no netWork
- (void)showNoNetworkView;
- (void)hideNoNetworkView;

#pragma mark - default data error
- (void)showDataErrorView;
- (void)hideDataErrorView;

#pragma mark - allviews hides
- (void)hideDefaultView;
- (void)hideNoNetworkOrErrorView;
@end
