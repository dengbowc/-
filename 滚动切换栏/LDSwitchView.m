//
//  LDSwitchView.m
//  滚动切换栏
//
//  Created by 金考网 on 15/9/29.
//  Copyright © 2015年 金考网. All rights reserved.
//

#import "LDSwitchView.h"

#define HEAD_HEIGHT 30.0

#define STATUS_HEAD 20.0

#define BUTTON_WIDTH self.bounds.size.width / 5


#define RANDOM_COLOR  [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1.0]

@interface LDSwitchView ()<UICollectionViewDataSource ,UICollectionViewDelegate>

//头部标题滚动条
@property (nonatomic,weak)UIScrollView *headScrollView;

//主体collectionview
@property (nonatomic,weak)UICollectionView *mainView;

//头部按钮数组
@property (nonatomic,strong)NSMutableArray *headBtns;

//上一个被点击的按钮
@property (nonatomic,strong)UIButton *lastBtn;

//是否显示下划线
@property (nonatomic,assign)BOOL showBottomLine;

//下划线
@property (nonatomic,weak)UIView *bottomLine;

//下划线与按钮间距
@property(nonatomic ,assign)CGFloat lineOffset;

//记录滚动初始contentOffset的x坐标
@property(nonatomic ,assign)CGFloat lastOffsetX;

//记录滚动初始下划线的x坐标
@property(nonatomic ,assign)CGFloat lastLineX;

@end

@implementation LDSwitchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self prepareWork];
    }
    return self;
}


#pragma mark 私有方法

#pragma mark 初始化
-(void)prepareWork{
    _headBtns = [NSMutableArray array];
    
    ///添加头部标题
    UIScrollView *headScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STATUS_HEAD, self.frame.size.width, HEAD_HEIGHT)];
    
    self.headScrollView = headScroll;
    
    headScroll.backgroundColor = [UIColor whiteColor];
    
    headScroll.showsHorizontalScrollIndicator = NO;
    headScroll.showsHorizontalScrollIndicator = NO;
    headScroll.bounces = NO;
    
    [self addSubview:headScroll];
    
    //添加底部collectionview
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //设置流水布局属性
    //cellsize
    flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - HEAD_HEIGHT - STATUS_HEAD);
    
    //滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    //主体collection
    UICollectionView *mainView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, HEAD_HEIGHT + STATUS_HEAD, self.frame.size.width, self.frame.size.height - HEAD_HEIGHT - STATUS_HEAD) collectionViewLayout:flowLayout];
    
    [mainView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    
    mainView.bounces = NO;
    
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.pagingEnabled = YES;
    
    mainView.backgroundColor = [UIColor clearColor];
    
    self.mainView = mainView;
    [self addSubview:mainView];
    
    
}

#pragma mark 给头部scrollview添加按钮
-(void)addHeadButtons{
    //根据标题个数设置头部滚动条的contentSize
    NSInteger count = self.headTitle.count;
    
    self.headScrollView.contentSize = CGSizeMake(count * BUTTON_WIDTH, self.headScrollView.frame.size.height);
    
    //根据标题个数给头部滚动条添加按钮并注册事件
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * BUTTON_WIDTH, 0, BUTTON_WIDTH, self.headScrollView.frame.size.height)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:226 / 255.0 green:55 / 255.0 blue:58 / 255.0 alpha:1.0] forState:UIControlStateSelected];
   
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        
        [btn setTitle:self.headTitle[i] forState:UIControlStateNormal];
        
        //给btn设置标签便于方法中判断
        btn.tag = i + 1;
        
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {//直接定位到第一个按钮
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
            _lastBtn = btn;
        }
        
        [self.headBtns addObject:btn];
        
        [self.headScrollView addSubview:btn];
    }
    
    //添加下划线
    
    //下划线与按钮间距
    CGFloat lineOffset = BUTTON_WIDTH / 5;
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake( lineOffset, HEAD_HEIGHT - 1, lineOffset * 3, 1)];
    bottomLine.backgroundColor = [UIColor blackColor];
    [_headScrollView addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
}

#pragma mark 头部按钮点击方法
-(void)headBtnClick:(UIButton *)btn{
    if (self.lastBtn != nil) {
        self.lastBtn.selected = NO;
        self.lastBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    //设置按钮的被选择属性
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    //让主体collectionview滚动到相应位置
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:btn.tag - 1 inSection:0];
    
    [_mainView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    //标记为上一个被点击的按钮
    self.lastBtn = btn;
}



#pragma mark collectionview数据源方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //这时才接收到头部数组，因此在这添加头部按钮
    [self addHeadButtons];
    
    return self.headTitle.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    cell.backgroundColor = RANDOM_COLOR;
    
    return cell;
}


#pragma mark collectionView的代理方法

//停止滚动代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取停止的位置
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    //根据停止的位置获取当前索引
    NSInteger index = contentOffsetX / self.frame.size.width;
    //获取对应按钮
    UIButton *btn = _headBtns[index];
    //手动触发按钮点击方法改变按钮状态
    [self headBtnClick:btn];
    
    //获取对应按钮的x坐标
    CGFloat btnX = btn.frame.origin.x;
    //获取头部滚动条contentOffset的x坐标
    CGFloat headOffsetX = _headScrollView.contentOffset.x;
    
    //得到按钮x坐标和offsetx的对应差值
    CGFloat offX = btnX - headOffsetX;
    
    //对差值做判断进行相应操作
    if (offX < 0) {//<0按钮已经在scrollview显示范围左侧
        //滚动到相应位置
        [self.headScrollView setContentOffset:CGPointMake(btnX, 0) animated:YES];
    }else if (offX >= 5 * BUTTON_WIDTH){//>5btnWidth按钮在scrollview显示范围右侧
        
        //滚动到相应位置
        CGFloat wantedX = btnX - 4 * BUTTON_WIDTH;
        [self.headScrollView setContentOffset:CGPointMake(wantedX, 0) animated:YES];
        
    }
    
    //触发代理方法
    if ([self.delegate respondsToSelector:@selector(switchView:didSelectedItemAtIndex:)]) {
        [self.delegate switchView:self didSelectedItemAtIndex:index];
    }
    
}

//开始滚动代理方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //记录初始offsetX
    _lastOffsetX = scrollView.contentOffset.x;
    _lastLineX = _bottomLine.frame.origin.x;
}

//正在滚动代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取contentOffset的X坐标变化值
    CGFloat offOffsetX = scrollView.contentOffset.x - _lastOffsetX;
    
    if (offOffsetX > 0) {//往左滑
        //先获取下划线的frame
        CGRect frame = _bottomLine.frame;
        //根据offsetX作平移
        frame.origin.x = _lastLineX + BUTTON_WIDTH * offOffsetX / self.frame.size.width;
        _bottomLine.frame = frame;
    }else if (offOffsetX < 0){//往右滑
        //先获取下划线的frame
        CGRect frame = _bottomLine.frame;
        //根据offsetX作平移
        frame.origin.x = _lastLineX + BUTTON_WIDTH * offOffsetX / self.frame.size.width;
        _bottomLine.frame = frame;
    }
}


@end
