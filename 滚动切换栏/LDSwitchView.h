//
//  LDSwitchView.h
//  滚动切换栏
//
//  Created by 金考网 on 15/9/29.
//  Copyright © 2015年 金考网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDSwitchView;

@protocol LDSwitchViewDelegate <NSObject>

@optional
-(void)switchView:(LDSwitchView *)switchView didSelectedItemAtIndex:(NSInteger)index;

@end


@interface LDSwitchView : UIView
//头部标题数组
@property (nonatomic,strong)NSMutableArray *headTitle;

@property (nonatomic,weak)id<LDSwitchViewDelegate> delegate;

@end
