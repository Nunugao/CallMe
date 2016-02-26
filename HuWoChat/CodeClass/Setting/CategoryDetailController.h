//
//  CategoryDetailController.h
//  LetChat
//
//  Created by SZT on 16/1/27.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol categoryProtocol <NSObject>

- (void)updateSelectedLabel:(NSDictionary *)dict;

@end

@interface CategoryDetailController : UITableViewController

@property(nonatomic,strong)NSArray *categoryDetails;

@property(nonatomic,strong)NSArray *allCategorys;

@property(nonatomic,assign)id<categoryProtocol> delegate;

@end
