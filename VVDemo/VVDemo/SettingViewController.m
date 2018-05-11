//
//  SettingViewController.m
//  VVDemo
//
//  Created by Jack on 2018/5/3.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "SettingViewController.h"
#import "CommonViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *indexPathID;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self asyncConcurrent];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString  *Str = [[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    if (Str) {
        [self.data addObject:Str];
        [_tabView reloadData];
    }

}
- (NSMutableArray *)data{
    if (!_data) {
        _data = [[NSMutableArray alloc]init];
    }
    return _data;
}
- (UITableView *)tabView{
    if (!_tabView) {
        _tabView             = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tabView.delegate    = self;
        _tabView.dataSource  = self;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        indexPathID = @"indexPathID";
        [_tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:indexPathID];
    }
    return _tabView;
}
#pragma 初始化UI界面
-(void)setUI{
    [self.view addSubview:self.tabView];
    self.view.backgroundColor = [ UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rabbit"] style:UIBarButtonItemStyleDone target:self action:@selector(right)];
}
#pragma 异步执行+ 并发队列
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.pacterat.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}
-(void)right{
    
    CommonViewController *vc = [[CommonViewController alloc]init];
    vc.infoString = @"NSUserDefaults轻量级";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPathID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indexPathID];
    }
    
    NSString *str = _data[indexPath.row];
    cell.textLabel.text = str;
    return cell;
}
@end
