//
//  ConversationTableViewController.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "EaseMob.h"
#import "MainClass.h"

@interface ConversationTableViewController () <EMChatManagerDelegate>

@end

@implementation ConversationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];

}


#pragma mark------------连接状态发生改变 代理回调------------------
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    /*
     eEMConnectionConnected,   //连接成功
     eEMConnectionDisconnected,//未连接
     */
    if (connectionState == eEMConnectionDisconnected) {
        MyAlert *myAlert = [MyAlert alertViewWithTitle:@"网络已断开" message:@"请连接网络"];
        [self presentViewController:myAlert animated:YES completion:nil];
        NSLog(@"网络连接失败，未连接....");
        self.title = @"未连接...";
    }else{
        NSLog(@"网络通了");
    }
}

//自动重连
-(void)willAutoReconnect
{
    NSLog(@"正在连接中。。。");
    self.title = @"正在连接中...";
    
}

-(void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if (error) {
        NSLog(@"自动重连失败 %@",error);
    }else{
        NSLog(@"自动重连接成功...");
        self.title = @"Conversation";
    }
}


#pragma mark------------好友添加代理方法------------------

//好友请求同意了
- (void)didAcceptedByBuddy:(NSString *)username
{
    //    提醒用户，好友请求被同意了
    MyAlert *myAlert = [MyAlert alertViewWithTitle:[NSString stringWithFormat:@"好友%@同意你的添加请求",username] message:nil];
    [self presentViewController:myAlert animated:YES completion:nil];
}

//好友请求被拒绝
-(void)didRejectedByBuddy:(NSString *)username
{
    MyAlert *myAlert = [MyAlert alertViewWithTitle:[NSString stringWithFormat:@"好友%@拒绝你的添加请求",username] message:nil];
    [self presentViewController:myAlert animated:YES completion:nil];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
