//
//  UIView+AddShadow.h
//  mobile_ios_HXEngine
//
//  Created by YNZMK on 2018/10/10.
//  Copyright © 2018 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum :NSInteger{
    
    HXShadowPathLeft,
    
    HXShadowPathRight,
    
    HXShadowPathTop,
    
    HXShadowPathBottom,
    
    HXShadowPathNoTop,
    
    HXShadowPathAllSide
    
} HXShadowPathSide;

@interface UIView (AddShadow)

/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 
 * shadowPathWidth 阴影的宽度，
 
 */

-(void)HX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(HXShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

@end

NS_ASSUME_NONNULL_END
