//
//  MyCell.m
//  HuWo
//
//  Created by SZT on 16/1/24.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "MyCell.h"
#import "Masonry.h"
#import "ChatToolManager.h"

#define kMarginX 10
#define kFontSize 15

@interface MyCell()

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIImageView *selectImage;

@property(nonatomic,retain)NSArray  *colorArray;

@end


@implementation MyCell

-(NSArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [NSArray arrayWithObjects:[UIColor redColor],[UIColor cyanColor],[UIColor purpleColor],[UIColor greenColor], nil];
        
    }
    return _colorArray;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    return self;
}


-(void)setSelectedArray:(NSArray *)selectedArray
{
    NSArray *subViewArray = self.contentView.subviews;
    for (id obj in subViewArray) {
        [obj removeFromSuperview];
        
    }
    static CGFloat currentX = kMarginX;
    static CGFloat currentY = kMarginX;
    if (_selectedArray != selectedArray) {
        _selectedArray = selectedArray;
    }
    if (selectedArray.count == 0) {
        self.nameLabel = [UILabel new];
        self.nameLabel.text = self.category;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
            make.width.equalTo(@90);
        }];
    }else{
        for (int i = 0; i < selectedArray.count; i ++) {
            UILabel *label = [UILabel new];
            label.text = selectedArray[i];
            label.backgroundColor = self.colorArray[[self.allcategory indexOfObject:self.category]];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 4;
            label.font = [UIFont systemFontOfSize:kFontSize];
            [self.contentView addSubview:label];
            CGSize size = [self stringWidthOfIndex:i];
            if (kScreenWidth - currentX < size.width) {
                currentY += (size.height + kMarginX) ;
                currentX = kMarginX;
            }
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(currentX);
                make.top.equalTo(self.contentView.mas_top).with.offset(currentY);
                make.height.equalTo(@(size.height));
                make.width.equalTo(@(size.width));
                currentX += (size.width + kMarginX);
            }];
        }
    }
    currentX = kMarginX;
    currentY = kMarginX;
}


#pragma mark------------文本宽度------------------

- (CGSize )stringWidthOfIndex:(NSInteger)i
{
    NSDictionary *dict = @{
                           NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]
                           };
    
    CGSize size = [self.selectedArray[i] boundingRectWithSize:CGSizeMake(300, 300) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil].size;
    return size;
}



@end
