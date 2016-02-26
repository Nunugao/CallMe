//
//  SettingTableViewController.m
//  LetChat
//
//  Created by SZT on 16/1/10.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "SettingTableViewController.h"
#import "CategoryDetailController.h"
#import "EditPersonalViewController.h"
#import "ViewController.h"
#import "MainClass.h"
#import "EaseMob.h"
#import "ChatToolManager.h"
#import "MyCell.h"

#define kMargin 10


@interface SettingTableViewController ()

@property(nonatomic,strong)UIButton *quitOutButton;

@property(nonatomic,retain)NSArray  *allKeys;

@property(nonatomic,strong)NSDictionary *dict;

@property(nonatomic,strong)UIScrollView *headScrollView;

@end

#define kWidth [UIScreen mainScreen].bounds.size.width

@implementation SettingTableViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:selectedWorkTypeNotification object:nil];
}

-(UIScrollView *)headScrollView{
    if (!_headScrollView) {
        _headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth)];
        _headScrollView.pagingEnabled = YES;
        _headScrollView.backgroundColor = [UIColor cyanColor];
    }
    return _headScrollView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ICan" ofType:@"plist"];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.dict = rootDict;
    self.allKeys = self.dict.allKeys;
    self.navigationItem.title = @"我的";
    self.tableView.tableHeaderView = self.headScrollView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewReladData) name:@"reloadUserData" object:nil];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editPersonalMessage:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    //注册通知，该通知的作用是在选择工作类型之后将选择结果保存起来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectWorkType:) name:selectedWorkTypeNotification object:nil];

}

- (void)selectWorkType:(NSNotification *)notification
{
    NSLog(@"notification = %@",notification);
}

#pragma mark------------reloadUsrData------------------
- (void)tableViewReladData
{
    NSArray *imageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoWall"];
    NSArray *imageSubs = self.headScrollView.subviews;
    if (imageSubs.count > 0) {
        
        for (id obj in imageSubs) {
            [obj removeFromSuperview];
        }
    }
    if (imageArray.count > 0) {
        self.headScrollView.contentSize = CGSizeMake(kWidth*imageArray.count, 0);
        for (int i = 0; i < imageArray.count; i ++) {
            UIImageView *selectedImage = [[UIImageView alloc]initWithImage:[UIImage imageWithData:imageArray[i]]];
            [selectedImage setContentMode:(UIViewContentModeScaleToFill)];
            selectedImage.frame = CGRectMake(i*kWidth, 0, kWidth, kHeight);
            [self.headScrollView addSubview:selectedImage];
        }
    }else{
        self.headScrollView.contentSize = CGSizeMake(0, 0);
    }
    [self.tableView reloadData];
}


#pragma mark------------编辑个人资料------------------
- (void)editPersonalMessage:(UIBarButtonItem *)button
{
    EditPersonalViewController *editPersonVC = [[EditPersonalViewController alloc]initWithStyle:(UITableViewStylePlain)];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:editPersonVC];
    [self.navigationController presentViewController:navc animated:YES completion:nil];
}

#pragma mark - Table view 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allKeys.count + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    if (indexPath.row < self.allKeys.count) {
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMessage"];
        NSArray *selectedArray = userDict[self.allKeys[indexPath.row]];
        cell.category = self.allKeys[indexPath.row];//哪个分类
        cell.allcategory = self.allKeys;//所有分类
        cell.selectedArray = selectedArray;//当前分类已选的选项
//        cell.textLabel.text = self.allKeys[indexPath.row];
    }else{
        
        NSString *userName = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
        self.quitOutButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, kWidth-2*15, 50)];
        [_quitOutButton addTarget:self action:@selector(quitOutAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _quitOutButton.backgroundColor = [UIColor redColor];
        [_quitOutButton setTitle:[NSString stringWithFormat:@"退出当前账号(%@)",userName] forState:(UIControlStateNormal)];
        [cell.contentView addSubview:_quitOutButton];
    }
    
    
    return cell;
}



#pragma mark------------账号退出操作------------------
-(void)quitOutAction:(UIButton *)button
{

    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {

        if (error) {
            NSLog(@"退出失败");
        }else{
            NSLog(@"退出成功");
            self.view.window.rootViewController = [[ViewController alloc]init];
        }
    } onQueue:nil];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.allKeys.count) {
        return 70;
    }else{
        
        CGFloat currentX = kMargin;
        CGFloat stringHeight = 0;
        NSInteger row = 1;
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMessage"];
        NSArray *selectedArray = userDict[self.allKeys[indexPath.row]];
        
        if (selectedArray.count == 0 || selectedArray == nil) {
            return 40;
        }else{
            
            for (NSString *string in selectedArray) {
                CGSize size = [ChatToolManager stringSize:string fontSize:kFontSize];
                stringHeight = size.height;
                if (kScreenWidth-currentX < size.width) {
                    currentX = kMargin + size.width;
                    row++;
                }else{
                    currentX += kMargin+size.width;
                }
//                NSLog(@"%@",string);
            }
//            NSLog(@"-%@---%ld-行----------",self.allKeys[indexPath.row],(long)row);
            return row*stringHeight+(row+1)*kMargin;
        }
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
