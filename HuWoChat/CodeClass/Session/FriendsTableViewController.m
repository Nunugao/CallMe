//
//  FriendsTableViewController.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "CommunicateViewController.h"
#import "AddFriendsController.h"
#import "EaseMob.h"
#import "FriendCell.h"

@interface FriendsTableViewController ()<EMChatManagerDelegate>

@property(nonatomic,strong) NSArray *buddyList;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的好友";
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addFriends:)];
    self.navigationItem.rightBarButtonItem = addButton;
    /*
     1 好友列表buddyList是从本地数据库获取的,而且前提是自动登录成功
     2 如果要从服务器获取好好友列表的话要调用
     －（void ＊）asynFetchBuddyListWithCompletion....
     3，如果有当前有添加好友请求，环信SDK会往数据库的Buddy表添加好友纪录
     4，如果程序删除或者用户第一次登陆mbuddlist表是没有记录的，要从服务器获取好友列表记录
     5，如果程序删除或者用户第一次登陆，buddlist表是没有记录的
        解决方案：
                （1）要从服务器获取好友列表记录
                （2）用户第一次登陆后，自动从服务器获取好友列表
     */

    self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    [self.tableView registerClass:[FriendCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.buddyList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
//    }
    
    EMBuddy *buddy = self.buddyList[indexPath.row];
    cell.user = buddy.username;
//    cell.imageView.image = [UIImage imageNamed:@"human.jpg"];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunicateViewController *communicateVC = [[CommunicateViewController alloc]init];
    EMBuddy *buddy = self.buddyList[indexPath.row];
    communicateVC.friendTitle = buddy.username;
    [self.navigationController pushViewController:communicateVC animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark------------添加好友------------------
- (void)addFriends:(UIBarButtonItem *)button
{
    [self.navigationController pushViewController:[[AddFriendsController alloc]init] animated:YES];
}



#pragma mark------------监听自动登录成功 ------------------

-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (!error) {
        
        self.buddyList = [[EaseMob sharedInstance].chatManager buddyList];
        [self.tableView reloadData];
    }
}

#pragma mark------------监听到好友添加请求同意------------------

-(void)didAcceptedByBuddy:(NSString *)username
{
    // 将新的好友添加到显示的表格中(从服务器获取然后更新)
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        self.buddyList = buddyList;
        [self.tableView reloadData];
    } onQueue:nil];
    
}

//好友列表被更新
-(void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    self.buddyList = buddyList;
    [self.tableView reloadData];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        EMBuddy *buddy = self.buddyList[indexPath.row];
        
        //emoveFromRemote是否同时从好友列表中删除自己
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
