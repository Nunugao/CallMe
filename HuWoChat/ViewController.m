//
//  ViewController.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ViewController.h"
#import "EaseMob.h"
#import "MainClass.h"
#import "Masonry.h"
#import "RootViewController.h"
#import "ChatToolManager.h"

#define kMarginY 15

#define kuserNameX  50
#define kuserNameY  90
#define kuserNameW  (kWidth-2*kuserNameX)
#define kuserNameH  30

#define kPassWordFieldX  kuserNameX
#define kPassWordFieldY  (kuserNameY+kuserNameH+kMarginY)
#define kPassWordFieldW  kuserNameW
#define kPassWordFieldH  kuserNameH

#define kloginButtonW  50
#define kloginButtonH  30
#define kloginButtonX  (kWidth-2*kloginButtonW)/3
#define kloginButtonY  (kPassWordFieldY+kPassWordFieldH+kMarginY)

#define kregisterButtonW  50
#define kregisterButtonH  30
#define kregisterButtonX  (kWidth-2*kloginButtonW)/3+kloginButtonW+kregisterButtonW
#define kregisterButtonY  (kPassWordFieldY+kPassWordFieldH+kMarginY)


@interface ViewController ()

@property(nonatomic,strong)UITextField *userNameField;

@property(nonatomic,strong)UITextField *passwordField;

@property(nonatomic,strong)UIButton *registerButton;

@property(nonatomic,strong)UIButton *loginButton;

@end

@implementation ViewController

-(UITextField *)userNameField{
    if (!_userNameField) {
        _userNameField = [[UITextField alloc]initWithFrame:CGRectMake(kuserNameX, kuserNameY, kuserNameW, kuserNameH)];
        _userNameField.placeholder = @"请输入用户名";
    }
    return _userNameField;
}
-(UITextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(kPassWordFieldX, kPassWordFieldY, kPassWordFieldW, kPassWordFieldH)];
        _passwordField.placeholder = @"请输入密码";
    }
    return _passwordField;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _loginButton.frame = CGRectMake(kloginButtonX, kloginButtonY, kloginButtonW, kloginButtonH);
        [_loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
        _loginButton.backgroundColor = [UIColor redColor];
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginButton;
}

-(UIButton *)registerButton{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _registerButton.frame = CGRectMake(kregisterButtonX, kregisterButtonY, kregisterButtonW, kregisterButtonH);
        [_registerButton setTitle:@"注册" forState:(UIControlStateNormal)];
        _registerButton.backgroundColor = [UIColor redColor];
        [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _registerButton;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.userNameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.loginButton];
       
    
}


#pragma mark------------login------------------
- (void)loginAction:(UIButton *)button
{
    
    //让环信在用户第一次登陆的时候自动获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    if (self.userNameField.text.length != 0 || self.passwordField.text.length != 0) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userNameField.text password:self.passwordField.text completion:^(NSDictionary *loginInfo, EMError *error) {
            
            if (!error && loginInfo) {
                NSLog(@"登陆成功");
                [ChatToolManager defaultChatToolManager].userName = self.userNameField.text;
                // 设置自动登录
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                self.view.window.rootViewController = [[RootViewController alloc]init];
            }else{
                MyAlert *myAlert = [MyAlert alertViewWithTitle:@"登录失败" message:@"请检查账号和密码"];
                [self presentViewController:myAlert animated:YES completion:nil];
                NSLog(@"登录失败%@",error);
            }
        } onQueue:dispatch_get_main_queue()];
    }
}

#pragma mark------------register------------------
- (void)registerAction:(UIButton *)button
{
    if (self.userNameField.text.length != 0 || self.passwordField.text.length != 0)
    {
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.userNameField.text password:self.passwordField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if (!error) {
                MyAlert *myAlert = [MyAlert alertViewWithTitle:@"注册成功" message:@"请登录"];
                [self presentViewController:myAlert animated:YES completion:nil];
            }else{
                MyAlert *myAlert = [MyAlert alertViewWithTitle:@"注册失败" message:@"请检查账号和密码"];
                [self presentViewController:myAlert animated:YES completion:nil];
            }
        } onQueue:nil];
    }else{
        MyAlert *myAlert = [MyAlert alertViewWithTitle:@"注册失败" message:@"用户名和密码不能为空"];
        [self presentViewController:myAlert animated:YES completion:nil];
    }
    
}

@end
