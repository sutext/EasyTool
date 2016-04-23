//
//  ETTapLabel.m
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETTapLabel.h>
#import <EasyTools/UIView+EasyTools.h>
@interface ETTapLabel()
@property(nonatomic,strong)UITapGestureRecognizer *tapges;
@property(nonatomic,strong)NSValue *textInsetsValue;
@property(nonatomic)CGFloat originalWidth;
@end
@implementation ETTapLabel

-(UITapGestureRecognizer *)tapges
{
    if (!_tapges) {
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector)];
        tapGesture.numberOfTapsRequired=1;
        self.tapges=tapGesture;
    }
    return _tapges;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.originalWidth = self.width;
}
-(void)setTapAction:(void (^)(ETTapLabel *))tapAction
{
    if (_tapAction!=tapAction) {
        _tapAction=tapAction;
        if (tapAction) {
            self.userInteractionEnabled=YES;
            [self addGestureRecognizer:self.tapges];
        }
    }
}
-(void)tapSelector
{
    if (self.tapAction) {
        self.tapAction(self);
    }
}
-(void)setTextInsets:(UIEdgeInsets)textInsets
{
    self.textInsetsValue = [NSValue valueWithUIEdgeInsets:textInsets];
}
-(UIEdgeInsets)textInsets
{
    return [self.textInsetsValue UIEdgeInsetsValue];
}
-(void)setText:(NSString *)text
{
    [super setText:text];
    if (self.textInsetsValue) {
        self.width=_originalWidth;
    }
}
-(void)drawTextInRect:(CGRect)rect
{
    if (self.textInsetsValue) {
        [super drawTextInRect:UIEdgeInsetsInsetRect(self.bounds, self.textInsets)];
    }
    else
    {
        [super drawTextInRect:rect];
    }
    
}
-(CGSize)sizeThatFits:(CGSize)size
{
    if (self.textInsetsValue) {
        if (self.text.length>0) {
            CGSize otherSize=[super sizeThatFits:size];
            return CGSizeMake(otherSize.width+self.textInsets.left+self.textInsets.right, otherSize.height+self.textInsets.top+self.textInsets.bottom);
        }
        return CGSizeZero;
    }
    else
    {
        return [super sizeThatFits:size];
    }
}
@end