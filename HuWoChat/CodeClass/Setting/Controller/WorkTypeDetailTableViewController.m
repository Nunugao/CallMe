//
//  WorkTypeDetailTableViewController.m
//  HuWoChat
//
//  Created by SZT on 16/1/29.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "WorkTypeDetailTableViewController.h"
#import "WorkTypeDetailTVCSecond.h"

@interface WorkTypeDetailTableViewController ()

@property(nonatomic,strong)NSDictionary  *workTypeDict;

@end

static NSString *identifier = @"cell";

@implementation WorkTypeDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"workType" ofType:@"plist"];
    NSDictionary *workTypeDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.workTypeDict = workTypeDict;
    self.navigationItem.title = @"职位类别";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.workTypeDict.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.workTypeDict.allKeys[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.workTypeDict[self.workTypeDict.allKeys[indexPath.row]];
    WorkTypeDetailTVCSecond *workTypeSecond = [[WorkTypeDetailTVCSecond alloc]initWithStyle:(UITableViewStylePlain)];
    workTypeSecond.array = array;
    [self.navigationController pushViewController:workTypeSecond animated:YES];
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
