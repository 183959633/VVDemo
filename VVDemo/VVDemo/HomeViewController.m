//
//  HomeViewController.m
//  VVDemo
//
//  Created by Jack on 2018/5/3.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "HomeViewController.h"
#import "CommonViewController.h"
#import "NSObject+addName.h"
#import "DataBase.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation HomeViewController

static NSString *const indexPathID = @"ReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [self syncSerial];
    NSObject *objc = [[NSObject alloc]init];
    objc.name =@"runtime 动态添加name属性";
//    NSLog(@"%@",objc.name);
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_tabView reloadData];
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
        
        [_tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:indexPathID];
    }
    return _tabView;
}
/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
#pragma 同步执行 + 串行队列
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncSerial---end");
}

#pragma 初始化UI界面
-(void)setUI{
    [self.view addSubview:self.tabView];
    self.view.backgroundColor = [ UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leaves"] style:UIBarButtonItemStyleDone target:self action:@selector(right)];
}
-(void)right{
    CommonViewController *vc = [[CommonViewController alloc]init];
    vc.infoString = @"Block传值";
    vc.infoBlock = ^(NSString *str) {
        [self.data addObject:str];
    };
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y =  scrollView.contentOffset.y;
    
    NSLog(@"CGFloat===%f",y);
}
@end
