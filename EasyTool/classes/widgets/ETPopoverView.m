//
//  ETPopoverView.m
//  EasyTool
//
//  Created by supertext on 15/11/6.
//  Copyright © 2015年 icegent. All rights reserved.
//

#import "ETPopoverView.h"
#import <EasyTools/EasyTool.h>
@interface ETPopoverView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong,readwrite)ETPopoverViewConfig* config;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation ETPopoverView
-(instancetype)initWithConfig:(ETPopoverViewConfig *)config
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.config=config;
        NSInteger _maxTextWidth=config.maxTextCount*20 + 20;
        NSInteger showCount=self.config.items.count>config.maxLineCount?:self.config.items.count;
        self.frame=CGRectMake(0, 0, _maxTextWidth, showCount*config.itemHeight+config.anchorHeight);
        CGFloat top = 0;
        if (config.direction == ETPopoverArrowDirectionUP) {
            top=config.anchorHeight;
        }
        //table
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,top, _maxTextWidth, showCount*config.itemHeight)];
        [self addSubview:tableView];
        tableView.showsVerticalScrollIndicator=NO;
        tableView.backgroundColor=[UIColor clearColor];
        tableView.dataSource=self;
        tableView.delegate=self;
        tableView.rowHeight = config.itemHeight;
        tableView.scrollEnabled=config.items.count>config.maxLineCount;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //shadow
        self.backgroundColor = config.backgroundColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(-1, 1);
        self.layer.shadowOpacity = 0.5;
        
        self.tableView=tableView;
    }
    return self;
}
-(void)setAnchorPosition:(CGFloat)anchorPosition
{
    if (anchorPosition<self.config.cornerRadius+5) {
        _anchorPosition=self.config.cornerRadius+5;
    }
    else if(anchorPosition >self.bounds.size.width-self.config.cornerRadius-5)
    {
        _anchorPosition=self.bounds.size.width-self.config.cornerRadius-5;
    }
    else
    {
        _anchorPosition=anchorPosition;
    }
}
-(void)drawRect:(CGRect)rect
{
    if (self.config.anchorHeight>0) {
        CGSize size=rect.size;
        CGFloat cornerRadius = self.config.cornerRadius;
        NSUInteger anchorHeight = self.config.anchorHeight;
        UIBezierPath *path=[UIBezierPath bezierPath];
        if (self.config.direction==ETPopoverArrowDirectionDown)
        {
            [path moveToPoint:CGPointMake(cornerRadius, 0)];
            [path addQuadCurveToPoint:CGPointMake(0, cornerRadius) controlPoint:CGPointZero];
            
            [path addLineToPoint:CGPointMake(0, size.height-anchorHeight-cornerRadius)];
            [path addQuadCurveToPoint:CGPointMake(cornerRadius, size.height-anchorHeight) controlPoint:CGPointMake(0, size.height-5)];
            
            [path addLineToPoint:CGPointMake(self.anchorPosition-3, size.height-anchorHeight)];
            [path addLineToPoint:CGPointMake(self.anchorPosition, size.height)];
            [path addLineToPoint:CGPointMake(self.anchorPosition+3, size.height-anchorHeight)];
            [path addLineToPoint:CGPointMake(size.width-cornerRadius, size.height-anchorHeight)];
            [path addQuadCurveToPoint:CGPointMake(size.width, size.height-anchorHeight-cornerRadius) controlPoint:CGPointMake(size.width, size.height-anchorHeight)];
            
            [path addLineToPoint:CGPointMake(size.width, cornerRadius)];
            [path addQuadCurveToPoint:CGPointMake(size.width-cornerRadius, 0) controlPoint:CGPointMake(size.width, 0)];
            
            [path closePath];
        }
        else
        {
            [path moveToPoint:CGPointMake(size.width-cornerRadius, size.height)];
            [path addQuadCurveToPoint:CGPointMake(size.width,size.height-cornerRadius) controlPoint:CGPointMake(size.width, size.height)];
            
            [path addLineToPoint:CGPointMake(size.width,anchorHeight+cornerRadius)];
            [path addQuadCurveToPoint:CGPointMake(size.width-cornerRadius,anchorHeight) controlPoint:CGPointMake(size.width, 5)];
            
            [path addLineToPoint:CGPointMake(self.anchorPosition+3,anchorHeight)];
            [path addLineToPoint:CGPointMake(self.anchorPosition, 0)];
            [path addLineToPoint:CGPointMake(self.anchorPosition-3,anchorHeight)];
            [path addLineToPoint:CGPointMake(cornerRadius,anchorHeight)];
            [path addQuadCurveToPoint:CGPointMake(0,anchorHeight+cornerRadius) controlPoint:CGPointMake(0,anchorHeight)];
            
            [path addLineToPoint:CGPointMake(0,size.height- cornerRadius)];
            [path addQuadCurveToPoint:CGPointMake(cornerRadius, size.height) controlPoint:CGPointMake(0, size.height)];
            
            [path closePath];
        }
        
        [self.config.backgroundColor setFill];
        [path fill];
        
        [self drawBorderInRect:rect];
    }
    else
    {
        [super drawRect:rect];
    }
}
-(void)drawBorderInRect:(CGRect)rect
{
    CGSize size=rect.size;
    CGFloat cornerRadius=self.config.cornerRadius;
    NSUInteger anchorHeight = self.config.anchorHeight;
    UIBezierPath *path=[UIBezierPath bezierPath];
    if (self.config.direction==ETPopoverArrowDirectionDown)
    {
        [path moveToPoint:CGPointMake(cornerRadius, 0)];
        [path addQuadCurveToPoint:CGPointMake(0, cornerRadius) controlPoint:CGPointZero];
        
        [path addLineToPoint:CGPointMake(0, size.height-anchorHeight-cornerRadius)];
        [path addQuadCurveToPoint:CGPointMake(cornerRadius, size.height-anchorHeight) controlPoint:CGPointMake(0, size.height-5)];
        
        [path addLineToPoint:CGPointMake(self.anchorPosition-3, size.height-anchorHeight)];
        [path addLineToPoint:CGPointMake(self.anchorPosition, size.height)];
        [path addLineToPoint:CGPointMake(self.anchorPosition+3, size.height-anchorHeight)];
        [path addLineToPoint:CGPointMake(size.width-cornerRadius, size.height-anchorHeight)];
        [path addQuadCurveToPoint:CGPointMake(size.width, size.height-anchorHeight-cornerRadius) controlPoint:CGPointMake(size.width, size.height-anchorHeight)];
        
        [path addLineToPoint:CGPointMake(size.width, cornerRadius)];
        [path addQuadCurveToPoint:CGPointMake(size.width-cornerRadius, 0) controlPoint:CGPointMake(size.width, 0)];
        
        [path closePath];
    }
    else
    {
        [path moveToPoint:CGPointMake(size.width-cornerRadius, size.height)];
        [path addQuadCurveToPoint:CGPointMake(size.width,size.height-cornerRadius) controlPoint:CGPointMake(size.width, size.height)];
        
        [path addLineToPoint:CGPointMake(size.width,anchorHeight+cornerRadius)];
        [path addQuadCurveToPoint:CGPointMake(size.width-cornerRadius,anchorHeight) controlPoint:CGPointMake(size.width, 5)];
        
        [path addLineToPoint:CGPointMake(self.anchorPosition+3,anchorHeight)];
        [path addLineToPoint:CGPointMake(self.anchorPosition, 0)];
        [path addLineToPoint:CGPointMake(self.anchorPosition-3,anchorHeight)];
        [path addLineToPoint:CGPointMake(cornerRadius,anchorHeight)];
        [path addQuadCurveToPoint:CGPointMake(0,anchorHeight+cornerRadius) controlPoint:CGPointMake(0,anchorHeight)];
        
        [path addLineToPoint:CGPointMake(0,size.height- cornerRadius)];
        [path addQuadCurveToPoint:CGPointMake(cornerRadius, size.height) controlPoint:CGPointMake(0, size.height)];
        
        [path closePath];
    }
    path.lineWidth=0.2;
    [self.config.backgroundColor set];
    [path stroke];
}
#pragma mark UITableViewDataSource and UITableViewDelegate  methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.config.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *bgView=[[UIView alloc] init];
        bgView.backgroundColor=self.config.selectedColor;
        bgView.clipsToBounds=YES;
        cell.selectedBackgroundView=bgView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, self.config.itemHeight-0.5, tableView.frame.size.width-10, 0.5)];
        line.backgroundColor = self.config.separatorColor;
        cell.runtimeObject=line;
        [cell addSubview:line];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=self.config.font;
        cell.textLabel.textColor = self.config.textColor;
        cell.textLabel.textAlignment=self.config.textAlignment;
    }
    ETPopoverViewItem *item = self.config.items[indexPath.row];
    cell.textLabel.text=item.title;
    cell.imageView.image = item.icon;
    if (indexPath.row==self.config.items.count-1) {
        [cell.runtimeObject setHidden:YES];
    }
    else
    {
        [cell.runtimeObject setHidden:NO];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickedAtIndex) {
        self.clickedAtIndex(self,indexPath.row,self.config.items[indexPath.row]);
    }
}
@end

