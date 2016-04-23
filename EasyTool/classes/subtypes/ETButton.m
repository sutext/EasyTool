//
//  ETButton.m
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETButton.h>
#import <EasyTools/UIView+EasyTools.h>
#import <EasyTools/EasyTool.h>
@interface ETButton()
@property(nonatomic,readwrite)ETButtonTitleStyle titleStyle;
@property(nonatomic,weak)UILabel *innerLabel;
@end

@interface ETButtonItem()

@end

@implementation ETButton

#pragma mark -- initlizer
+(id)buttonWithType:(UIButtonType)buttonType
{
    ETButton *butten = [super buttonWithType:buttonType];
    butten.titleStyle = ETButtonTitleStyleDefault;
    return butten;
}
- (instancetype)initWithFrame:(CGRect)frame style:(ETButtonTitleStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleStyle=style;
        if (style != ETButtonTitleStyleDefault) {
            self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            self.innerLabel=[super titleLabel];
            self.innerLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleStyle = [aDecoder decodeIntegerForKey:@"titleStyle"];
        self.imageSize = [aDecoder decodeCGSizeForKey:@"imageSize"];
        if (self.titleStyle != ETButtonTitleStyleRight) {
            self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            self.innerLabel=[super titleLabel];
            self.innerLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return self;
}
- (instancetype)init
{
    return [self initWithStyle:ETButtonTitleStyleDefault];
}
- (instancetype)initWithStyle:(ETButtonTitleStyle)style
{
    return [self initWithFrame:CGRectZero style:style];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:ETButtonTitleStyleDefault];
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.titleStyle forKey:@"titleStyle"];
    [aCoder encodeCGSize:self.imageSize forKey:@"imageSize"];
}
-(void)setImageColor:(UIColor *)color forState:(UIControlState)state
{
    [self setImage:ETRectImageWithColor(color, self.imageSize) forState:state];
}
-(void)applyButtonItem:(ETButtonItem *)item forState:(UIControlState)state
{
    if (item)
    {
        self.imageSize = item.imageSize;
        if (item.image)
        {
            [self setImage:item.image forState:state];
        }
        else if (item.imageColor)
        {
            [self setImageColor:item.imageColor forState:state];
        }
        [self setTitle:item.title forState:state];
        [self setTitleColor:item.titleColor forState:state];
        [self.titleLabel setFont:item.titleFont];
        if (item.cornerRadius>0) {
            [self.layer setCornerRadius:item.cornerRadius];
            [self setClipsToBounds:YES];
        }
        
    }
}
#pragma mark geter and setter

-(void)setClickedAction:(void (^)(ETButton *))clickedAction
{
    if (_clickedAction!=clickedAction)
    {
        _clickedAction=clickedAction;
        if (clickedAction)
        {
            [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self removeTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
#pragma mark private methods
-(void)click
{
    if (self.clickedAction)
    {
        self.clickedAction(self);
    }
}

-(CGSize)currentTitleSize
{
    CGSize imageSize = self.imageSize;
    CGFloat width = imageSize.width - (self.titleEdgeInsets.left+self.titleEdgeInsets.right);
    CGFloat height = self.titleStyle==ETButtonTitleStyleCover?imageSize.height:UINT16_MAX;
    CGRect titleRect = [self.innerLabel textRectForBounds:CGRectMake(0, 0, width, height) limitedToNumberOfLines:self.innerLabel.numberOfLines];
    return titleRect.size;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    switch (self.titleStyle) {
        case ETButtonTitleStyleCover:
        case ETButtonTitleStyleBottom:
        {
            CGRect resultRect =CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, self.imageSize.width, self.imageSize.height);
            return UIEdgeInsetsInsetRect(resultRect, self.imageEdgeInsets);
        }break;
        default:
            return [super imageRectForContentRect:contentRect];
            break;
    }
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    switch (self.titleStyle) {
        case ETButtonTitleStyleCover:
        {
            CGRect imageRect = CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, self.imageSize.width, self.imageSize.height);
            CGSize titleSize = [self currentTitleSize];
            CGRect resultRect = CGRectMake((imageRect.size.width-titleSize.width)/2+imageRect.origin.x, (imageRect.size.height-titleSize.height)/2+imageRect.origin.y, titleSize.width, titleSize.height);
            resultRect.origin.x += (self.titleEdgeInsets.left-self.titleEdgeInsets.right);
            resultRect.origin.y += (self.titleEdgeInsets.top-self.titleEdgeInsets.bottom);
            return resultRect;
        }break;
        case ETButtonTitleStyleBottom:
        {
            CGRect imageRect = CGRectMake(self.contentEdgeInsets.left, self.contentEdgeInsets.top, self.imageSize.width, self.imageSize.height);
            CGSize titleSize = [self currentTitleSize];
            CGRect resultRect = CGRectMake((imageRect.size.width-titleSize.width)/2+imageRect.origin.x, imageRect.size.height+imageRect.origin.y, titleSize.width, titleSize.height);
            resultRect.origin.x += self.titleEdgeInsets.left;
            resultRect.origin.y += self.titleEdgeInsets.top;
            return resultRect;
        }break;
        default:
            return [super titleRectForContentRect:contentRect];
            break;
    }
}
-(CGSize)sizeThatFits:(CGSize)size
{
    switch (self.titleStyle) {
        case ETButtonTitleStyleCover:
        {
            return CGSizeMake(self.contentEdgeInsets.left+self.contentEdgeInsets.right+self.imageSize.width, self.contentEdgeInsets.top+self.contentEdgeInsets.bottom+self.imageSize.height);
        }break;
        case ETButtonTitleStyleBottom:
        {
            CGSize titleSize = [self currentTitleSize];
            CGSize resultSize = CGSizeMake(self.imageSize.width, self.imageSize.height+titleSize.height);
            resultSize.height +=(self.titleEdgeInsets.top+self.titleEdgeInsets.bottom);
            return CGSizeMake(self.contentEdgeInsets.left+self.contentEdgeInsets.right+resultSize.width, self.contentEdgeInsets.top+self.contentEdgeInsets.bottom+resultSize.height);
        }break;
        default:
            return [super sizeThatFits:size];
            break;
    }
}
@end

@implementation ETButtonItem

+(instancetype)appearance
{
    static dispatch_once_t onceToken = 0;
    static ETButtonItem *_appearance;
    dispatch_once(&onceToken, ^{
        _appearance= [[self alloc] initAppearance];
    });
    return _appearance;
}
+(instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
{
    return [self appearance];
}
+(instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return [self appearance];
}
+(instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ...
{
    return [self appearance];
}

- (instancetype)initAppearance
{
    self = [super init];
    if (self) {
        self.titleColor = [UIColor whiteColor];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.cornerRadius = 0;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        ETButtonItem *appearance    = [[self class] appearance];
        self.titleColor             = appearance.titleColor.copy;
        self.titleFont              = appearance.titleFont.copy;
        self.cornerRadius           = appearance.cornerRadius;
        self.imageColor             = appearance.imageColor.copy;
        self.imageSize              = appearance.imageSize;
    }
    return self;
}


@end