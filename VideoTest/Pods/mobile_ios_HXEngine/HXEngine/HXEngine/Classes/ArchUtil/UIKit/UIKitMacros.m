//
//  CYViewMacros.m
//  CYViews
//
//  Created by songhe on 5/26/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIKitMacros.h"

UIColor *rgba(int r, int g, int b, float alpha) {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha];
}

UIColor *rgbaFromHex(NSInteger hexColor, CGFloat alpha) {
    return rgba((hexColor >> 16) & 0xFF, (hexColor >> 8) & 0xFF, hexColor & 0xFF, alpha);
}

NSString *ensureStr(id obj, NSString *defaultValue) {
    obj = ensureObject(obj, nil);
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    else if (obj) {
        return [NSString stringWithFormat:@"%@", obj];
    }
    return defaultValue;
}

id ensureObject(id obj, id defaultValue) {
    if (obj == nil || obj == [NSNull null]) {
        return defaultValue;
    }
    return obj;
}

id ensureObjectOfClass(id obj, Class cls, id defaultValue) {
    return [obj isKindOfClass:cls] ? obj : defaultValue;
}


