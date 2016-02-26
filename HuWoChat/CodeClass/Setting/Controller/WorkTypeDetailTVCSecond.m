//
//  WorkTypeDetailTVCSecond.m
//  HuWoChat
//
//  Created by SZT on 16/1/29.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "WorkTypeDetailTVCSecond.h"
#import "ChatToolManager.h"

@interface WorkTypeDetailTVCSecond ()

@property(nonatomic,strong)NSIndexPath *preIndexPath;

@property(nonatomic,copy)NSString *workType;

@end

static NSString *identifier = @"cell";

@implementation WorkTypeDetailTVCSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)backAction:(UIBarButtonItem *)button
{
    if (self.workType != nil) {// 选好之后发布通知并将选择结果传过去
        [[NSNotificationCenter defaultCenter] postNotificationName:selectedWorkTypeNotification object:self.workType];
    }
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.array[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.preIndexPath != nil) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.preIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.preIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.workType = nil;
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.workType = cell.textLabel.text;
    }
    self.preIndexPath = indexPath;
}


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
