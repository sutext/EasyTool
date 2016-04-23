//
//  ETActionSheet.m
//  EasyTool
//
//  Created by supertext on 14/10/29.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETActionSheet.h>
#import <EasyTools/UIView+EasyTools.h>
#import <EasyTools/ETGlobalContainer.h>
#import <EasyTools/EasyTool.h>
#import <EasyTools/ETButton.h>


@interface ETActionSheet()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView                   *actionView;
@property(nonatomic,weak)id<ETActionSheetDelegate>  delegate;
@property(nonatomic)ETActionSheetStyle              style;
@property(nonatomic)CGFloat                         itemWidth;
@end

@interface ETActionSheetItem()
+(instancetype)cancelItem;
@end

@implementation ETActionSheet
- (instancetype)initWithDelegate:(id<ETActionSheetDelegate>)delegate
{
    return [self initWithStyle:ETActionSheetStyleDefault delegate:delegate];
}
- (instancetype)initWithStyle:(ETActionSheetStyle)style delegate:(id<ETActionSheetDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.style=style;
        self.titleLineCount             = 1;
        self.delegate                   = delegate;
        self.topMargin                  = ETScaledFloat(23.5);
        self.middleMargin               = 0;
        self.bottomMargin               = ETScaledFloat(12);
        if ((style&0xf) == 3) {
            self.itemWidth              = ETScaledFloat(70.5);
        }
        else
        {
            self.itemWidth              = ETScaledFloat(65.8);
        }
        self.aniduration                = 0.25;
        self.tintColor                  = [UIColor colorWithWhite:1 alpha:0.9];
        NSAssert(self.delegate&&[self.delegate conformsToProtocol:@protocol(ETActionSheetDelegate)], @"the delegate == nil or not conform to ETActionSheetDelegate");
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.view.alpha = 0;
    NSInteger iconCount=[self.delegate numberOfItemsInActionSheet:self];
    if (iconCount<=0) {
        return;
    }
    NSUInteger colCount = (self.style&0xf);
    NSUInteger rowCount = (self.style>>4);
    NSInteger lineCount=ceilf((float)iconCount/colCount);
    NSInteger pageCount=ceilf((float)lineCount/rowCount);
    //
    CGFloat scrollViewHeight=self.topMargin+self.bottomMargin+(self.itemWidth+[self titleHeight])*(lineCount<rowCount?lineCount:rowCount)+self.middleMargin*(lineCount<rowCount?(lineCount-1):(rowCount-1));
    UIView *actionView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, scrollViewHeight+ETScaledFloat(65.8))];
    actionView.backgroundColor= self.tintColor;
    self.actionView=actionView;
    [self.view addSubview:actionView];
    
    CGFloat averageWith=(actionView.width-colCount*self.itemWidth)/(colCount+1);
    if (pageCount==1) {
        UIView *pageView=[self createApageAtIndex:0 pageSize:iconCount averageWith:averageWith frame:CGRectMake(0, 0, actionView.width, scrollViewHeight)];
        if (lineCount==1&&iconCount<colCount) {
            CGFloat avwidth=(actionView.width-iconCount*self.itemWidth)/(iconCount+1);
            [pageView.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
                obj.left=avwidth+idx*(self.itemWidth+avwidth);
            }];
        }
        [self.actionView addSubview:pageView];
    }
    else
    {
        UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.actionView.width, scrollViewHeight)];
        scrollView.backgroundColor=[UIColor clearColor];
        scrollView.contentSize=CGSizeMake(scrollView.width*pageCount, scrollView.height);
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.pagingEnabled=YES;
        scrollView.delegate=self;
        [self.actionView addSubview:scrollView];
        
        NSInteger pageSize=rowCount*colCount;
        for (NSInteger i=0; i<pageCount; i++) {
            if ((i==pageCount-1)&&iconCount%pageSize!=0) {
                pageSize=iconCount%pageSize;
            }
            UIView *pageView=[self createApageAtIndex:i pageSize:pageSize averageWith:averageWith frame:scrollView.bounds];
            pageView.left=i*scrollView.width;
            [scrollView addSubview:pageView];
        }
        
        UIPageControl *pageControl=[[UIPageControl alloc] init];
        pageControl.numberOfPages=pageCount;
        pageControl.currentPage=0;
        pageControl.origin=CGPointMake(self.actionView.width/2-pageControl.width, scrollViewHeight-self.bottomMargin+(self.bottomMargin-pageControl.height)/2);
        [self.actionView addSubview:pageControl];
        scrollView.runtimeObject=pageControl;
    }
    //cancel button
    __weak ETActionSheet *weakself=self;
    ETActionSheetItem *cancelItme = [ETActionSheetItem cancelItem];
    if ([self.delegate respondsToSelector:@selector(actionSheet:configCancelItem:)]) {
        [self.delegate actionSheet:self configCancelItem:cancelItme];
    }
    cancelItme.imageSize = CGSizeMake(actionView.width-2*averageWith, ETScaledFloat(35.2));
    ETButton *cancelButton=[[ETButton alloc] initWithStyle:ETButtonTitleStyleCover];
    [cancelButton applyButtonItem:cancelItme forState:UIControlStateNormal];
    [cancelButton setClickedAction:^(ETButton *sender) {
        [weakself cancleWithItme:cancelItme];
    }];
    [cancelButton sizeToFit];
    [cancelButton setOrigin:CGPointMake(averageWith, scrollViewHeight+ETScaledFloat(7))];
    [actionView addSubview:cancelButton];
    [UIView animateWithDuration:self.aniduration animations:^{
        actionView.transform=CGAffineTransformMakeTranslation(0, -actionView.height);
        self.view.alpha=1;
    }];
}
-(void)hide
{
    [self cancleWithItme:nil];
}
-(CGFloat)titleHeight
{
    return ETScaledFloat(20)*self.titleLineCount+ETScaledFloat(10);
}
-(void)show
{
    [[ETGlobalContainer singleContainer] present:self];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex=scrollView.contentOffset.x/scrollView.width;
    UIPageControl *pageControl=scrollView.runtimeObject;
    pageControl.currentPage=pageIndex;
}
-(UIView *)createApageAtIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize averageWith:(CGFloat)averageWith frame:(CGRect)frame
{
    UIView *view=[[UIView alloc] initWithFrame:frame];
    view.backgroundColor=[UIColor clearColor];
    __weak ETActionSheet *weakself=self;
    NSUInteger colCount = (self.style&0xf);
    NSUInteger rowCount = (self.style>>4);
    for (NSInteger i=0; i<pageSize; i++) {
        NSUInteger totalIndex=((colCount)*(rowCount))*pageIndex+i;
        ETActionSheetItem *item = [[ETActionSheetItem alloc] init];
        if ([self.delegate respondsToSelector:@selector(actionSheet:configActionItem:atIndex:)])
        {
            [self.delegate actionSheet:self configActionItem:item atIndex:totalIndex];
        }
        item.imageSize = CGSizeMake(self.itemWidth, self.itemWidth);
        ETButton *button = [[ETButton alloc] initWithStyle:ETButtonTitleStyleBottom];
        [button applyButtonItem:item forState:UIControlStateNormal];
        [button.titleLabel setNumberOfLines:self.titleLineCount];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(([self titleHeight]-[button currentTitleSize].height)/2, 0, 0, 0)];
        [button setClickedAction:^(ETButton *etbutton) {
            [weakself dissmissAtIndex:totalIndex itme:item];
        }];
        [button sizeToFit];
        [button setOrigin:CGPointMake((averageWith+self.itemWidth)*(i%colCount)+averageWith, (self.middleMargin+self.itemWidth+[self titleHeight])*(i/colCount)+self.topMargin)];
        [view addSubview:button];
    }
    return view;
}
-(void)dissmissAtIndex:(NSUInteger)index itme:(ETActionSheetItem *)item
{
    [UIView animateWithDuration:self.aniduration animations:^{
        self.actionView.transform=CGAffineTransformIdentity;
        self.view.alpha=0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(actionSheet:dismissWithItem:atIndex:)]) {
            [self.delegate actionSheet:self dismissWithItem:item atIndex:index];
        }
        [self.actionView removeFromSuperview];
        self.actionView=nil;
        [[ETGlobalContainer singleContainer] dismissController];
    }];
}
-(void)cancleWithItme:(ETActionSheetItem *)itme
{
    [UIView animateWithDuration:self.aniduration animations:^{
        self.actionView.transform=CGAffineTransformIdentity;
        self.view.alpha=0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(actionSheet:cancledWithItem:)]) {
            [self.delegate actionSheet:self cancledWithItem:itme];
        }
        [self.actionView removeFromSuperview];
        self.actionView=nil;
        [[ETGlobalContainer singleContainer] dismissController];
    }];
}
-(UIViewController *)childViewControllerForStatusBarHidden
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
-(UIViewController *)childViewControllerForStatusBarStyle
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
@end

@implementation ETActionSheetItem
+(instancetype)cancelItem
{
    ETActionSheetItem *item = [[self alloc] init];
    item.title = @"cancel";
    item.titleFont  = [UIFont systemFontOfSize:ETScaledFloat(17)];
    item.titleColor = [UIColor whiteColor];
    item.imageColor = [UIColor lightGrayColor];
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerRadius = 5;
        self.titleFont=[UIFont systemFontOfSize:ETScaledFloat(14.5)];
        self.titleColor=ETColorFromRGB(0x222222);
    }
    return self;
}

@end