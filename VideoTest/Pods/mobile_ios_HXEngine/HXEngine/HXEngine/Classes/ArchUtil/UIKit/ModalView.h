//
//  ModalView.h
//  CYViews
//
//  Created by songhe on 6/17/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ModalViewLevel) {
    kModalViewLevelInView,
    kModalViewLevelNormal,
    kModalViewLevelAlert,
    kModalViewLevelTopAlert,
};

typedef NS_ENUM(NSInteger, ModalViewShowType) {
    kModalViewShowFromCenter,
    kModalViewShowFromBottom,
    kModalViewShowNoAnimation,
};

@class ModalView;
typedef void (^ModalViewResultBlock)(ModalView *modalView, NSDictionary *result);

@interface ModalView : UIView  {
    UIView *_backView;
}

- (instancetype)initWithFrame:(CGRect)frame level:(ModalViewLevel)level;

- (void)show;
- (void)dismiss;
- (void)dismissWithResult:(NSDictionary *)result;

@property (nonatomic, strong) UIView *backView; //
@property (nonatomic) CGPoint finalPosition;

@property (nonatomic) ModalViewShowType showType;
@property (nonatomic) BOOL dissmissOnBackgroundTap;
@property (nonatomic) NSTimeInterval animationDuration;

@property (nonatomic, copy) ModalViewResultBlock resultBlock;
- (void)setResultBlock:(ModalViewResultBlock)resultBlock;

- (void)addBackView:(ModalViewLevel)level;

@end

@interface ModalViewContainer : UIView {
}

+ (void)willShowModalView:(ModalView *)modalView level:(ModalViewLevel)level;

+ (void)didHideModalView:(ModalView *)modalView level:(ModalViewLevel)level;

@end

