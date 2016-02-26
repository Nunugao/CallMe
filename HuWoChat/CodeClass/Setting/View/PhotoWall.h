//
//  PhotoWall.h
//  HuWoChat
//
//  Created by SZT on 16/1/27.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectPhotoWall <NSObject>

- (void)selectPhotoWall:(UITapGestureRecognizer *)tap;


@end

@interface PhotoWall : UIView

@property(nonatomic,assign)id<SelectPhotoWall>  delegate;

@end
