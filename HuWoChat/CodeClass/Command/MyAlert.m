//
//  MyAlert.m
//  LetChat
//
//  Created by SZT on 16/1/9.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import "MyAlert.h"

@interface MyAlert ()

@end

@implementation MyAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (MyAlert*)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    MyAlert *myAlert = [MyAlert alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [myAlert addAction:okAction];
    return myAlert;
}

@end
