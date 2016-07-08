//
//  ViewController.m
//  滚动切换栏
//
//  Created by 金考网 on 15/9/29.
//  Copyright © 2015年 金考网. All rights reserved.
//

#import "ViewController.h"
#import "LDSwitchView.h"


@interface ViewController ()<LDSwitchViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,20)];
    
    statusView.backgroundColor = [UIColor whiteColor];
    
    
    
    LDSwitchView *view = [[LDSwitchView alloc]initWithFrame:self.view.frame];
    view.delegate = self;
    
    self.view = view;
    
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    
    view.headTitle = array;
    
    [self.view addSubview:statusView];
}

-(void)switchView:(LDSwitchView *)switchView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"停在了第%ld个按钮",index);
}





@end
