//
//  CommunicateViewController.m
//  LetChat
//
//  Created by SZT on 16/1/10.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "CommunicateViewController.h"
#import "MainClass.h"
#import "ChatCell.h"
#import "SendChatCell.h"
#import "EaseMob.h"
#import "ChatToolManager.h"
#import "EMCDDeviceManager.h"
#import "CallViewController.h"

#define kMarginX 10
#define kFontSize 15

#define kInputToolViewW  kWidth
#define kInputToolViewH  46
#define kInputToolViewX  0
#define kInputToolViewY  kHeight-kInputToolViewH

#define kLeftButtonW  30
#define kLeftButtonH  30
#define kLeftButtonX  kMarginX
#define kLeftButtonY  (kInputToolViewH-kLeftButtonH)/2

#define kTextViewX   (kLeftButtonX+kLeftButtonW+kMarginX)
#define kTextViewY   (kInputToolViewH-kLeftButtonH)/2
#define kTextViewW   (kWidth-3*kLeftButtonW-5*kMarginX)
#define kTextViewH   33

#define kEmojiX   (kTextViewX+kTextViewW+kMarginX)
#define kEmojiY   kMarginX
#define kEmojiW   kLeftButtonW
#define kEmojiH   kLeftButtonH

#define kOtherX   (kEmojiX+kEmojiW+kMarginX)
#define kOtherY    kMarginX
#define kOtherW    kLeftButtonW
#define kOtherH    kLeftButtonH


#define kTableViewX  0
#define kTableViewY  0
#define kTableViewW  kWidth
#define kTableViewH  kHeight



@interface CommunicateViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,EMChatManagerDelegate>

@property(nonatomic,strong)UIView *inputToolBar;

@property(nonatomic,strong)UITextView *inputText;

@property(nonatomic,strong)UIButton *emojiButton;

@property(nonatomic,strong)UIButton *voiceButton;

@property(nonatomic,strong)UIButton *otherButton;

@property(nonatomic,strong)UIButton *pressButton;

@property(nonatomic,strong)UITableView *messageTableView;

@property(nonatomic,strong)NSMutableArray *messageRecord;

@property(nonatomic,assign)CGFloat keyBoardY;

@end

@implementation CommunicateViewController

-(UIButton *)pressButton{
    if (!_pressButton) {
        _pressButton = [[UIButton alloc]initWithFrame:CGRectMake(kTextViewX, kTextViewY, kTextViewW, kTextViewH)];
        _pressButton.backgroundColor = [UIColor grayColor];
        _pressButton.hidden = YES;
        [_pressButton setTitle:@"按住说话" forState:(UIControlStateNormal)];
        [_pressButton setTitle:@"松开发送" forState:(UIControlStateHighlighted)];
        [_pressButton addTarget:self action:@selector(beginRecordVoice:) forControlEvents:(UIControlEventTouchDown)];
        [_pressButton addTarget:self action:@selector(endRecordVoice:) forControlEvents:(UIControlEventTouchUpInside)];
        [_pressButton addTarget:self action:@selector(cancelRecoreVoic:) forControlEvents:(UIControlEventTouchUpOutside)];
    }
    return _pressButton;
}


-(NSMutableArray *)messageRecord{
    if (!_messageRecord) {
        _messageRecord = [[NSMutableArray alloc]init];
    }
    return _messageRecord;
}



-(UITableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(kTableViewX, kTableViewY, kTableViewW, kTableViewH) style:(UITableViewStylePlain)];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        
    }
    return _messageTableView;
}



-(UITextView *)inputText{
    if (!_inputText) {
        _inputText = [[UITextView alloc]initWithFrame:CGRectMake(kTextViewX, kTextViewY, kTextViewW, kTextViewH) textContainer:nil];
        _inputText.layer.masksToBounds = YES;
        _inputText.returnKeyType = UIReturnKeySend;
        _inputText.delegate = self;
        _inputText.font = [UIFont systemFontOfSize:kFontSize];
//        _inputText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _inputText.layer.cornerRadius = 5;
    }
    return _inputText;
}


