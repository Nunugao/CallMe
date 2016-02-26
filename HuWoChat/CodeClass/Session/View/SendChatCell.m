//
//  SendChatCell.m
//  
//
//  Created by SZT on 16/1/12.
//
//

#import "SendChatCell.h"
#import "MainClass.h"
#import "PlayVoiceTool.h"

#define kVoiceWidth 20

#define fontSize  15

#define kLabelMarginW  20    //消息距离头像的水平距离
#define kImageLabelMargin 10  //消息和底部图片的约束

//头像的frame
#define kUserImageW  50
#define kUserImageH  50
#define kUserImageX  (kWidth-10-kUserImageW)
#define kUserImageY  5


//文本的frame
#define kMessageLabelX  (kUserImageX-kLabelMarginW)
#define kMessageLabelY  (kImageLabelMargin+kUserImageY)


@interface SendChatCell()

@property(nonatomic,strong)UIImageView *userImage;

@property(nonatomic,strong)UILabel *messageLabel;

@property(nonatomic,strong)UIImageView *messageView;

@end

@implementation SendChatCell

-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice:)];
        [_messageLabel addGestureRecognizer:tap];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return _messageLabel;
    
}



-(UIImageView *)userImage{
    if (!_userImage) {
        _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(kUserImageX, kUserImageY, kUserImageW, kUserImageH)];
        _userImage.image = [UIImage imageNamed:@"chatListCellHead@2x"];
    }
    return _userImage;
}

-(UIImageView *)messageView{
    if (!_messageView) {
        _messageView = [[UIImageView alloc]init];

        _messageView.image = [[UIImage imageNamed:@"chat_sender_bg@2x"]resizableImageWithCapInsets:UIEdgeInsetsMake(35, 4, 4, 35) resizingMode:(UIImageResizingModeStretch)];
    }
    return _messageView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.messageView];
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.messageLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setMessage:(NSString *)message
{
    CGSize maxSize = {kMessageLabelX-50,2000};
    NSDictionary *attributeDict = @{
                                    NSFontAttributeName :[UIFont systemFontOfSize:fontSize]
                                    };
    CGSize textSize = [message boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributeDict context:nil].size;
    
    self.messageLabel.frame = CGRectMake(kMessageLabelX-textSize.width, kMessageLabelY, textSize.width, textSize.height);
    self.messageLabel.text = message;
    self.messageView.frame = CGRectMake(kMessageLabelX-textSize.width-10, kMessageLabelY-10, textSize.width+20, textSize.height+20);
}

-(void)setEmMessage:(EMMessage *)emMessage
{
    if (_emMessage != emMessage) {
        _emMessage = emMessage;
    }
    id body = emMessage.messageBodies[0];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {//文本信息
        EMTextMessageBody *textBody = body;
        [self setMessage:textBody.text];
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){//语音信息
        
        self.messageLabel.attributedText = [self voiceAtt:body];
        
        self.messageLabel.frame = CGRectMake(kMessageLabelX-90, kMessageLabelY, 90, kVoiceWidth);
        self.messageView.frame = CGRectMake(kMessageLabelX-90-10, kMessageLabelY-10, 90+20, kVoiceWidth+20);
    }
    
}

//语音富文本
- (NSAttributedString *)voiceAtt:(EMVoiceMessageBody *)voiceBoddy
{
    NSMutableAttributedString *voiceAttm = [[NSMutableAttributedString alloc]init];
    
    NSTextAttachment *imgAttachment = [[NSTextAttachment alloc]init];
    
    //    拼接时间富文本
    //    voiceBoddy = self.emMessage.messageBodies[0];
    NSInteger duration = voiceBoddy.duration;
    NSString *timeStr = [NSString stringWithFormat:@"%ld '",duration];
    NSAttributedString *timeAtt = [[NSAttributedString alloc]initWithString:timeStr];
    [voiceAttm appendAttributedString:timeAtt];

    UIImage *receiveImage = [UIImage imageNamed:@"chat_sender_audio_playing_full"];
    imgAttachment.image = receiveImage;
    imgAttachment.bounds = CGRectMake(0, 0, kVoiceWidth, kVoiceWidth);
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:imgAttachment];
    [voiceAttm appendAttributedString:imgAtt];
        return [voiceAttm copy];
}


#pragma mark------------播放语音------------------
- (void)playVoice:(UITapGestureRecognizer *)tap
{
    id body = self.emMessage.messageBodies[0];
    if ([body isKindOfClass:[EMVoiceMessageBody class]]) {
        
        [[PlayVoiceTool sharePlayVoiceTool] playVoiceWithEMMessage:self.emMessage messageLabel:self.messageLabel];
    }
}




@end
