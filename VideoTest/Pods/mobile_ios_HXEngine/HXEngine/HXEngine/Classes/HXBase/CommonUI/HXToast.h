//
//  HXToast.h
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXToast : UIView

@property (nonatomic,strong) UILabel *textLable;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) BOOL isShowing;
- (instancetype)initWithView:(UIView*)view text:(NSString*)text duration:(float)inDuration;
- (instancetype)initWithView:(UIView*)view image:(UIImage*)leftImage text:(NSString*)text duration:(float)inDuration;
- (void)show;

@end
