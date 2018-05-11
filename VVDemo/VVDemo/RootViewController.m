//
//  RootViewController.m
//  VVDemo
//
//  Created by Jack on 2018/3/30.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "AssetsViewController.h"
#import "NewsViewController.h"
#import "SettingViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}
#pragma 初始化UI界面
-(void)setUI{
    
    HomeViewController       *home    = [[HomeViewController alloc]init];
    home.title                        = @"home";
    home.tabBarItem.title             = @"home";
    home.tabBarItem.image             = [UIImage imageNamed:@"home"];
    UINavigationController   *homenva = [[UINavigationController alloc]initWithRootViewController:home];

    AssetsViewController     *assets  = [[AssetsViewController alloc]init];
    assets.title                      = @"assets";
    assets.tabBarItem.title           = @"assets";
    assets.tabBarItem.image           = [UIImage imageNamed:@"assets"];
    UINavigationController *assetsnva = [[UINavigationController alloc]initWithRootViewController:assets];
    
    NewsViewController       *news    = [[NewsViewController alloc]init];
    news.title                        = @"news";
    news.tabBarItem.title             = @"news";
    news.tabBarItem.image             = [UIImage imageNamed:@"news"];
    UINavigationController *newsnva   = [[UINavigationController alloc]initWithRootViewController:news];
    
    SettingViewController    *setting = [[SettingViewController alloc]init];
    setting.title                     = @"setting";
    setting.tabBarItem.title          = @"setting";
    setting.tabBarItem.image          = [UIImage imageNamed:@"setting"];
    UINavigationController *settingnva= [[UINavigationController alloc]initWithRootViewController:setting];
    
    NSArray              *itemArrays  = @[homenva,assetsnva,newsnva,settingnva];
    self.viewControllers              = itemArrays;
    
}
@end
