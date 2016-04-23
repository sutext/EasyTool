//
//  ETScrollView.m
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETScrollView.h>
@interface ETScrollView()
@property(nonatomic,strong)UITapGestureRecognizer *tapges;
@end
@implementation ETScrollView

-(UITapGestureRecognizer *)tapges
{
    if (!_tapges) {
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector)];
        tapGesture.numberOfTapsRequired=1;
        self.tapges=tapGesture;
    }
    return _tapges;
}
-(void)setTapAction:(void (^)(ETScrollView *))tapAction
{
    if (_tapAction!=tapAction) {
        _tapAction=[tapAction copy];
        if (tapAction) {
            self.userInteractionEnabled=YES;
            [self addGestureRecognizer:self.tapges];
        }
    }
}
-(void)tapSelector
{
    if (self.tapAction!=NULL) {
        _tapAction(self);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (otherGestureRecognizer==_tapges) {
        return YES;
    }
    return NO;
}

@end
