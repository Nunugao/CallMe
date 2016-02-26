//
//  EditPersonalViewController.m
//  LetChat
//
//  Created by SZT on 16/1/27.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "EditPersonalViewController.h"
#import "CategoryDetailController.h"
#import "ChatToolManager.h"
#import "MyCell.h"
#import "PhotoWall.h"



@interface EditPersonalViewController ()<categoryProtocol,SelectPhotoWall,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property(nonatomic,strong)NSDictionary *dict;//系统的所有标签

@property(nonatomic,strong)NSArray *allKeys;

@property(nonatomic,strong)NSMutableDictionary *selectLabelDict;

@property(nonatomic,strong)PhotoWall *photoWall;

@property(nonatomic,strong)UIImageView *currentSelectImage;

@property(nonatomic,strong)NSMutableArray *selectedImages;

@end

#define kWidth [UIScreen mainScreen].bounds.size.width

#define kFontSize 15
#define kMargin 10



@implementation EditPersonalViewController

-(void)dealloc
{
    self.photoWall.delegate = nil;
}


//照片墙
-(PhotoWall *)photoWall{
    if (!_photoWall) {
        _photoWall = [[PhotoWall alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        [ChatToolManager defaultChatToolManager].selectImages = [[[NSUserDefaults standardUserDefaults] objectForKey:@"photoWall"] mutableCopy];
        if ([ChatToolManager defaultChatToolManager].selectImages.count != 0) {
            NSArray *subImages = [_photoWall subviews];
            for (int i = 0; i < [ChatToolManager defaultChatToolManager].selectImages.count; i ++) {
                UIImageView *userImage = subImages[i];
                userImage.image = [[UIImage imageWithData:[ChatToolManager defaultChatToolManager].selectImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }
        _photoWall.delegate = self;
    }
    return _photoWall;
}

//照片墙选好的照片
//-(NSMutableArray *)selectedImages{
//    if (!_selectedImages) {
//        
//        [ChatToolManager defaultChatToolManager].selectImages = [[[NSUserDefaults standardUserDefaults] objectForKey:@"photoWall"] mutableCopy];
//        if ([ChatToolManager defaultChatToolManager].selectImages.count != 0) {
//            _selectedImages = [NSMutableArray arrayWithArray:[ChatToolManager defaultChatToolManager].selectImages];
//        }else{
//            _selectedImages = [NSMutableArray array];
//        }
//    }
//    return _selectedImages;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取用户已经选择的标签
    [ChatToolManager defaultChatToolManager].userMessage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userMessage"] mutableCopy];
    self.selectLabelDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userMessage"];
    
    
    
 
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ICan" ofType:@"plist"];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.dict = rootDict;
    self.allKeys = self.dict.allKeys;
    self.tableView.tableHeaderView = self.photoWall;
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancelOrSaveButtonAction:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancelOrSaveButtonAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAndReload:) name:@"selectOK" object:nil];
}


- (void)selectAndReload:(NSNotification *)row
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row.object integerValue] inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
    
}

- (void)cancelOrSaveButtonAction:(UIBarButtonItem *)button
{
    if ([button.title isEqualToString:@"取消"]) {
        
        NSLog(@"取消");
        
    }else{//保存
        
        [[NSUserDefaults standardUserDefaults] setObject:[ChatToolManager defaultChatToolManager].userMessage forKey:@"userMessage"];
        [[NSUserDefaults standardUserDefaults] setObject:[ChatToolManager defaultChatToolManager].selectImages forKey:@"photoWall"];
        NSLog(@"有%ld张照片",[ChatToolManager defaultChatToolManager].selectImages.count);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadUserData" object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *userDict = self.selectLabelDict;
    NSArray *selectedArray = [userDict objectForKey:self.allKeys[indexPath.row]];
    cell.category = self.allKeys[indexPath.row];//哪个分类
    cell.allcategory = self.allKeys;//所有分类
    cell.selectedArray = selectedArray;//当前分类已选的选项
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dict[self.allKeys[indexPath.row]];
    CategoryDetailController *categoryDetailVC = [[CategoryDetailController alloc]initWithStyle:(UITableViewStylePlain)];
    categoryDetailVC.allCategorys = self.allKeys;
    categoryDetailVC.categoryDetails = array;
    categoryDetailVC.delegate = self;
    categoryDetailVC.navigationItem.title = self.allKeys[indexPath.row];
    [self.navigationController pushViewController:categoryDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat currentX = kMargin;
    CGFloat stringHeight = 0;
    NSInteger row = 1;
    NSArray *selectedArray = [[ChatToolManager defaultChatToolManager].userMessage objectForKey:self.allKeys[indexPath.row]];
    
    if (selectedArray.count == 0) {
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

        }

        return row*stringHeight+(row+1)*kMargin;
    }
    
}

#pragma mark------------categoryDelegate------------------
- (void)updateSelectedLabel:(NSDictionary *)dict
{
    self.selectLabelDict = [dict mutableCopy];
}


#pragma mark------------SelectPhotoWall------------------
-(void)selectPhotoWall:(UITapGestureRecognizer *)tap
{
    self.currentSelectImage = (UIImageView *)tap.view;
    if (self.currentSelectImage.image == nil) {
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消 " style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        [alertControler addAction:cancelAction];
        [alertControler addAction:photoLibraryAction];
        [self presentViewController:alertControler animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *delegateAction = [UIAlertAction actionWithTitle:@"删除这张照片" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            NSData *data = UIImagePNGRepresentation(self.currentSelectImage.image);
            self.currentSelectImage.image = nil;
//            [self.selectedImages removeObject:data];
            [[ChatToolManager defaultChatToolManager].selectImages removeObject:data];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:delegateAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark------------UIImagePickerDelegate------------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    self.currentSelectImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSData *data = UIImagePNGRepresentation(image);
//    [self.selectedImages addObject:data];
    [[ChatToolManager defaultChatToolManager].selectImages addObject:data];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
