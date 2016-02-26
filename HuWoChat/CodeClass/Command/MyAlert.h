//
//  MyAlert.h
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlert : UIAlertController

+ (MyAlert*)alertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