@implementation ETPopoverViewItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon data:(nullable id)data
{
    self = [super init];
    if (self) {
        [self setValue:title forKey:@"title"];
        [self setValue:icon forKey:@"icon"];
        [self setValue:data forKey:@"bindData"];
    }
    return self;
}

@end

@implementation ETPopoverViewConfig
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
+(instancetype)appearance
{
    static dispatch_once_t onceToken = 0;
    static ETPopoverViewConfig *_appearance;
    dispatch_once(&onceToken, ^{
        _appearance= [[self alloc] initAppearance];
    });
    return _appearance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        ETPopoverViewConfig *config = [ETPopoverViewConfig appearance];
        self.direction              = config.direction;
        self.font                   = config.font;
        self.backgroundColor        = config.backgroundColor;
        self.selectedColor          = config.selectedColor;
        self.textColor              = config.textColor;
        self.separatorColor         = config.separatorColor;
        self.cornerRadius           = config.cornerRadius;
        self.itemHeight             = config.itemHeight;
        self.textAlignment          = config.textAlignment;
        self.anchorHeight           = config.anchorHeight;
        self.maxLineCount           = config.maxLineCount;
        self.maxTextCount           = config.maxTextCount;
    }
    return self;
}
- (instancetype)initAppearance
{
    self = [super init];
    if (self) {
        self.direction              = ETPopoverArrowDirectionDown;
        self.font                   = [UIFont systemFontOfSize:14];
        self.backgroundColor        = [UIColor colorWithWhite:0 alpha:0.7];
        self.selectedColor          = [UIColor colorWithWhite:0.5 alpha:0.7];
        self.textColor              = [UIColor whiteColor];
        self.separatorColor         = [UIColor whiteColor];
        self.cornerRadius           = 6;
        self.itemHeight             = 35;
        self.textAlignment          = NSTextAlignmentCenter;
        self.anchorHeight           = 5;
        self.maxTextCount           = 5;
        self.maxLineCount           = 5;
    }
    return self;
}

@end