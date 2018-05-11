//
//  CommonViewController.h
//  VVDemo
//
//  Created by Jack on 2018/5/4.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^mBlock)(NSString*);
@protocol CommonViewControllerDelegate <NSObject>
- (void)common:(NSString*)text;
@optional
- (void)optionalFouction;
@end
@interface CommonViewController : UIViewController
@property(nonatomic,copy)NSString *infoString;
@property(nonatomic,copy)mBlock   infoBlock;
@property(nonatomic,weak)id <CommonViewControllerDelegate> delegate;
@end
