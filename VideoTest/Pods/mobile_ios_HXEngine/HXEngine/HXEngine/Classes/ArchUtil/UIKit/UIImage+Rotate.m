//
//  UIImage+Rotate.m
//  JRJInvestAdviser
//
//  Created by FarTeen on 4/14/15.
//  Copyright (c) 2015 jrj. All rights reserved.
//

#import "UIImage+Rotate.h"

//CG_INLINE void TLContextAddLineToPoint(CGContextRef context, CGPoint point)
//{
//    CGContextAddLineToPoint(context, point.x, point.y);
//}
//
//CG_INLINE void TLContextMoveToPoint(CGContextRef context, CGPoint point)
//{
//    CGContextMoveToPoint(context, point.x, point.y);
//}
//
//CG_INLINE void TLContextRestore(CGContextRef context)
//{
//    CGContextRestoreGState(context);
//}
//
//CG_INLINE CGContextRef TLContextSave(void)
//{
//    CGContextRef ctxt = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(ctxt);
//    return ctxt;
//}

// degrees to radians, useful for affine translations

CG_INLINE CGFloat TLDegreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

// start an image context

CG_INLINE CGContextRef TLGraphicsBeginImageContext(CGSize size)
{
    UIGraphicsBeginImageContextWithOptions(size, FALSE, 0.0);
  
    return UIGraphicsGetCurrentContext();
}

// end an image context

CG_INLINE UIImage* TLGraphicsEndImageContext(void)
{
    UIImage* imag = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imag;
}

// center point of a rect

//CG_INLINE CGPoint TLPointCenter(CGRect rect)
//{
//    CGPoint  cgpt = CGPointZero;
//    
//    cgpt.x = rect.origin.x + floor(rect.size.width  / 2.0);
//    cgpt.y = rect.origin.y + floor(rect.size.height / 2.0);
//    
//    return cgpt;
//}
//
//// center left point of a rect
//
//CG_INLINE CGPoint TLPointCenterLeft(CGRect rect)
//{
//    CGPoint  cgpt = CGPointZero;
//    
//    cgpt.x = CGRectGetMinX(rect);
//    cgpt.y = rect.origin.y + floor(rect.size.height / 2.0);
//    
//    return cgpt;
//}

// center right point of a rect

//CG_INLINE CGPoint TLPointCenterRight(CGRect rect)
//{
//    CGPoint  cgpt = CGPointZero;
//    
//    cgpt.x = CGRectGetMaxX(rect);
//    cgpt.y = rect.origin.y + floor(rect.size.height / 2.0);
//    
//    return cgpt;
//}
//
//// lower center point of a rect
//
//CG_INLINE CGPoint TLPointLowerCenter(CGRect rect)
//{
//    CGPoint  cgpt = CGPointZero;
//    
//    cgpt.x = rect.origin.x + floor(rect.size.width / 2.0);
//    cgpt.y = CGRectGetMaxY(rect);
//    
//    return cgpt;
//}

// lower left point of a rect

//CG_INLINE CGPoint TLPointLowerLeft(CGRect rect)
//{
//    return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
//}
//
//// lower right point of a rect
//
//CG_INLINE CGPoint TLPointLowerRight(CGRect rect)
//{
//    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
//}
//
//// upper center point of a rect
//
//CG_INLINE CGPoint TLPointUpperCenter(CGRect rect)
//{
//    CGPoint  cgpt = CGPointZero;
//    
//    cgpt.x = rect.origin.x + floor(rect.size.width / 2.0);
//    cgpt.y = CGRectGetMinY(rect);
//    
//    return cgpt;
//}
//
//// upper left point of a rect
//
//CG_INLINE CGPoint TLPointUpperLeft(CGRect rect)
//{
//    return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
//}
//
//// upper right point of a rect
//
//CG_INLINE CGPoint TLPointUpperRight(CGRect rect)
//{
//    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
//}
//
//// move 'target' to the bottom of 'rect'
//
//CG_INLINE CGRect TLRectBottom(CGRect rect, CGRect target)
//{
//    target.origin.y = rect.origin.y + rect.size.height - target.size.height;
//    
//    return target;
//}
//
//// center 'target' over 'rect'
//
//CG_INLINE CGRect TLRectCenter(CGRect rect, CGRect target)
//{
//    const CGFloat  xoff = floor((rect.size.width  - target.size.width)  / 2.0);
//    const CGFloat  yoff = floor((rect.size.height - target.size.height) / 2.0);
//    
//    target.origin.x = rect.origin.x + xoff;
//    target.origin.y = rect.origin.y + yoff;
//    
//    return target;
//}
//
//// move 'target' to the far left of 'rect'
//
//CG_INLINE CGRect TLRectLeft(CGRect rect, CGRect target)
//{
//    target.origin.x = rect.origin.x;
//    
//    return target;
//}

// move 'target' to the far right of 'rect'

//CG_INLINE CGRect TLRectRight(CGRect rect, CGRect target)
//{
//    target.origin.x = rect.origin.x + rect.size.width - target.size.width;
//    
//    return target;
//}

// move 'target' to the top of 'rect'

//CG_INLINE CGRect TLRectTop(CGRect rect, CGRect target)
//{
//    target.origin.y = rect.origin.y;
//    
//    return target;
//}

// create a rect from a size

CG_INLINE CGRect TLRectWithSize(CGSize size)
{
    CGRect rect = CGRectZero;
    rect.size = size;
    return rect;
}

// "zooms" a rect by adding zoomSize pixels to each side. the returned rect
// will be centered directly over the old one.

//CG_INLINE CGRect TLRectZoom(CGRect rect, CGFloat zoomSize)
//{
//    rect.origin.x    -= zoomSize;
//    rect.origin.y    -= zoomSize;
//    
//    rect.size.width  += (zoomSize * 2.0);
//    rect.size.height += (zoomSize * 2.0);
//    
//    return rect;
//}

// square size

//CG_INLINE CGSize TLSizeSquare(CGFloat size)
//{
//    return CGSizeMake(size, size);
//}

// swap width and height of this size

CG_INLINE CGSize TLSizeSwap(CGSize size)
{
    const CGFloat  swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}

@implementation UIImage (Rotate)

-(CGRect)bounds
{
    return TLRectWithSize(self.size);
}

- (UIImage *)rotateToOrientation:(UIImageOrientation)orient
{
    CGRect             bnds = self.bounds;
    CGContextRef       ctxt = nil;
    const CGRect       rect = bnds;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, TLDegreesToRadians(180.0));
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds.size = TLSizeSwap(bnds.size);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, TLDegreesToRadians(-90.0));
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds.size = TLSizeSwap(bnds.size);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, TLDegreesToRadians(-90.0));
            break;
            
        case UIImageOrientationRight:
            bnds.size = TLSizeSwap(bnds.size);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, TLDegreesToRadians(90.0));
            break;
            
        case UIImageOrientationRightMirrored:
            bnds.size = TLSizeSwap(bnds.size);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, TLDegreesToRadians(90.0));
            break;
            
        default:
            // orientation value supplied is invalid
            assert(FALSE);
            return nil;
    }
    
    ctxt = TLGraphicsBeginImageContext(bnds.size);
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, self.CGImage);
    
    return TLGraphicsEndImageContext();

}
@end
