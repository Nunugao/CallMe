//
//  PhotoWall.m
//  HuWoChat
//
//  Created by SZT on 16/1/27.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "PhotoWall.h"
#import "Masonry.h"

#define kMargin 2
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kImageWidth  (kScreenWidth - 2*kMargin)/3

@interface PhotoWall()

/*
 1 2
   3
 456
 */

@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)UIImageView *imageView3;
@property(nonatomic,strong)UIImageView *imageView4;
@property(nonatomic,strong)UIImageView *imageView5;
@property(nonatomic,strong)UIImageView *imageView6;


@end

@implementation PhotoWall

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //最大的一张
        UIImageView *userImage = [UIImageView new];
        userImage.backgroundColor = [UIColor redColor];
        [self addSubview:userImage];
        userImage.tag = 100;
        userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addOrDeletePhoto:)];
        [userImage addGestureRecognizer:tap];
        [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.width.equalTo(@(kScreenWidth - kImageWidth - kMargin));
            make.height.equalTo(@(kScreenWidth - kImageWidth - kMargin));
        }];
        //右上两张图片
        for (int i = 1; i < 3; i ++) {
            UIImageView *userImage = [UIImageView new];
            userImage.backgroundColor = [UIColor redColor];
            [self addSubview:userImage];
            userImage.tag = 100+i;
            userImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addOrDeletePhoto:)];
            [userImage addGestureRecognizer:tap];
            [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(2*(kImageWidth+kMargin));
                make.top.equalTo(self.mas_top).with.offset((i-1)*(kImageWidth + kMargin));
                make.width.equalTo(@(kImageWidth));
                make.height.equalTo(@(kImageWidth));
            }];
        }
        
        
        //下面三张图片
        for (int i = 3; i < 6; i ++) {
            UIImageView *userImage = [UIImageView new];
            userImage.backgroundColor = [UIColor redColor];
            [self addSubview:userImage];
            userImage.tag = 100+i;
            userImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addOrDeletePhoto:)];
            [userImage addGestureRecognizer:tap];
            [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset((i-3)*(kImageWidth+kMargin));
                make.bottom.equalTo(self.mas_bottom).with.offset(0);
                make.width.equalTo(@(kImageWidth));
                make.height.equalTo(@(kImageWidth));
            }];
        }
    }
    return self;
}

- (void)addOrDeletePhoto:(UITapGestureRecognizer *)tap
{
    [self.delegate selectPhotoWall:tap];
}





@end
