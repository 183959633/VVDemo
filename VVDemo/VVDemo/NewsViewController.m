//
//  NewsViewController.m
//  VVDemo
//
//  Created by Jack on 2018/5/3.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "NewsViewController.h"
#import "CommonViewController.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *indexPathID;
}
@end
@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self asyncSerial];
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
/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
#pragma 异步执行 + 串行队列
- (void)asyncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
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
    
    NSLog(@"asyncSerial---end");
}
#pragma 初始化UI界面
-(void)setUI{
    [self.view addSubview:self.tabView];
    self.view.backgroundColor = [ UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:@"kNotificationCenter" object:Nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"deer"] style:UIBarButtonItemStyleDone target:self action:@selector(right)];
}
-(void)notification:(NSNotification*)info{
   
    NSString *str = info.userInfo[@"text"];
    
    [self.data addObject:str];
    [_tabView reloadData];
}
-(void)right{
    
    CommonViewController *vc = [[CommonViewController alloc]init];
    vc.infoString = @"通知传值";
    
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
