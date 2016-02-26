//
//  PlayVoiceTool.m
//  LetChat
//
//  Created by SZT on 16/1/15.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "PlayVoiceTool.h"
#import "EMCDDeviceManager.h"
#import "ChatToolManager.h"

@implementation PlayVoiceTool
static  PlayVoiceTool *playTool = nil;


- (void)playVoiceWithEMMessage:(EMMessage *)emmessage 
{
    EMVoiceMessageBody *voicbody = emmessage.messageBodies[0];
    NSString *voicePath = voicbody.localPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:voicePath]) {
        voicePath  = voicbody.remotePath;
    }
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
        NSLog(@"语音播放结束");
    }];
    
}

- (void)playVoiceWithEMMessage:(EMMessage *)emmessage messageLabel:(UILabel *)label
{
    UIImageView *animationView = [[UIImageView alloc]initWithFrame:        CGRectMake(0, 0, 20, 20)];
    [label addSubview:animationView];
    EMVoiceMessageBody *voicbody = emmessage.messageBodies[0];
    NSString *voicePath = voicbody.localPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:voicePath]) {
        voicePath  = voicbody.remotePath;
    }
    [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
        NSLog(@"语音播放结束");
        [animationView stopAnimating];
        [animationView removeFromSuperview];
    }];
    NSMutableArray *imageArray = [NSMutableArray array];
    animationView.animationDuration = 1;
    NSString *imageName = nil;
    
    /*判断是发送者还是接收者*/
    NSString *userName = [ChatToolManager defaultChatToolManager].userName;
    if ([emmessage.from isEqualToString:userName]) {//是我发送的
        imageName = @"chat_sender_audio_playing_";
        animationView.frame = CGRectMake(17, 0, 20, 20);
    }else{//是别人发送给我的
        imageName = @"chat_receiver_audio_playing";

    }
    
    for (int i = 0; i < 3; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat: @"%@00%d",imageName,i]];
        [imageArray addObject:image];
    }
    [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@full",imageName]]];
    animationView.animationImages = imageArray;
    [animationView startAnimating];
    
    
}

+ (PlayVoiceTool *)sharePlayVoiceTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playTool = [[PlayVoiceTool alloc]init];
    });
    return playTool;
}

@end
