//
//  UIImage+easyTools.m
//  EasyTool
//
//  Created by supertext on 14-6-6.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/UIImage+EasyTools.h>
#import <EasyTools/EasyTool.h>
#import <Accelerate/Accelerate.h>
@implementation UIImage (EasyTools)
+ (UIImage *)etScreenShot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage *)etBlurGlass
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self etBlurWithRadius:5 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)etLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self etBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)etExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self etBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)etDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self etBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)etTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self etBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)etBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(nullable UIImage *)maskImage{
    if (self.size.width < 1 || self.size.height < 1) {
        return nil;
    }
    if (!self.CGImage) {
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}
+(UIImage *)imageWithBadge:(NSInteger)badgeValue
{
    if (badgeValue<1) {
        return nil;
    }
    if (badgeValue>99) {
        badgeValue=99;
    }
    NSString *badgeString = [@(badgeValue) stringValue];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 20, 20));
    NSDictionary *attr =@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize size = [badgeString sizeWithAttributes:attr];
    [badgeString drawInRect:CGRectMake(9.5-size.width/2, 10-size.height/2, size.width, size.height) withAttributes:attr];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size scale:(CGFloat)scale
{
    return ETRectImageWithColorScale(color, size, scale);
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    return ETRectImageWithColor(color, size);
}
-(UIImage *)cutUseFrame:(CGRect)frame
{
    if (!self.CGImage) {
        return self;
    }
    CGFloat scale=self.scale;
    CGRect orignalBounds=CGRectMake(0, 0, self.size.width*scale, self.size.height*scale);
    CGRect thisFrame=CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale);
    if (CGRectContainsRect(orignalBounds,thisFrame )) {
        
        CGImageRef aImage=CGImageCreateWithImageInRect(self.CGImage, thisFrame);
        UIImage *image=[UIImage imageWithCGImage:aImage scale:scale orientation:UIImageOrientationUp];
        return image;
    }
    return self;
}
-(UIImage *)cutUseSize:(CGSize)size
{
    if (!self.CGImage) {
        return self;
    }
    CGSize originalSize=self.size;
    if (CGSizeEqualToSize(originalSize, size)) {
        return self;
    }
    if (originalSize.width>=size.width&&originalSize.height>=size.height) {
        return [self cutUseFrame:CGRectMake(originalSize.width/2-size.width/2, originalSize.height/2-size.height/2, size.width, size.height)];
    }
    return self;
}
-(UIImage *)expandUseColor:(UIColor *)expandColor toSize:(CGSize)size
{
    if (!self.CGImage) {
        return self;
    }
    CGFloat scale=self.scale;
    CGSize imageSize=self.size;
    if (CGSizeEqualToSize(imageSize, size)) {
        return self;
    }
    if (size.width>=imageSize.width&&size.height>=imageSize.height) {
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [expandColor CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
        CGContextDrawImage(context, CGRectMake(size.width/2-imageSize.width/2, size.height/2-imageSize.height/2,imageSize.width , imageSize.height), self.CGImage);
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return theImage;
    }
    else
    {
        return self;
    }
}
-(UIImage *)expandUseColor:(UIColor *)expandColor toCircleRadius:(CGFloat)radius
{
    if (!self.CGImage) {
        return self;
    }
    CGFloat scale=self.scale;
    CGSize size=self.size;
    if (radius<=MAX(size.width, size.height)/2) {
        return self;
    }
    CGSize nSize=CGSizeMake(radius*2, radius*2);
    UIGraphicsBeginImageContextWithOptions(nSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [expandColor CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, 2*radius, 2*radius));
    CGContextDrawImage(context, CGRectMake(nSize.width/2-size.width/2, nSize.height/2-size.height/2,size.width , size.height), self.CGImage);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+(UIImage *)arrowWithDirection:(ETArrowImageDirection)direction
{
    return [self arrowWithColor:[UIColor blueColor] direction:direction size:CGSizeMake(20, 20) scale:[UIScreen mainScreen].scale];
}
+(UIImage *)arrowWithColor:(UIColor *)color direction:(ETArrowImageDirection)direction size:(CGSize)size scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width=size.width;
    CGFloat height=size.height;
    CGMutablePathRef path=CGPathCreateMutable();
    switch (direction) {
        case ETArrowImageDirectionUP:
            CGPathMoveToPoint(path, NULL, 0, height);
            CGPathAddLineToPoint(path, NULL, width/2, height/2);
            CGPathAddLineToPoint(path, NULL, width, height);
            break;
        case ETArrowImageDirectionDown:
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, width/2, height/2);
            CGPathAddLineToPoint(path, NULL, width, 0);
            break;
        case ETArrowImageDirectionLeft:
            CGPathMoveToPoint(path, NULL, width, 0);
            CGPathAddLineToPoint(path, NULL, width/2, height/2);
            CGPathAddLineToPoint(path, NULL, width, height);
            break;
        case ETArrowImageDirectionRight:
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, width/2, height/2);
            CGPathAddLineToPoint(path, NULL, 0, height);
            break;
            
        default:
            break;
    }
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
