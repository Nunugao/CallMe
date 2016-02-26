//
//  ChatToolManager.h
//  LetChat
//
//  Created by SZT on 16/1/12.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width


//选择好工作类型发出的通知
#define selectedWorkTypeNotification   @"selectedWorkTypeNotification"

//编辑好简历的时候发出通知
#define editResumeNotification @"editResumeNotification"


//所有的工作简历（是一个数组）都存放在属性列表NSUserDefaults 中,key值就是allWorkExperience
#define allWorkExperience  @"allWorkExperience"

@interface ChatToolManager : NSObject

@property(nonatomic,copy)NSString *userName;//当前用户名

@property(nonatomic,strong)NSMutableArray *selectImages;//照片墙的图片

@property(nonatomic,strong)NSMutableDictionary *userMessage;//用户已经选好的标签

+ (ChatToolManager *)defaultChatToolManager;

+ (CGFloat )heightForEmMessage:(EMMessage *)EMMessage;

+ (CGSize)stringSize:(NSString *)string fontSize:(CGFloat)fontSize;



@end