-(UIButton *)emojiButton{
    if (!_emojiButton) {
        _emojiButton= [[UIButton alloc]initWithFrame:CGRectMake(kEmojiX, kEmojiY, kEmojiW, kEmojiH)];
        [_emojiButton setImage:[UIImage imageNamed:@"chatBar_face@2x"] forState:(UIControlStateNormal)];
    }
    return _emojiButton;
}

//录音和文本输入切换
-(UIButton *)voiceButton
{
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc]initWithFrame:CGRectMake(kLeftButtonX, kLeftButtonY, kLeftButtonW, kLeftButtonH)];
        [_voiceButton setImage:[UIImage imageNamed:@"chatBar_keyboard@2x"] forState:(UIControlStateNormal)];
        [_voiceButton addTarget:self action:@selector(voiceButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _voiceButton;
}

-(UIButton *)otherButton{
    if (!_otherButton) {
        _otherButton = [[UIButton alloc]initWithFrame:CGRectMake(kOtherX, kOtherY, kOtherW, kOtherH)];
        [_otherButton setImage:[UIImage imageNamed:@"chatBar_more@2x"] forState:(UIControlStateNormal)];
        [_otherButton addTarget:self action:@selector(selectOtherAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _otherButton;
}

-(UIView *)inputToolBar{
    if (!_inputToolBar) {
        _inputToolBar = [[UIView alloc]initWithFrame:CGRectMake(kInputToolViewX, kInputToolViewY, kInputToolViewW, kInputToolViewH)];
        _inputToolBar.backgroundColor = [UIColor grayColor];
        [_inputToolBar addSubview:self.voiceButton];
        [_inputToolBar addSubview:self.inputText];
        [_inputToolBar addSubview:self.emojiButton];
        [_inputToolBar addSubview:self.otherButton];
        [_inputToolBar addSubview:self.pressButton];
    }
    
    return _inputToolBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.friendTitle;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.messageTableView];
    [self.view insertSubview:self.inputToolBar aboveSubview:self.messageTableView];
//    [self.view addSubview:self.inputToolBar];
    
//    设置聊天管理器代理
    [[EaseMob sharedInstance].chatManager addDelegate:(self) delegateQueue:nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(backButtonAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self.messageTableView registerClass:[ChatCell class] forCellReuseIdentifier:@"receiveCell"];
    
    [self.messageTableView registerClass:[SendChatCell class] forCellReuseIdentifier:@"sendCell"];
    
//    加载本地聊天记录
    [self loadMessageRecord];
    
    UIBarButtonItem *videoButton = [[UIBarButtonItem alloc]initWithTitle:@"视频" style:(UIBarButtonItemStylePlain) target:self action:@selector(videoCommunicate:)];
    self.navigationItem.rightBarButtonItem = videoButton;

}


#pragma mark------------视频通话------------------

- (void)videoCommunicate:(UIBarButtonItem *)button
{
    
    BOOL isopen = [CallViewController canVideo];
    if (!isopen) {
        NSLog(@"摄像头没法打开........");
        return;
    }
    EMError *error = nil;
    NSString *chatter = self.friendTitle;
    EMCallSessionType type = eCallSessionTypeVideo;
    EMCallSession *callSession = nil;
    
    callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
    if (callSession && !error) {
//        [[EaseMob sharedInstance].callManager removeDelegate:self];
        
        CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:callController animated:NO completion:nil];
    }


}

#pragma mark------------开始录音------------------

- (void)beginRecordVoice:(UIButton *)button
{
    int x = arc4random()%100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            NSLog(@"开始录音成功");
        }else{
            NSLog(@"开始录音失败");
        }
    }];
}

#pragma mark------------ 结束录音------------------

