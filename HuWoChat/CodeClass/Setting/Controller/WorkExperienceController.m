//
//  WorkExperienceController.m
//  HuWoChat
//
//  Created by SZT on 16/1/28.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "WorkExperienceController.h"
#import "WorkTypeDetailTableViewController.h"
#import "ChatToolManager.h"
#import "Masonry.h"

@interface WorkExperienceController ()

@property(nonatomic,strong)NSMutableDictionary *sectionDict;

@property(nonatomic,strong)NSArray *firstSectionArray;

@property(nonatomic,strong)NSArray *secondSectionArray;

@property(nonatomic,strong)NSMutableDictionary *experienceDict;


@end

static NSString *identifier = @"cell";

@implementation WorkExperienceController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:selectedWorkTypeNotification object:nil];
}

-(NSMutableDictionary *)experienceDict{
    if (!_experienceDict) {
        _experienceDict = [NSMutableDictionary dictionary];
    }
    return _experienceDict;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSArray *firstSectionArray = [NSArray arrayWithObjects:@"公司",@"任职部门",@"职位类别",@"职位名称", nil];
    self.firstSectionArray = [NSArray arrayWithArray:firstSectionArray];
    
    NSArray *secondSectionArray = [NSArray arrayWithObjects:@"时间段", nil];
    self.secondSectionArray = [NSArray arrayWithArray:secondSectionArray];
    
    
    //注册通知，该通知的作用是在选择工作类型之后将选择结果保存起来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectWorkType:) name:selectedWorkTypeNotification object:nil];
}

- (void)selectWorkType:(NSNotification *)notification
{
    NSLog(@"notification = %@",notification);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.detailTextLabel.text = notification.object;
    [self.experienceDict setObject:notification.object forKey:self.firstSectionArray[2]];
}


#pragma mark------------返回并保存信息------------------
- (void)backAndSaveAction:(UIButton *)button
{
    BOOL isNull = NO;
    for (NSString *key in self.firstSectionArray) {
        if (self.experienceDict[key] == nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@不能为空",key] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertController addAction:OKAction];
            [self presentViewController:alertController animated:YES completion:nil];
            isNull = YES;
            if (isNull) {
                return;
            }
        }
    }
    if (isNull == NO) {
        //取出已经存放的工作简历allWorkExperiences（数组）
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:allWorkExperience];
        NSMutableArray *allWorkExperiences = nil;
        if (array != nil) {
            allWorkExperiences = [NSMutableArray arrayWithArray:array];
        }else{
            allWorkExperiences = [NSMutableArray array];
        }
        [allWorkExperiences addObject:self.experienceDict];
        [[NSUserDefaults standardUserDefaults] setObject:allWorkExperiences forKey:allWorkExperience];
        [[NSNotificationCenter defaultCenter] postNotificationName:editResumeNotification object:self.experienceDict[@"公司"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.firstSectionArray.count;
    }else if (section == 2){
        return 1;
    }else{
        return self.secondSectionArray.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.firstSectionArray[indexPath.row];
        cell.detailTextLabel.text = @"请填写";
        
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.secondSectionArray[indexPath.row];
        cell.detailTextLabel.text = @"请填写";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }else if (indexPath.section == 2){
        UIButton *saveButton = [UIButton new];
        [saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
        saveButton.backgroundColor = [UIColor redColor];
        [saveButton addTarget:self action:@selector(backAndSaveAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:saveButton];
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(50);
            make.right.equalTo(cell.contentView).with.offset(-50);
            make.top.equalTo(cell.contentView).with.offset(10);
            make.bottom.equalTo(cell.contentView).with.offset(-10);
        }];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2 && indexPath.section == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.firstSectionArray[indexPath.row] message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.detailTextLabel.text isEqualToString:@"请填写"]) {
                textField.placeholder = [NSString stringWithFormat:@"请填写%@",_firstSectionArray[indexPath.row]];
            }else{
                textField.text = [NSString stringWithFormat:@"%@",cell.detailTextLabel.text];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {//点击“确定”的时候获取刚才编辑的内容
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            NSString *inputText = alertController.textFields.firstObject.text;
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            //保存到字典中
            [self.experienceDict setObject:inputText forKey:cell.textLabel.text];
            // 刷新UI
            [self editIndexPath:indexPath WithString:inputText];
        } ];
        [alertController addAction:cancelAction];
        [alertController addAction:certainAction];
        [self presentViewController:alertController animated:YES completion:^{
            UITextField *textField = alertController.textFields.firstObject;
            certainAction.enabled = textField.text.length < 3 ? NO : YES;
        }];
    }else if (indexPath.row == 2 && indexPath.section == 0){
        
        WorkTypeDetailTableViewController *workTypeDetailTVC = [[WorkTypeDetailTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
        [self.navigationController pushViewController:workTypeDetailTVC animated:YES];
        
    }
}


- (void)editIndexPath:(NSIndexPath *)indexPath WithString:(NSString *)inputText
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = inputText;
}

- (void)alertTextFieldDidChange:(NSNotification *)notifocation
{
    UITextField *textField = notifocation.object;
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    UIAlertAction *certainAction = alertController.actions.lastObject;
    certainAction.enabled = textField.text.length < 3 ? NO : YES;
    
}

@end
