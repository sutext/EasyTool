//
//  ViewController.m
//  tooltest
//
//  Created by supertext on 15/1/28.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import "ViewController.h"
#import <EasyTools/EasyTools.h>
#import <Photos/Photos.h>
#import "TSPhotoController.h"
#import <objc/runtime.h>
@interface ViewController ()<ETActionSheetDelegate,ETPopoverControllerDelegate>


@end
@interface TSDownloadRequest : ETDesignedRequest<ETDownloadProtocol>

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    PHFetchOptions* fetchOptions = [[PHFetchOptions alloc] init];
//    fetchOptions.includeAllBurstAssets = YES;
//    fetchOptions.includeHiddenAssets = YES;
//    PHFetchResult *result=[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    
//    NSMutableArray *photoArray=[NSMutableArray array];
//    [result enumerateObjectsUsingBlock:^(PHAsset * obj, NSUInteger idx, BOOL *stop) {
//        [photoArray addObject:[[ETPhotoObject alloc] initWithImage:[UIImage imageWithColor:[UIColor colorWithWhite:idx%10/10.0 alpha:1] size:CGSizeMake(kETScreenWith, kETScreenHeight)] thumb:nil]];
//    }];
//    ETButton *button  = [[ETButton alloc] initWithStyle:ETButtonTitleStyleBottom];
//    [button setImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
//    [button setContentEdgeInsets:UIEdgeInsetsMake(10, 10,10, 10)];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
//    [button setClickedAction:^(ETButton *sender) {
//        ETPhotoBrowser *brow = [[ETPhotoBrowser alloc] initWithPhotos:photoArray startIndex:0 browservcClass:[TSPhotoController class]];
//        [brow show];
//        [self showActionSheet];
//        NSLog(@"%@",sender.titleLabel);
//    }];
//    button.imageSize=CGSizeMake(150, 50);
//    button.backgroundColor = [UIColor lightGrayColor];
//    [button setTitle:@"腾讯的微博哦放放" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.backgroundColor = [UIColor blueColor];
//    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    button.imageView.layer.cornerRadius = 5;
//    [button sizeToFit];
//    button.origin = CGPointMake(100, 100);
//    [self.view addSubview:button];
//    ETTextView *textview =[[ETTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 300)];
//    textview.placeholder =@"请输入名字";
//    [self.view addSubview:textview];
//    ETNetworkManager *mgr = [[ETNetworkManager alloc] initWithBaseURL:@"https://api.jj235.top/JJPNet" monitorName:@"api.jj235.top" timeoutInterval:10 successCode:200];
//    [mgr setDebugEnable:YES];
//    [mgr operationWithRequest:[[ETSimpleRequest alloc] initWithURL:@"goods/posterRecom" method:ETNetworkRequestMethodPOST params:nil] completedBlock:^(id<ETNetworkRequest> request, ETNetworkResponse *response, NSError *error) {
//        
//    }];
//    ETImageView *imageView = [[ETImageView alloc] initWithImage:[UIImage imageWithBadge:9]];
//    imageView.origin = CGPointMake(100, 100);
//    [self.view addSubview:imageView];
//    [imageView setTapAction:^(ETImageView *img) {
//        ETPopoverController *popover = [[ETPopoverController alloc] init];
//        popover.delegate = self;
//        [popover presentPopoverFromView:img inView:self.view animated:YES];
//    }];
//    [self setrightButtonItems];
    
    
//    NSString *strtime = @"2015-11-12 14:13:35";
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSLog(@"\nformater default zone:%@",formater.timeZone);
//    NSLog(@"\nobjc formater defalut zone date:%@",[formater dateFromString:strtime]);
//    NSLog(@"-------------------seaprator----------------");
//    formater.timeZone=[NSTimeZone localTimeZone];
//    NSLog(@"\nformater local zone:%@",formater.timeZone);
//    NSLog(@"\nobjc formater local zone  date:%@",[formater dateFromString:strtime]);
//    NSLog(@"-------------------seaprator----------------");
//    formater.timeZone=[NSTimeZone systemTimeZone];
//    NSLog(@"\nformater system zone:%@",formater.timeZone);
//    NSLog(@"\nobjc formater system zone  date:%@",[formater dateFromString:strtime]);
//    NSLog(@"-------------------seaprator----------------");
//    formater.timeZone=[NSTimeZone timeZoneForSecondsFromGMT:0];
//    NSLog(@"\nformater gmt zone:%@",formater.timeZone);
//    NSLog(@"\nobjc formater gmt zone  date:%@",[formater dateFromString:strtime]);
//    NSLog(@"-------------------seaprator----------------");
//    NSLog(@"\nc formater local zone  date:%@",[strtime dateWithFromat:@"%Y-%m-%d %H:%M:%S"]);
    
