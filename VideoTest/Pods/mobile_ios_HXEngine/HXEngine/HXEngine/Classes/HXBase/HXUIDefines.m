//
//  HXUIDefines.m
//  newHfax
//
//  Created by lly on 2017/6/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXUIDefines.h"

UIFont * HXFont(CGFloat fontSize);
UIFont * HXBoldFont(CGFloat fontSize);
UIFont * HXLightFont(CGFloat fontSize);

UIFont * HXLightFont(CGFloat fontSize){
    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
}
UIFont * HXFont(CGFloat fontSize){
    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}
UIFont * HXBoldFont(CGFloat fontSize){
    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
}

UIFont * SFUIText(CGFloat fontSize,CGFloat weight);

UIFont * SFUITextBold(CGFloat fontSize)
{
    return SFUIText(fontSize, UIFontWeightBold);
}

UIFont * SFUITextHeavy(CGFloat fontSize)
{
    return SFUIText(fontSize, UIFontWeightHeavy);
}

UIFont * SFUITextMedium(CGFloat fontSize)
{
    return SFUIText(fontSize, UIFontWeightMedium);
}

UIFont * SFUITextRegular(CGFloat fontSize)
{
    return SFUIText(fontSize, UIFontWeightRegular);
}

UIFont * SFUITextLight(CGFloat fontSize)
{
    return SFUIText(fontSize, UIFontWeightLight);
}

UIFont * SFUIText(CGFloat fontSize,CGFloat weight)
{
    return [UIFont systemFontOfSize:fontSize weight:weight];
}

