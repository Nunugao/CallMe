//
//  AppDelegate.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "ViewController.h"
#import "RootViewController.h"
#import "ChatToolManager.h"


@interface AppDelegate ()<EMChatManagerDelegate>



@end

extern"C"{
    size_t fwrite$UNIX2003(const void *a, size_t b, size_t c, FILE *d )
    {
        return fwrite(a, b, c, d);
    }
    char* strerror$UNIX2003( int errnum )
    {
        return strerror(errnum);
    }
}


@implementation AppDelegate



-(void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。

    [[EaseMob sharedInstance] registerSDKWithAppKey:@"iosszt#letschat" apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger:@(NO)}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        RootViewController *rootVC = [[RootViewController alloc]init];
        self.window.rootViewController = rootVC;
    }
    
    return YES;
}


#pragma mark------------自动登录的回调------------------

-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {
        NSLog(@"自动登录成功 %@",loginInfo);
        [ChatToolManager defaultChatToolManager].userName = loginInfo[@"username"];
    }else{
        NSLog(@"自动登录失败 %@",error);
    }
    
}


// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
@end
