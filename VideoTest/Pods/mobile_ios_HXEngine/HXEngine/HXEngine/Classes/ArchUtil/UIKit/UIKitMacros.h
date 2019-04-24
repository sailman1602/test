//
//  UIKitMacros.h
//
//  Created by songhe on 5/26/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#ifndef CYViews_ViewMacros_h
#define CYViews_ViewMacros_h

#import <UIKit/UIKit.h>

#import "UIView+Block.h"
#import "UIButton+Block.h"
#import "UITextField+Border.h"
#import "UIView+Line.h"
#import "UIView+BFExtension.h"

typedef void (^CompletionBlock)(void);
typedef void(^CompletionAnyTypeBlock) (id type);
typedef void(^CompletionAnyTwoTypeBlock) (id type,id number);


UIColor *rgba(int r, int g, int b, float alpha);

UIColor *rgbaFromHex(NSInteger hexColor, CGFloat alpha);


#define RGBA_HEX(hexColor, a) rgbaFromHex(hexColor, a)

#define RGBCOLOR_HEX(hexColor) rgbaFromHex(hexColor,1)
#define RGBCOLOR_HEXBEGIN(hexColor) rgbaFromHex(hexColor, 0.3)
#define RGBCOLOR_HEXEND(hexColor) rgbaFromHex(hexColor, 0.1)

#define HexRGB(hexColor) rgbaFromHex(hexColor, 1)
#define HexRGBA(hexColor, a) rgbaFromHex(hexColor, a)

// 随机色
#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HXRandomColor HMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) rgba(r, g, b, 1)
#endif

#ifndef RGBACOLOR
#define RGBACOLOR(r, g, b, a) rgba(r, g, b, a)
#endif


#ifndef safe_block
#define safe_block(block, ...) block ? block(__VA_ARGS__) : nil

#endif

#ifndef WEAK_VAR
#define WEAK_VAR(v) __weak typeof(v) _##v = v
#endif

/** Weak--Strong**/
#ifndef Weak
#define Weak(object)                __weak __typeof(&*object)weak_##object = object;
#endif

#ifndef WeakSelf
#define WeakSelf(weakSelf)                __weak __typeof(&*self)weakSelf = self;
#endif

#ifndef StrongSelf
#define StrongSelf(strongSelf, weakSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;
#endif

#ifndef WEAKSELF
#define WEAKSELF   WeakSelf(weakSelf)
#endif

#ifndef STRONGSELF
#define STRONGSELF StrongSelf(strongSelf, weakSelf)
#endif

#ifndef URL
#define URL(url) [NSURL URLWithString:[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]
#define URL2(host,path) [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",host,path] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]
#endif

/*
 ************************ dic value********************
 */
#ifndef HXDicGetSafeInteger
#define HXDicGetSafeInteger(dic,key) ((!dic||![dic isKindOfClass:[NSDictionary class]]||![[dic objectForKey:key] isKindOfClass:[NSNumber class]])?0:[[dic objectForKey:key] integerValue]);

#define HXDicGetSafeFloat(dic,key) ((!dic||![dic isKindOfClass:[NSDictionary class]]||![[dic objectForKey:key] isKindOfClass:[NSNumber class]])?0:[[dic objectForKey:key] floatValue]);

#define HXDicGetSafeString(dic,key) ((!dic||![dic isKindOfClass:[NSDictionary class]]||![[dic objectForKey:key] isKindOfClass:[NSString class]])?@"":[dic objectForKey:key]);

#define HXDicGetSafeArray(dic,key) ((!dic||![dic isKindOfClass:[NSDictionary class]]||![[dic objectForKey:key] isKindOfClass:[NSArray class]])?@[]:[dic objectForKey:key]);

#define HXDicGetSafeDic(dic,key) ((!dic||![dic isKindOfClass:[NSDictionary class]]||![[dic objectForKey:key] isKindOfClass:[NSDictionary class]])?@{}:[dic objectForKey:key]);
#endif

#ifndef HXLog

#if !PRO

#define HXLog(format, ...)    do {                                            \
(NSLog)([NSString stringWithFormat:@"<%@ : %d> - [%@]",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithUTF8String:__func__]],""); \
(NSLog)((format), ##__VA_ARGS__);                                            \
} while (0)

#else

#define HXLog(format, ... )

#endif


#endif

/**
 *  @return obj is obj != nil && obj is [NSNull null]
 *          defaultValue, otherwise
 */
id ensureObject(id obj, id defaultValue);

/**
 *  @return obj is obj is of class `cls`
 *          defaultValue, otherwise
 */
id ensureObjectOfClass(id obj, Class cls, id defaultValue);

/**
 *  @return defaultValue if obj is nil or NSNull object,
 *          obj if obj is NSString,
 *          [@"%@", obj] otherwise
 */
NSString *ensureStr(id obj, NSString *defaultValue);

static inline NSString *ensureNonNilStr(id obj) {
    return ensureStr(obj, @"");
}

#endif
