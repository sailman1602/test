//
//  HXToast.m
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXToast.h"

@interface HXToast()
{
    CGFloat duration;
}
@end

#define ImageSize 20
#define showImageToast_height 35

#define kSpaceLeftRight 12
#define kSpaceUpDown 10

@implementation HXToast
#define minWidth    300
#define maxWidth    250
#define toastheight 120

@synthesize textLable;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithView:(UIView*)view text:(NSString*)text duration:(float)inDuration
{
    int width = minWidth;
    int height = toastheight;
    CGSize size = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-2*kSpaceLeftRight, MAXFLOAT)];
    if (size.width > width-2*kSpaceLeftRight)
    {
        if (size.width < maxWidth-2*kSpaceUpDown)
        {
            width = ceilf(size.width)+2*kSpaceLeftRight;
            height = ceilf(size.height)+2*kSpaceUpDown;
        }
        else
        {
            width = maxWidth;
            CGSize size1 = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-2*kSpaceLeftRight, MAXFLOAT)];
            if (size1.height < toastheight-2*kSpaceLeftRight)
            {
                height = ceilf(size1.height) + 2*kSpaceUpDown;
            }
        }
    }
    else
    {
        width = ceilf(size.width)+2*kSpaceLeftRight;
        height = ceilf(size.height)+2*kSpaceUpDown;
    }
    
    CGRect rect = CGRectMake((view.bounds.size.width-width)/2, (view.bounds.size.height-height)/2, width, height);
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.alpha = 0;
        
        duration = inDuration;
        
        textLable = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceLeftRight, kSpaceUpDown, self.bounds.size.width-2*kSpaceLeftRight, height-2*kSpaceUpDown)];
        textLable.backgroundColor = [UIColor clearColor];
        textLable.font = [UIFont systemFontOfSize:15];
        textLable.textColor = [UIColor whiteColor];
        textLable.textAlignment = NSTextAlignmentCenter;
        textLable.numberOfLines = 0;
        //        textLable.lineBreakMode = g_LineBreakByCharWrapping;
        textLable.text = text;
        [self addSubview:textLable];
        
        [view addSubview:self];
        
    }
    return self;
}

- (id)initWithView:(UIView*)view image:(UIImage*)leftImage text:(NSString*)text duration:(float)inDuration{
    int width = minWidth;
    int height = toastheight;
    CGSize size = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-20, MAXFLOAT)];
    if (size.width > width-20)
    {
        if (size.width < maxWidth-20)
        {
            width = ceilf(size.width)+20;
            height = ceilf(size.height)+20;
        }
        else
        {
            width = maxWidth;
            CGSize size1 = [self sizeWithText:text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(width-20, MAXFLOAT)];
            if (size1.height < toastheight-20)
            {
                height = ceilf(size1.height) + 20;
            }
        }
    }
    else
    {
        width = ceilf(size.width)+20;
        height = ceilf(size.height)+20;
    }
    
    CGRect rect = CGRectMake(0, 0, view.bounds.size.width, showImageToast_height);
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code
        //        self.layer.cornerRadius = 6;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.alpha = 0;
        
        duration = inDuration;
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((view.bounds.size.width-ImageSize-width)/2, (showImageToast_height-ImageSize)/2, ImageSize, ImageSize)];
        _imageView.image = leftImage;
        [self addSubview:_imageView];
        
        textLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+10, (showImageToast_height-(height-20))/2, width-20, height-20)];
        textLable.backgroundColor = [UIColor clearColor];
        textLable.font = [UIFont systemFontOfSize:15];
        textLable.textColor = [UIColor whiteColor];
        textLable.textAlignment = NSTextAlignmentCenter;
        textLable.numberOfLines = 0;
        //        textLable.lineBreakMode = g_LineBreakByCharWrapping;
        textLable.text = text;
        [self addSubview:textLable];
        
        [view addSubview:self];
        
    }
    return self;
}

- (void)show {
    if(!textLable.text.length) return;
    _isShowing = true;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(closeToast) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)closeToast{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        _isShowing = false;
    }];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    if ([text isEqual:[NSNull null]]) {
        return CGSizeZero;
    }
    if (!text || !text.length) {
        return CGSizeZero;
    }
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    CGRect rect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
    return rect.size;
}

@end
