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

int global_i = 1;
NSString *global_k = @"全局变量";
static int static_global_j = 2;
static NSString *static_global_k = @"静态全局变量";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [self syncSerial];
    NSObject *objc = [[NSObject alloc]init];
    objc.name =@"runtime 动态添加name属性";
//    NSLog(@"%@",objc.name);
    
    static  int      static_k  = 3;
    static  NSString *static_m = @"静态变量";
    __block int      val       = 4;
    __block NSString *val_k    = @"自动变量";
    
    void(^textBlock)(NSInteger index) = ^(NSInteger kIndex) {
        
        global_i        ++;
        global_k        = @"全局变量+2";
        static_global_j ++;
        static_global_k = @"静态全局变量+2";
        static_k        ++;
        static_m        = @"静态变量+2";
        val             ++;
        val_k           = @"自动变量+2";
        
        NSLog(@"Block内-(非OC)全局变量===%i,地址===%p",global_i,&global_i);
        NSLog(@"Block内-(OC)全局变量===%@,地址===%p",global_k,&global_k);
        NSLog(@"Block内-(非OC)静态全局变量===%i,地址===%p",static_global_j,&static_global_j);
        NSLog(@"Block内-(OC)静态全局变量===%@,地址===%p",static_global_k,&static_global_k);
        NSLog(@"Block内-(非OC)静态变量===%i,地址===%p",static_k,&static_k);
        NSLog(@"Block内-(OC)静态变量===%@,地址===%p",static_m,&static_m);
        NSLog(@"Block内-(非OC)自动变量===%i,地址===%p",val,&val);
        NSLog(@"Block外内-(OC)自动变量===%@,地址===%p",val_k,&val_k);
        
        
    };
    global_i        ++;
    global_k        = @"全局变量+1";
    static_global_j ++;
    static_global_k = @"静态全局变量+1";
    static_k        ++;
    static_m        = @"静态变量+1";
    val             ++;
    val_k           = @"自动变量+1";
    
    NSLog(@"Block外-(非OC)全局变量===%i,地址===%p",global_i,&global_i);
    NSLog(@"Block外-(OC)全局变量===%@,地址===%p",global_k,&global_k);
    NSLog(@"Block外-(非OC)静态全局变量===%i,地址===%p",static_global_j,&static_global_j);
    NSLog(@"Block外-(OC)静态全局变量===%@,地址===%p",static_global_k,&static_global_k);
    NSLog(@"Block外-(非OC)静态变量===%i,地址===%p",static_k,&static_k);
    NSLog(@"Block外-(OC)静态变量===%@,地址===%p",static_m,&static_m);
    NSLog(@"Block外-(非OC)自动变量===%i,地址===%p",val,&val);
    NSLog(@"Block外-(OC)自动变量===%@,地址===%p",val_k,&val_k);
    
    textBlock(5);
    
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
