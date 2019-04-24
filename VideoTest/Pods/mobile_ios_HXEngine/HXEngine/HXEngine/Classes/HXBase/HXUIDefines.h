//
//  HXUIDefines.h
//  newHfax
//
//  Created by lly on 2017/6/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "UIColor+Factory.h"

//全屏宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//iphoneX
#define IS_IPHONEX (ScreenHeight==812.0||ScreenHeight==896.0)
#define IphoneXStateHeight (IS_IPHONEX ? 24.0 : 0)
#define IphoneXBottomTabbarHeight (IS_IPHONEX ? 34.0 : 0)
#define ScaleWidth(width) ((width) * (ScreenWidth/375.0))
#define ScaleHeight(heigh) ((heigh) * (ScreenHeight/(IS_IPHONEX ? 812.0 : 667.0)))
#define ScaleSize(width,heigh) CGSizeMake(ScaleWidth(width),ScaleHeight(heigh))

static inline float ScaleHeight_568(float heigh) {
    if (ScreenHeight <= 568) {
        return heigh;
    }
   return ScaleHeight(heigh);
}

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)
#define AnimationsTimeInterval                  0.3
#define PopupWindowAnimationsTimeInterval       0.25

/********************************************************
 默认UI Color
 ********************************************************/

//主题 color
#define HXThemeColor UIColorFromRGB(0xFA5644)//主题色
#define HXThemeAssistColor UIColorFromRGB(0xffbc3c)//辅颜色

#define HXGradientStartColor UIColorFromRGB(0xff7339)//主题渐变开始色
#define HXGradientEndColor UIColorFromRGB(0xf63f4c)//主题渐变结束色

//背景和线 color
#define HXBGColor UIColorFromRGB(0xf9f9f9)//背景底颜色
#define HXBGAssistColor UIColorFromRGB(0xa0aebd)//背景辅颜色
#define HXBGLineColor UIColorFromRGB(0xf1f1f1)//线颜色
// 分割线
#define HXPartingLineColor UIColorFromRGB(0xf3f3f3)

// 字的颜色
#define HXFontColor UIColorFromRGB(0x3D3D3D)//主标字颜色,原颜色:1e4063
#define HXFontAssistColor UIColorFromRGB(0xA9A9A9)//辅标字颜色,原颜色:a0aebd
#define HXFontSubColor UIColorFromRGB(0x686868)//辅标题颜色,原颜色:a0aebd
#define HXFontReadingColor UIColorFromRGB(0x8F8E94)//阅读辅助字颜色,3.2.0新增
#define HXFontReadingAssistColor UIColorFromRGB(0xA9A9A9)//阅读次类辅助字颜色,3.2.0新增

#define HXLightBlueColor UIColorFromRGB(0x4285F4)//标记亮蓝色
#define HXLightGray UIColorFromRGB(0xd4d7dd)//置灰字体颜色
#define HXGreenText UIColorFromRGB(0x09863e)//绿色字
#define HXGrayText UIColorFromRGB(0xc2c2c2)//灰色字
#define HXFeatureTextColor UIColorFromRGB(0xffa94c)//项目特点颜色
#define HXOtherSettingMainColor UIColorFromRGB(0x4A4A4A)//其他设置主颜色
#define HXOtherSettingAssistColor UIColorFromRGB(0x9999A8)//其他设置辅助颜色
#define HXOtherSettingPlaceColor UIColorFromRGB(0xD0CFD5)//其他设置占位颜色

//button color
#define HXButtonDisableBGColor UIColorFromRGB(0xd4d7dd)//button Disable背景颜色
#define HXButtonBGColor HXThemeColor  //button 背景颜色
#define HXButtonBGGradientStartColor HXGradientStartColor //button 背景颜渐变开始色
#define HXButtonBGGradientEndColor HXGradientEndColor //button 背景渐变结束色

/********************************************************
 默认UI button 描边
 ********************************************************/
#define HXButtonBorderWidth 1
#define HXButtonCornerRadius 1


/********************************************************
 默认UI 间距
 ********************************************************/
#define HXFontSpaceVertical 10 //垂直，纵向文字与文字间间距
#define HXFontLineSpaceVertical 12.5 //垂直，纵向文字与分割线间间距
#define HXFontBottomSpaceVertical 15 //垂直，纵向文字与边界间间距

#define HXMargin 15 //模块距离左右两边的间距，水平间距
#define HXLeading 10//模块与模块之间距离，垂直间距



/********************************************************
 默认UI 字体 线 列表 大小
 ********************************************************/
#define HXFontSzie 14 //默认大文字 大小
#define HXFontMinSzie 12//默认小文字 大小

#define HXLineHeight 1 //默认线 高度
#define HXCellHeight 45 //默认cell 高度


/********************************************************
 默认UI 字体
 ********************************************************/

#define APPSystemVersion  [UIDevice currentDevice].systemVersion.doubleValue


//#define HXFont(fsize)     \
//(APPSystemVersion>=9.0)?([UIFont fontWithName:@"PingFang-SC-Light" size:fsize]):([UIFont fontWithName:@".PingFang-SC-Thin" size:fsize])
//
//#define HXBoldFont(fsize)     \
//(APPSystemVersion>=9.0)?([UIFont fontWithName:@"PingFang-SC-Medium" size:fsize]):([UIFont fontWithName:@".PingFang-SC-Medium" size:fsize])

//#define HXMoreBold(fsize)     \
//(APPSystemVersion>=8.0)?([UIFont fontWithName:@"PingFang-SC-Bold" size:fsize]):([UIFont boldSystemFontOfSize:fsize])

UIKIT_EXTERN UIFont * HXFont(CGFloat fontSize);
UIKIT_EXTERN UIFont * HXBoldFont(CGFloat fontSize);
UIKIT_EXTERN UIFont * HXLightFont(CGFloat fontSize);

UIKIT_EXTERN UIFont * SFUITextBold(CGFloat fontSize);
UIKIT_EXTERN UIFont * SFUITextHeavy(CGFloat fontSize);
UIKIT_EXTERN UIFont * SFUITextMedium(CGFloat fontSize);
UIKIT_EXTERN UIFont * SFUITextRegular(CGFloat fontSize);
UIKIT_EXTERN UIFont * SFUITextLight(CGFloat fontSize);
