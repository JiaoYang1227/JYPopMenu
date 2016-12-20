//
//  ViewController.m
//  JYPopMenu
//
//  Created by sun on 16/5/9.
//  Copyright © 2016年 sun. All rights reserved.
//

#import "ViewController.h"
#import "JYPopMenu.h"
@interface ViewController (){
    JYPopMenu *_popMenu;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _popMenu = [JYPopMenu shareJYPopMenu];
}
- (IBAction)button1Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [_popMenu showJYMenuWithTargetFrame:button.frame WithItemNameArray:@[@"请你吃糖",@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%ld,name:%@",(long)index,name);
    }];
}

- (IBAction)button2Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [_popMenu showJYMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%ld,name:%@",(long)index,name);
    }];
}
- (IBAction)button3Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    [_popMenu showJYMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",@"请你吃糖",@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%ld,name:%@",(long)index,name);
    }];
}
- (IBAction)button4Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    [_popMenu showJYMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%ld,name:%@",(long)index,name);
    }];
}
- (IBAction)button5Action:(id)sender {
    UIButton *button = (UIButton *)sender;
    [_popMenu showJYMenuWithTargetFrame:button.frame WithItemNameArray:@[@"哈哈哈哈",@"哈哈哈哈",@"请你吃糖",@"哈哈哈哈",@"哈哈哈哈"] withSelectedBlock:^(NSInteger index,NSString *name){
        NSLog(@"index:%ld,name:%@",(long)index,name);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
