//
//  ETTableView.m
//  EasyTool
//
//  Created by supertext on 14/11/5.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETTableView.h>
#import <EasyTools/EasyTool.h>
#import <EasyTools/UIView+EasyTools.h>
#import <EasyTools/ETLoadmoreControl.h>

@interface ETTableView()
@property(nonatomic,strong)UIView<ETRefreshProtocol>* topControl;
@property(nonatomic,strong)UIView<ETRefreshProtocol>* bottomControl;
@end
@implementation ETTableView
@dynamic delegate;

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self removeRefreshStyle:ETRefreshStyleBoth];
    }
}
-(void)usingRefreshStyle:(ETRefreshStyle)style
{
    [self usingRefreshStyle:style withClass:nil];
}
-(void)usingRefreshStyle:(ETRefreshStyle)style withClass:(__unsafe_unretained _Nullable Class<ETRefreshProtocol>)refreshClass
{
    if (style&ETRefreshStyleTop) {
        if (!self.topControl) {
            self.topControl=[[(refreshClass?:[UIRefreshControl class]) alloc] init];
            [self.topControl addTarget:self action:@selector(beginTopRefresh:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.topControl];
        }
    }
    if (style&ETRefreshStyleBottom) {
        if (!self.bottomControl) {
            self.bottomControl=[[(refreshClass?:[ETLoadmoreControl class]) alloc] init];
            [self.bottomControl addTarget:self action:@selector(beginBottomRefresh:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.bottomControl];
        }
    }
}
-(void)beginTopRefresh:(id<ETRefreshProtocol>)sender
{
    if (!sender.enabled) {
        [sender endRefreshing];
    }
    else
    {
        [self beginRefreshing:sender withStyle:ETRefreshStyleTop];
    }
}
-(void)beginBottomRefresh:(id<ETRefreshProtocol>)sender
{
    if (!sender.enabled) {
        [sender endRefreshing];
    }
    else
    {
        [self beginRefreshing:sender withStyle:ETRefreshStyleBottom];
    }
}
-(id<ETRefreshProtocol>)trefreshControl
{
    return self.topControl;
}
-(id<ETRefreshProtocol>)brefreshControl
{
    return self.bottomControl;
}
-(void)removeRefreshStyle:(ETRefreshStyle)style
{
    if (style&ETRefreshStyleTop) {
        [self.topControl removeFromSuperview];
        self.topControl=nil;
    }
    if (style&ETRefreshStyleBottom) {
        [self.bottomControl removeFromSuperview];
        self.bottomControl=nil;
    }
}
-(void)enableRefreshStyle:(ETRefreshStyle)style
{
    if (style&ETRefreshStyleTop) {
        self.topControl.enabled=YES;
        
    }
    if (style&ETRefreshStyleBottom) {
        self.bottomControl.enabled=YES;
    }
}
-(void)disableRefreshStyle:(ETRefreshStyle)style
{
    if (style&ETRefreshStyleTop) {
        self.topControl.enabled=NO;
    }
    if (style&ETRefreshStyleBottom) {
        self.bottomControl.enabled=NO;
    }
}

-(void)beginRefreshing:(id<ETRefreshProtocol> )sender withStyle:(ETRefreshStyle)style
{
    if (self.delegate&&[self.delegate conformsToProtocol:@protocol(ETTableViewDelegate)]&&[self.delegate respondsToSelector:@selector(tableView:willBeginRefreshWithStyle:refreshControl:)]) {
        [self.delegate tableView:self willBeginRefreshWithStyle:style refreshControl:sender];
    }
}
@end
