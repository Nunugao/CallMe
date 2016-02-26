//
//  CategoryDetailController.m
//  LetChat
//
//  Created by SZT on 16/1/27.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "CategoryDetailController.h"
#import "ChatToolManager.h"

@interface CategoryDetailController ()

@property(nonatomic,strong)NSMutableArray *selecetArray;



@end



static NSString *identifier = @"cell";

@implementation CategoryDetailController


-(NSMutableArray *)selecetArray{
    if (!_selecetArray) {
//        [ChatToolManager defaultChatToolManager].userMessage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userMessage"] mutableCopy];
        NSMutableDictionary *userDict = [ChatToolManager defaultChatToolManager].userMessage;
        NSArray *array = userDict[self.navigationItem.title];
        if (array.count == 0) {
            _selecetArray = [[NSMutableArray alloc]init];
        }else{
            _selecetArray = [NSMutableArray arrayWithArray:array];
        }
    }
    return _selecetArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backButton;
}



- (void)backAction:(UIBarButtonItem *)button
{
    
    [[ChatToolManager defaultChatToolManager].userMessage setObject:self.selecetArray forKey:self.navigationItem.title];
    [self.delegate updateSelectedLabel:[ChatToolManager defaultChatToolManager].userMessage];
    NSNumber *row = [NSNumber numberWithInteger:[self.allCategorys indexOfObject:self.navigationItem.title]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectOK" object:row];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.categoryDetails.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    cell.textLabel.text = self.categoryDetails[indexPath.row];
    if ([self.selecetArray containsObject:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selecetArray addObject:self.categoryDetails[indexPath.row]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selecetArray removeObject:self.categoryDetails[indexPath.row]];
    }
    
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
