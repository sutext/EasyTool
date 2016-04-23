//
//  ETPhotoObject.m
//  EasyTool
//
//  Created by supertext on 14/12/15.
//  Copyright (c) 2014年 icegent. All rights reserved.
//

#import <EasyTools/ETPhotoObject.h>
@interface ETPhotoObject()
@property(nonatomic,readwrite)ETPhotoObjectType photoType;
@property(nonatomic,strong,readwrite)PHAsset *asset;

@property(nonatomic,strong,readwrite)UIImage *image;
@property(nonatomic,strong,readwrite)UIImage *thumb;

@property(nonatomic,strong,readwrite)NSString *imageURL;
@property(nonatomic,strong,readwrite)NSString *thumbURL;
@end
@implementation ETPhotoObject
- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        NSParameterAssert(asset);
        self.photoType=ETPhotoObjectTypeAlbum;
        self.asset=asset;
    }
    return self;
}
-(instancetype)initWithImage:(UIImage *)image thumb:(UIImage *)thumb
{
    self = [super init];
    if (self) {
        NSParameterAssert(image);
        self.photoType=ETPhotoObjectTypeLocal;
        self.image=image;
        self.thumb=thumb;
    }
    return self;
}
-(instancetype)initWithURL:(NSString *)imageURL thumbURL:(NSString *)thumbURL
{
    self = [super init];
    if (self) {
        NSParameterAssert(imageURL);
        self.photoType=ETPhotoObjectTypeRemote;
        self.imageURL=imageURL;
        self.thumbURL=thumbURL;
    }
    return self;
}
-(instancetype)copyWithZone:(NSZone *)zone
{
    ETPhotoObject *obj=nil;
    switch (self.photoType) {
        case ETPhotoObjectTypeLocal:
        {
            obj = [[[self class] alloc] initWithImage:self.image thumb:self.thumb];
            obj.imageURL = self.imageURL;
            obj.thumbURL = self.thumbURL;
        }break;
        case ETPhotoObjectTypeAlbum:
        {
            obj = [[[self class] alloc] initWithAsset:self.asset];
        } break;
        case ETPhotoObjectTypeRemote:
        {
            obj = [[[self class] alloc] initWithURL:self.imageURL thumbURL:self.thumbURL];
        } break;
            
        default:
            break;
    }
    obj.delegate = self.delegate;
    return obj;
}
-(CGRect)__originalRect
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(orginalRectForPhoto:)]) {
        return [self.delegate orginalRectForPhoto:self];
    }
    return CGRectNull;
}
@end
