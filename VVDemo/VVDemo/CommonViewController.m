//
//  CommonViewController.m
//  VVDemo
//
//  Created by Jack on 2018/5/4.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "CommonViewController.h"
#import <Masonry.h>
@interface CommonViewController ()
{
    @public
    UITextField *mTextField;
}
@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
#pragma 初始化UI界面
-(void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    mTextField = [[UITextField alloc]init];
    [self.view addSubview:mTextField];
    
    mTextField.placeholder = _infoString;
    mTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [mTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(40);
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_infoBlock) {
        _infoBlock(mTextField.text);
    }
    if (_delegate &&[self.delegate respondsToSelector:@selector(common:)]) {
        [self.delegate common:mTextField.text];
    }
    if ([_infoString isEqualToString:@"通知传值"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kNotificationCenter" object:Nil userInfo:@{@"text":mTextField.text}];
    }
    if ([_infoString isEqualToString:@"NSUserDefaults轻量级"]) {
        [[NSUserDefaults standardUserDefaults]setObject:mTextField.text forKey:@"key"];
    }
}
@end
