//
//  ChatToolManager.m
//  LetChat
//
//  Created by SZT on 16/1/12.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ChatToolManager.h"
#import "MainClass.h"

@implementation ChatToolManager

static  ChatToolManager *chatTooManafer = nil;

+ (ChatToolManager *)defaultChatToolManager
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        chatTooManafer = [[ChatToolManager alloc]init];
        chatTooManafer.userMessage = [NSMutableDictionary dictionary];
        chatTooManafer.selectImages = [NSMutableArray array];
    });
    return chatTooManafer;
}

+ (CGFloat )heightForEmMessage:(EMMessage *)EMMessage;
{
    CGFloat height = 0;
    NSString *message = nil;
    id body = EMMessage.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//输入文本消息
        EMTextMessageBody *textBody = body;
        message = textBody.text;
    }
    
    //是发送方的消息还是接收方的消息

    CGSize maxSize = CGSizeMake(0, 0);
    if ([EMMessage.from isEqualToString: [ChatToolManager defaultChatToolManager].userName]) {              //我发送的消息 maxSize的公式参考 SendChatCell里面坐标的
        maxSize = CGSizeMake(kWidth-10-50-20-50, 2000);
    }else{                                                  // 别人发送给我的消息 maxSize的公式参考 ChatCell里面坐标的
        maxSize = CGSizeMake(kWidth-(10+20+50)-50, 2000);
    }
    NSDictionary *attributeDict = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]
                                    };
    CGSize textSize = [message boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributeDict context:nil].size;

    if (textSize.height+25 < 60) {
        height = 60;
    }else{
        height = textSize.height+20+5;
    }
    return height;
}

+ (CGSize)stringSize:(NSString *)string fontSize:(CGFloat)fontSize
{
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:fontSize]
                           };
   return  [string boundingRectWithSize:CGSizeMake(500, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil].size;
}


@end