- (void)endRecordVoice:(UIButton *)button
{
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSLog(@"结束录音成功");
            NSLog(@"%@",recordPath);
            //            发送语音给服务器
            [self sendVoice:recordPath duration:aDuration];
        }
    }];
    
}
#pragma mark------------取消录音------------------

- (void)cancelRecoreVoic:(UIButton *)button
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}




#pragma mark------------录音和文本输入切换------------------

- (void)voiceButtonAction:(UIButton *)button
{
    self.pressButton.hidden = !self.pressButton.hidden;
    if (self.pressButton.hidden == YES) {//此时是在发文本
        
        [self.voiceButton setImage:[UIImage imageNamed:@"chatBar_keyboard@2x"] forState:(UIControlStateNormal)];
        [self.inputText becomeFirstResponder];
        
    }else{//此时是在发语音
        
        [_voiceButton setImage:[UIImage imageNamed:@"chatBar_record@2x"] forState:(UIControlStateNormal)];
        
        [self.view endEditing:YES];
        
    }
}



#pragma mark------------数据元------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageRecord.count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *receiveID = @"receiveCell";
    static NSString *sendID = @"sendCell";
    EMMessage *emMessage = self.messageRecord[indexPath.row];
    if ([emMessage.from isEqualToString:self.friendTitle]) {//发送方
        ChatCell *chatcell = [tableView dequeueReusableCellWithIdentifier:receiveID];
        chatcell.emMessage = emMessage;
        chatcell.backgroundColor = [UIColor grayColor];
        return chatcell;

    }else{//接收方
        SendChatCell *sendCell = [tableView dequeueReusableCellWithIdentifier:sendID];
        sendCell.emMessage = emMessage;
        sendCell.backgroundColor = [UIColor grayColor];
        return sendCell;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *emMessage = self.messageRecord[indexPath.row];
    return [ChatToolManager heightForEmMessage:emMessage];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}





#pragma mark------------键盘操作------------------

- (void)keybordWillShow:(NSNotification *)notification
{
    CGRect keyRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat inputY = keyRect.origin.y;
        self.keyBoardY = inputY;
//        NSLog(@"-----%.2f------keyBoardY",inputY);
//        self.inputToolBar.frame = CGRectMake(0, kInputToolViewY-(kHeight-inputY), kWidth, kInputToolViewH);
        self.view.frame = CGRectMake(0, 0-kHeight+inputY, kWidth, kHeight);
        self.messageTableView.frame = CGRectMake(kTableViewX, kHeight-inputY, kWidth, inputY);
        [self.messageTableView reloadData];
        if (self.messageRecord.count != 0) {
            
            [self messageViewScrollToBottom];
        }

    }];
}

- (void)keyBordWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
//        self.inputToolBar.frame = CGRectMake(kInputToolViewX, kInputToolViewY, kInputToolViewW, kInputToolViewH);
        self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.messageTableView.frame = CGRectMake(0, 0, kWidth, kHeight);
    }];
}

#pragma mark------------判断是否按下“发送”键，是的话发送消息------------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"发送%@的信息:",textView.text);
        //发送消息
        [self sendMessage:textView.text];
        textView.text = nil;
        return NO;
    }else{
        
        return YES;
    }
}

#pragma mark------------加载本地聊天记录------------------

-(void)loadMessageRecord
{
    EMConversation *emConversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.friendTitle conversationType:(eConversationTypeChat)];
    NSArray *messageArray = [emConversation loadAllMessages];
    for (EMMessage *message in messageArray) {
        [self.messageRecord addObject:message];
    }
    if (self.messageRecord.count != 0) {
        [self messageViewScrollToBottom];
    }
}

#pragma mark------------接收到好友消息------------------
-(void)didReceiveMessage:(EMMessage *)message
{
    if ([message.from isEqualToString:self.friendTitle]) {
        
        [self.messageRecord addObject:message];
        [self.messageTableView reloadData];
        [self messageViewScrollToBottom];
    }
}

