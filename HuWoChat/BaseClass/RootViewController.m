//
//  RootViewController.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "RootViewController.h"
#import "ConversationTableViewController.h"
#import "FriendsTableViewController.h"
#import "SettingTableViewController.h"
#import "SettingViewController.h"

@interface RootViewController ()

@property(nonatomic,strong)ConversationTableViewController *conversationTVC;

@property(nonatomic,strong)FriendsTableViewController *friendTVC;

@property(nonatomic,strong)SettingTableViewController *settingTVC;

@property(nonatomic,strong)SettingViewController *settingVC;

@end

@implementation RootViewController

-(ConversationTableViewController *)conversationTVC{
    if (!_conversationTVC) {
        _conversationTVC = [[ConversationTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    }
    return _conversationTVC;
}


-(FriendsTableViewController *)friendTVC{
    if (!_friendTVC) {
        _friendTVC = [[FriendsTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    }
    return _friendTVC;
}

-(SettingTableViewController *)settingTVC{
    if (!_settingTVC) {
        _settingTVC = [[SettingTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    }
    return _settingTVC;
}


-(SettingViewController *)settingVC{
    if (!_settingVC) {
        _settingVC = [[SettingViewController alloc]init];
    }
    return _settingVC;
}





- (void)viewDidLoad {
    [super viewDidLoad];
 
    UINavigationController *conversationNAVC = [[UINavigationController alloc]initWithRootViewController:self.conversationTVC];
    conversationNAVC.tabBarItem.title = @"消息";
    conversationNAVC.tabBarItem.image = [[UIImage imageNamed:@"chat"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    UINavigationController *friendNAVC = [[UINavigationController alloc]initWithRootViewController:self.friendTVC];
    friendNAVC.tabBarItem.title = @"好友";
    friendNAVC.tabBarItem.image = [[UIImage imageNamed:@"contact"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    UINavigationController *settingNAVC = [[UINavigationController alloc]initWithRootViewController:self.settingTVC];
    settingNAVC.tabBarItem.title = @"设置";
    settingNAVC.tabBarItem.image = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    
    UINavigationController *settingNAVC1 = [[UINavigationController alloc]initWithRootViewController:self.settingVC];
    settingNAVC1.tabBarItem.title = @"设置";
    settingNAVC1.tabBarItem.image = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    self.viewControllers = @[conversationNAVC,friendNAVC,settingNAVC1];
    
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
