//
//  AddFriendsController.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "AddFriendsController.h"
#import "EaseMob.h"
#import "MainClass.h"

#define kmarginY 15

#define kUserNameX  50
#define kUserNameY  100
#define kUserNameW  (kWidth-kUserNameX*2)
#define kUserNameH  30


#define kyouMessageX  kUserNameX
#define kyouMessageY  (kUserNameY+kUserNameH+50)
#define kyouMessageW  (kWidth-kyouMessageX*2)
#define kyouMessageH  30

#define kaddButtonW  60
#define kaddButtonH  30
#define kaddButtonX  (kWidth-kaddButtonW)/2
#define kaddButtonY  (kyouMessageY+kyouMessageH+kmarginY)


@interface AddFriendsController ()

@property(nonatomic,strong)UITextField *addFriendsUserName;

@property(nonatomic,strong)UITextField *youMessage;

@property(nonatomic,strong)UIButton *addButton;


@end

@implementation AddFriendsController

-(UITextField *)addFriendsUserName{
    if (!_addFriendsUserName) {
        _addFriendsUserName = [[UITextField alloc]init];
        _addFriendsUserName.frame = CGRectMake(kUserNameX, kUserNameY, kUserNameW, kUserNameH);
        _addFriendsUserName.borderStyle = UITextBorderStyleRoundedRect;
        _addFriendsUserName.placeholder = @"请输入用户名";
    }
    return _addFriendsUserName;
}

-(UITextField *)youMessage{
    if (!_youMessage) {
        _youMessage = [[UITextField alloc]initWithFrame:CGRectMake(kyouMessageX, kyouMessageY, kyouMessageW, kyouMessageH)];
        _youMessage.text = @"我是";
        _youMessage.borderStyle = UITextBorderStyleRoundedRect;
        _youMessage.backgroundColor = [UIColor redColor];
    }
    return _youMessage;
}

-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:(UIButtonTypeSystem)
                      ];
        _addButton.frame = CGRectMake(kaddButtonX, kaddButtonY, kaddButtonW, kaddButtonH);
        [_addButton setTitle:@"添加" forState:(UIControlStateNormal)];
    }
    return _addButton;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.addFriendsUserName];
    [self.view addSubview:self.youMessage];
    [self.view addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addFriendsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}


#pragma mark------------发送添加好友请求------------------

- (void)addFriendsAction:(UIButton *)button
{
    NSString *str = self.addFriendsUserName.text;
    NSArray *addedBuddys = [[EaseMob sharedInstance].chatManager buddyList];
    EMError *error = nil;
    if (str.length != 0) {
        [[EaseMob sharedInstance].chatManager addBuddy:str message:self.youMessage.text error:&error];
        if (error) {
            MyAlert *myAlert = [MyAlert alertViewWithTitle:@"添加失败" message:nil];
            [self presentViewController:myAlert animated:YES completion:nil];
        }else{
            MyAlert *myAlert = [MyAlert alertViewWithTitle:@"添加请求已发送" message:nil];
            [self presentViewController:myAlert animated:YES completion:^{
                [self.view endEditing:YES];
            }];
        }
    }else{
        MyAlert *myAlert = [MyAlert alertViewWithTitle:@"请输入要添加的账户名" message:nil];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