#pragma mark------------发送文本消息------------------

- (void)sendMessage:(NSString *)message
{
    /*
     EMTextMessageBody
     EMImageMessageBody
     EMVideoMessageBody
     EMVoiceMessageBody
     EMLocationMessageBody
     */
    EMChatText *chattext = [[EMChatText alloc]initWithText:message];
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc]initWithChatObject:chattext];
    EMMessage *messageObject = [[EMMessage alloc]initWithReceiver:self.friendTitle bodies:@[textBody]];
    [[EaseMob sharedInstance].chatManager asyncSendMessage:messageObject progress:nil prepare:^(EMMessage *message, EMError *error) {
        
//        将要发送的消息更新到聊天界面中，并滚动聊天界面到底部
        [self.messageRecord addObject:message];
        [self.messageTableView reloadData];
        [self messageViewScrollToBottom];
        
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"完成发送消息 ");
    } onQueue:nil];
}

#pragma mark------------发送录音文件------------------
- (void)sendVoice:(NSString *)recordPath duration:(NSInteger)duration
{
//    语音消息体
    EMChatVoice *voicefile = [[EMChatVoice alloc]initWithFile:recordPath displayName:@"语音"];
    EMVoiceMessageBody *voice = [[EMVoiceMessageBody alloc]initWithChatObject:voicefile];
    voice.duration = duration;
    
    EMMessage *msgObj = [[EMMessage alloc]initWithReceiver:self.friendTitle bodies:@[voice]];
    msgObj.messageType = eMessageTypeChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgObj progress:nil prepare:^(EMMessage *message, EMError *error) {
        
        [self.messageRecord addObject:message];
        [self.messageTableView reloadData];
        [self messageViewScrollToBottom];
        
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            NSLog(@"语音发送成功");
        }else{
            NSLog(@"语音发送成功");
        }
        
    } onQueue:nil];
    
    
}


- (void)selectOtherAction:(UIButton *)button
{
    [self.view endEditing:YES];
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-180, kWidth, 180)];
    videoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:videoView];
    CGFloat buttonWidth = kWidth-5*10;
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+i*buttonWidth, 10, buttonWidth, buttonWidth)];
        [videoView addSubview:button];
        button.tag = 100 + i;
        [button setTitle:@"dian" forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(anyButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }

}

- (void)anyButton:(UIButton *)button
{
    NSLog(@"多功能");
}


// $(SRCROOT)/项目名/pch名字

//根据输入文字修改输入框的frame
/*
-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat textViewHeight = 0;
    CGFloat minHeight = 33;
    CGFloat maxHeight = 100;
    CGFloat currentHeight = self.inputText.contentSize.height;
    if (currentHeight < minHeight) {
        textViewHeight = minHeight;
    }else if (currentHeight > 100){
        textViewHeight = maxHeight;
    }else{
        textViewHeight = currentHeight;
    }
    
    CGFloat inputToolY = kInputToolViewY-(kHeight-self.keyBoardY);
    self.inputToolBar.frame = CGRectMake(kInputToolViewX, kInputToolViewY+kInputToolViewH-(textViewHeight+(kInputToolViewH-kTextViewH)), kWidth, (kInputToolViewH-kTextViewH) + textViewHeight);
    self.inputText.frame = CGRectMake(kTextViewX, 6.5, kTextViewW, textViewHeight);
    CGFloat keyWidth =kHeight - self.inputToolBar.frame.origin.y;
    self.messageTableView.frame = CGRectMake(kTableViewX, 0-keyWidth, kTableViewW, kTableViewH);
}
*/


#pragma mark------------返回操作------------------
- (void)backButtonAction:(UIBarButtonItem *)button
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark------------滚动到tableView底部------------------

- (void)messageViewScrollToBottom
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageRecord.count-1 inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];

}



@end
