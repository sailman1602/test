//
//  UITextField+Placeholder.m
//  newHfax
//
//  Created by sh on 2017/11/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)placeholderWithString:(NSString *)string Font:(UIFont *)font color:(UIColor *)color {
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:attributes];
}
@end
