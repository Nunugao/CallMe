//
//  PlayVoiceTool.h
//  LetChat
//
//  Created by SZT on 16/1/15.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"


@interface PlayVoiceTool : NSObject

- (void)playVoiceWithEMMessage:(EMMessage *)emmessage;

- (void)playVoiceWithEMMessage:(EMMessage *)emmessage messageLabel:(UILabel *)label;

+ (PlayVoiceTool *)sharePlayVoiceTool;

@end