//    NSDate *currentDate = [NSDate date];
//    NSLog(@"sysdate:%@",currentDate);
//    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
//    dateformater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSLog(@"\nobjc formater default zone  string:%@",[dateformater stringFromDate:currentDate]);
//    dateformater.timeZone=[NSTimeZone timeZoneForSecondsFromGMT:0];
//    NSLog(@"\nobjc formater gmt zone  string:%@",[dateformater stringFromDate:currentDate]);
//    NSLog(@"\nc formater local zone  string:%@",[currentDate stringWithFormat:@"%Y-%m-%d %H:%M:%S"]);
//    NSLog(@"\n excahnge  string:%@",[[currentDate stringWithFormat:@"%Y-%m-%d %H:%M:%S"] dateWithFromat:@"%Y-%m-%d %H:%M:%S"]);
//    [content3 addSubview:test];
//    [content4 addSubview:test];
    ETImageView *imageView = [[ETImageView alloc] initWithFrame:CGRectMake(100, 100, 90, 90)];
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    [imageView setImageWithURL:@"http://doc.mding.org/IMG_0895.JPG" placeholder:nil completedBlock:nil];
}
-(void)setrightButtonItems
{
    ETNavigationBarItem *search = [ETNavigationBarItem itemWithTitle:@"你没" action:@selector(action)];
    search.badgeValue = 1;
    search.size = CGSizeMake(30, 15);
    ETNavigationBarItem *message = [ETNavigationBarItem itemWithTitle:@"尼玛" action:@selector(action)];
    message.badgeValue = -1;
    message.size = CGSizeMake(30, 15);
    [self setRightBarItems:@[message,search]];
}
-(void)action
{

}
-(void)popover:(ETPopoverController *)popover setupConfiguration:(ETPopoverViewConfig *)config
{
    config.items = @[@"你好",@"你好吗"];
    config.maxTextCount = 4;
//    config.direction = ETPopoverArrowDirectionUP;
}
-(void)testClassmap
{
}
-(void)showActionSheet
{
    ETActionSheet *sheet =[[ETActionSheet alloc] initWithStyle:ETActionSheetStyleRank1x3 delegate:self];
    sheet.titleLineCount = 2;
//    sheet.middleMargin = 50;
    [sheet show];
}
-(NSUInteger)numberOfItemsInActionSheet:(ETActionSheet *)actionSheet
{
    return 9;
}
-(void)actionSheet:(ETActionSheet *)actionSheet configActionItem:(ETActionSheetItem *)actionItem atIndex:(NSUInteger)index
{
    if (index%2==0) {
        actionItem.title  =@"腾讯微博啊啊啊啊啊";
    }
    else
    {
        actionItem.title  =@"腾讯微博";
    }
    
    actionItem.imageColor = [UIColor redColor];
}
-(void)actionSheet:(ETActionSheet *)actionSheet configCancelItem:(ETActionSheetItem *)cancelItem
{
    cancelItem.title = @"取消";
}
@end
