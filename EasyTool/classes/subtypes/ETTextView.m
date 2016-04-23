//
//  ETTextView.m
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETTextView.h>
#import <EasyTools/UIView+easyTools.h>
#import <EasyTools/EasyTool.h>

@interface ETTextView()
@property(nonatomic,strong)UILabel *placeHolerLabel;
@end

@implementation ETTextView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame textContainer:nil];
}
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        self.font=[UIFont systemFontOfSize:14];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font =[UIFont systemFontOfSize:14];
        self.placeholder = [aDecoder decodeObjectForKey:@"placeholder"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.placeholder forKey:@"placeholder"];
}
-(UILabel *)placeHolerLabel
{
    if (!_placeHolerLabel) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:self];
        UILabel *placeHoderLab=[[UILabel alloc] init];
        placeHoderLab.textColor=ETColorFromRGB(0xaaaaaa);
        placeHoderLab.backgroundColor=[UIColor clearColor];
        placeHoderLab.font=self.font;
        [self addSubview:placeHoderLab];
        self.placeHolerLabel=placeHoderLab;
    }
    return _placeHolerLabel;
}
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    if (_placeHolerLabel) {
        _placeHolerLabel.font=font;
    }
}
-(void)setText:(NSString *)text
{
    [super setText:text];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}
-(void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder!=placeholder) {
        _placeholder = placeholder;
        if (placeholder) {
            self.placeHolerLabel.text=placeholder;
            self.placeHolerLabel.width =self.width;
            [self.placeHolerLabel sizeToFit];
            self.placeHolerLabel.origin=CGPointMake(5, 8);
            if (placeholder&&placeholder.length>0&&!self.text.length)
            {
                [self showPlaceHolder];
            }
            else
            {
                [self hidePlaceHolder];
            }
        }
        else
        {
            self.placeHolerLabel = nil;
        }
    }
}
-(void)showPlaceHolder
{
    [self addSubview:self.placeHolerLabel];
}
-(void)hidePlaceHolder
{
    [self.placeHolerLabel removeFromSuperview];
}
-(void)textDidChanged:(NSNotification *)sender
{
    if (_placeHolerLabel) {
        if (self.text&&self.text.length>0) {
            [self hidePlaceHolder];
        }
        else
        {
            [self showPlaceHolder];
        }
    }
}
@end
