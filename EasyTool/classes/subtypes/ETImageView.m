//
//  ETImageView.m
//  EasyTool
//
//  Created by supertext on 14-6-9.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETImageView.h>
#import <EasyTools/ETPhotoManager.h>
#import <EasyTools/UIImageView+AFNetworking.h>
@interface ETImageView()
@property(nonatomic,strong)UITapGestureRecognizer *tapges;
@property(nonatomic,weak)ETPhotoOperation *photoOperation;
@end
@implementation ETImageView

-(UITapGestureRecognizer *)tapges
{
    if (!_tapges) {
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector)];
        tapGesture.numberOfTapsRequired=1;
        self.tapges=tapGesture;
    }
    return _tapges;
}
-(void)setTapAction:(void (^)(ETImageView *))tapAction
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
-(void)setImageWithURL:(NSString *)url placeholder:(UIImage *)placeholder completedBlock:(void (^)(UIImage * _Nullable, NSError * _Nullable, ETImageView * _Nonnull))compltedBlock
{
    if (!url) {
        if (compltedBlock) {
            compltedBlock(nil,[NSError errorWithDomain:@"ETImageErorrDomian" code:NSNotFound userInfo:@{@"message":@"url cannot be nil"}],self);
        }
        return;
    }
    if ([url hasPrefix:@"http://"]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        __weak typeof(self) weakself =self;
        [self setImageWithURLRequest:request
                    placeholderImage:placeholder
                             success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                 weakself.image = image;
                                 if (compltedBlock) {
                                     compltedBlock(image,nil,weakself);
                                 }
        }
                             failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                 if (compltedBlock) {
                                     compltedBlock(nil,error ,weakself);
                                 }
        }];
    }
    else
    {
        if (placeholder) {
            self.image=placeholder;
        }
        UIImage *img=[UIImage imageWithContentsOfFile:url];
        if (img) {
            self.image=img;
            if (compltedBlock) {
                compltedBlock(img,nil,self);
            }
        }
        else
        {
            if (compltedBlock) {
                compltedBlock(nil,[NSError errorWithDomain:@"ETImageErorrDomian" code:NSNotFound userInfo:nil],self);
            }
        }
    }
}
-(void)setImageWithAsset:(PHAsset *)asset placeholder:(UIImage *)placeholder completedBlock:(void (^)(UIImage *,NSError *))completedBlock
{
    [self.photoOperation cancel];
    if (placeholder) {
        self.image = placeholder;
    }
    self.photoOperation = [[ETPhotoManager sharedManager] imageWithAsset:asset completedBlock:^(UIImage *image, NSError *error) {
        if (image) {
            self.image=image;
        }
        if (completedBlock) {
            completedBlock(image,error);
        }
    }];
}
-(void)setThumbWithAsset:(PHAsset *)asset placeholder:(UIImage *)placeholder targetSize:(CGSize)targetSize completedBlock:(void (^)(UIImage *, NSError *))completedBlock
{
    if (placeholder) {
        self.image = placeholder;
    }
    [[ETPhotoManager sharedManager] thumbWithAsset:asset targetSize:targetSize completedBlock:^(UIImage *image, NSError *error) {
        if (image) {
            self.image=image;
        }
        if (completedBlock) {
            completedBlock(image,error);
        }
    }];
}
@end