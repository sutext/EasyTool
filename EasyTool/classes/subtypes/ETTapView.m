//
//  ETTapView.m
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETTapView.h>

@interface ETTapView()
@property(nonatomic,strong)UITapGestureRecognizer* singleTapGes;
@property(nonatomic,strong)UITapGestureRecognizer* doubleTapGes;
@end
@implementation ETTapView

{
    BOOL _doubleTaped;
    BOOL _hasDoubleAction;
}
- (void)dealloc
{
    self.singleTapGes=nil;
    self.doubleTapGes=nil;
}
-(void)setTapEnable:(BOOL)enable
{
    if (self.tapAction) {
        self.singleTapGes.enabled=enable;
    }
}
-(void)setDoubleTapEnable:(BOOL)enable
{
    if (_hasDoubleAction) {
        self.doubleTapGes.enabled = enable;
    }
}
-(void)setTapAction:(void (^)(ETTapView *))tapAction
{
    if (_tapAction!=tapAction) {
        _tapAction=tapAction;
        if (tapAction) {
            [self addGestureRecognizer:self.singleTapGes];
        }
    }
}
-(void)setDoubleTapAction:(void (^)(ETTapView *))doubleTapAction
{
    if (_doubleTapAction!=doubleTapAction) {
        _doubleTapAction=doubleTapAction;
        if (doubleTapAction) {
            _hasDoubleAction=YES;
            [self addGestureRecognizer:self.doubleTapGes];
        }
    }
}
-(UITapGestureRecognizer *)singleTapGes
{
    if (!_singleTapGes) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        self.singleTapGes=singleTap;
    }
    return _singleTapGes;
}
-(UITapGestureRecognizer *)doubleTapGes
{
    if (!_doubleTapGes) {
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        self.doubleTapGes=doubleTap;
    }
    return _doubleTapGes;
}
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if (_tapAction!=NULL) {
        _doubleTaped=NO;
        if (_hasDoubleAction) {
            [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.2];
        }
        else
        {
            [self singleTapAction];
        }
    }
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTaped=YES;
    if (_doubleTapAction!=NULL) {
        _doubleTapAction(self);
    }
}
-(void)singleTapAction
{
    if (!_doubleTaped&&_tapAction!=NULL) {
        _tapAction(self);
    }
}

@end