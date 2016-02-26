//
//  FriendCell.m
//  LetChat
//
//  Created by SZT on 16/1/13.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "FriendCell.h"

#define kIconImageX 20
#define kIconImageY 10
#define kIconImageW 50
#define kIconImageH 50

#define kUserNameX  (kIconImageX+kIconImageW)+10
#define kUserNameY  kIconImageY
#define kUserNameW  200
#define kUserNameH  30

@interface FriendCell()

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UILabel *userName;

@property(nonatomic,strong)UILabel *messageLabel;



@end

@implementation FriendCell

-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
        _iconImage.image = [UIImage imageNamed:@"human.jpg"];
    }
    return _iconImage;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(kUserNameX, kUserNameY, kUserNameW, kUserNameH)];
        _userName.font = [UIFont systemFontOfSize:20];
    }
    return _userName;
}


-(void)setUser:(NSString *)user
{
    self.userName.text = user;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.userName];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
