//
//  SettingViewController.m
//  HuWoChat
//
//  Created by SZT on 16/1/28.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "SettingViewController.h"
#import "CategoryDetailController.h"
#import "EditPersonalViewController.h"
#import "WorkExperienceController.h"
#import "ViewController.h"
#import "MainClass.h"
#import "EaseMob.h"
#import "ChatToolManager.h"
#import "MyCell.h"
#import "Masonry.h"

#define kMargin 10
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *personTableView;

@property(nonatomic,strong)UITableView *resumeTableView;

@property(nonatomic,strong)UIButton *quitOutButton;

@property(nonatomic,retain)NSArray  *allKeys;

@property(nonatomic,strong)NSDictionary *dict;

@property(nonatomic,strong)UIScrollView *headScrollView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UISegmentedControl *segment;

@end


static NSString *resumeID = @"resumeID";

@implementation SettingViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:editResumeNotification object:nil];
}

-(UISegmentedControl *)segment{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc]initWithItems:@[@"个人资料",@"我的简历"]];
        
        _segment.backgroundColor = [UIColor lightGrayColor];
        _segment.tintColor = [UIColor clearColor];
        
        NSDictionary *selectDict = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName:[UIColor cyanColor]
                                     };
        [_segment setTitleTextAttributes:selectDict forState:(UIControlStateSelected)];
        
        NSDictionary *unSelectDict = @{
                                       NSFontAttributeName:[UIFont systemFontOfSize:14],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]
                                       };
        [_segment setTitleTextAttributes:unSelectDict forState:(UIControlStateNormal)];
        
        _segment.selectedSegmentIndex = 0;
        
        [_segment addTarget:self action:@selector(segmentSelectChange:) forControlEvents:(UIControlEventValueChanged)];
    
    }
    return _segment;
}



-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kWidth, kWidth, kHeight-kWidth)];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kWidth*2, 0);
        [_scrollView addSubview:self.personTableView];
        [_scrollView addSubview:self.resumeTableView];
    }
    return _scrollView;
}


-(UITableView *)personTableView{
    if (!_personTableView) {
        _personTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kWidth) style:(UITableViewStylePlain)];
        _personTableView.delegate = self;
        _personTableView.dataSource = self;
    }
    return _personTableView;
}


-(UITableView *)resumeTableView{
    if (!_resumeTableView) {
        _resumeTableView = [[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-kWidth) style:(UITableViewStylePlain)];
        _resumeTableView.delegate = self;
        _resumeTableView.dataSource = self;
    }
    return _resumeTableView;
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
    
    //添加头部视图
    [self.view addSubview:self.headScrollView];
    
    //添加segment
    [self.view insertSubview:self.segment aboveSubview:self.headScrollView];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.headScrollView.mas_left).with.offset(0);
        make.right.equalTo(self.headScrollView.mas_right).with.offset(0);
        make.bottom.equalTo(self.headScrollView.mas_bottom).with.offset(0);
        make.height.equalTo(@50);
    }];
    
    //添加两个tableView
    [self.view addSubview:self.scrollView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ICan" ofType:@"plist"];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.dict = rootDict;
    self.allKeys = self.dict.allKeys;
    self.navigationItem.title = @"我的";
//    self.tableView.tableHeaderView = self.headScrollView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewReladData) name:@"reloadUserData" object:nil];
    
    //注册好通知，增加简历后将简历显示出来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addWorkExperience:) name:editResumeNotification object:nil];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editPersonalMessage:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
}


#pragma mark------------增加工作经历并且刷新tableView------------------
- (void)addWorkExperience:(NSNotification *)notification
{
    [self.resumeTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationAutomatic)];
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
    [self.personTableView reloadData];
}


#pragma mark------------编辑个人资料------------------
- (void)editPersonalMessage:(UIBarButtonItem *)button
{
    EditPersonalViewController *editPersonVC = [[EditPersonalViewController alloc]initWithStyle:(UITableViewStylePlain)];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:editPersonVC];
    [self.navigationController presentViewController:navc animated:YES completion:nil];
}


#pragma mark------------scrollView 代理------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
       CGPoint point = self.scrollView.contentOffset;
        [self.segment setSelectedSegmentIndex:point.x / kWidth];
    }
}


#pragma mark------------segment点击事件------------------

- (void)segmentSelectChange:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    if (self.scrollView.contentOffset.x / kWidth != index) {
        [self.scrollView setContentOffset:CGPointMake(kWidth * index, 0) animated:YES];
    }
}


#pragma mark - Table view 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.personTableView) {
        return 1;
    }
    else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.personTableView) {
        
        return self.allKeys.count + 1;
    }else{
        if (section == 1) {
            return 1;
        }else{
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:allWorkExperience];
            return array.count + 1;
        }
        
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.personTableView) {
        
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
    }else{
        UITableViewCell *cell = [self.resumeTableView dequeueReusableCellWithIdentifier:resumeID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:resumeID];
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = @"添加教育经历";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        if (indexPath.section == 0) {
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:allWorkExperience];
            if (indexPath.row == array.count) {
                cell.textLabel.text = @"添加工作经历";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }else{
                cell.textLabel.text = array[indexPath.row][@"公司"];
                cell.detailTextLabel.text = array[indexPath.row][@"职位名称"];
                cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
        
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.personTableView) {
        
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
    else{
        
        return 40;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.resumeTableView) {
        
        NSString *title = nil;
        if (section == 0) {
            title = @"工作经历";
        }else{
            title = @"教育经历";
        }
        return  title;
    }else{
        return nil;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.resumeTableView) {
        WorkExperienceController *workExperienceTVC = [[WorkExperienceController alloc]initWithStyle:(UITableViewStylePlain)];
        
        [self.navigationController pushViewController:workExperienceTVC animated:YES];
    }
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






@end
