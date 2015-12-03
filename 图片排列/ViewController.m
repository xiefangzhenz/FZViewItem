//
//  ViewController.m
//  图片排列
//
//  Created by 谢方振 on 15/11/30.
//  Copyright © 2015年 谢方振. All rights reserved.
//

#import "FZViewItem.h"
#import "ViewController.h"

@interface ViewController ()
{
    //所有button放在上面
    UIView* bgView;
    
    NSMutableArray* viewItemArr;
    
    UIButton* _addButton;
    
    NSMutableArray* _dataList;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray* arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"viewItemData"];
    
    if (!arr) {
        
        arr = @[@{@"title":@"华夏银行",@"imageName":@"HXB"},
                @{@"title":@"工商银行",@"imageName":@"ICBC"},
                @{@"title":@"深圳发展银行",@"imageName":@"SDB"},
                @{@"title":@"浦东发展银行",@"imageName":@"SPDB"}
                ];
        
        
    }
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"viewItemData"];
    
    
    NSArray* currentArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentViewItemData"];
    if (!currentArr) {
        
        currentArr = @[@{@"title":@"农业银行",@"imageName":@"ABC"},
                       @{@"title":@"交通银行",@"imageName":@"BCM"},
                       @{@"title":@"中国银行",@"imageName":@"BOC"},
                       @{@"title":@"建设银行",@"imageName":@"CCB"},
                       @{@"title":@"光大银行",@"imageName":@"CEB"},
                       @{@"title":@"招商银行",@"imageName":@"CMB"},
                       @{@"title":@"民生银行",@"imageName":@"CMBC"},
                       @{@"title":@"中信银行",@"imageName":@"CNCB"},
                       @{@"title":@"浙商银行",@"imageName":@"CZB"},
                       @{@"title":@"恒丰银行",@"imageName":@"EVERGROWING"},
                       @{@"title":@"广东发展银行",@"imageName":@"GDB"}
                       ];
    }

    _dataList = [[NSMutableArray alloc]initWithArray:currentArr];
    
    
    viewItemArr  = [[NSMutableArray alloc]init];
    
    
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 600)];
    
    [self.view addSubview:bgView];
    
    _addButton = [[UIButton alloc]init];
    _addButton.titleLabel.text = @"添加";
    _addButton.titleLabel.textColor = [UIColor blackColor];
    _addButton.frame = CGRectMake(0, 0, 100, 100);
    _addButton.backgroundColor = [UIColor grayColor];
    [_addButton addTarget:self action:@selector(pushListController) forControlEvents:UIControlEventTouchUpInside];
    
    //显示按钮，如果没有就只显示添加
    for (int i = 0; i<_dataList.count; i++) {
            
            FZViewItem* viewItem = [[FZViewItem alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-5*10)/4*(i%4)+(10*(i%4+1)), (i/4)*10+((SCREEN_WIDTH-5*10)/4+30)*(i/4), (SCREEN_WIDTH-5*10)/4, (SCREEN_WIDTH-5*10)/4+30)  atIndex:i];
            viewItem.delegate = self;
            viewItem.model = _dataList[i];
            [bgView addSubview:viewItem];
            [viewItemArr addObject:viewItem];
    }
    
    
        //添加加号
        CGPoint point = [self viewPointAtIndex:_dataList.count];
        _addButton.frame = CGRectMake(point.x, point.y, _addButton.frame.size.width, _addButton.frame.size.height);
        [bgView addSubview:_addButton];
        [viewItemArr addObject:_addButton];
    
    
    //点击其他地方，编辑状态消失
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    
    
    [self.view addGestureRecognizer:tapGesture];
    
    
}
- (void)tapAction:(UITapGestureRecognizer*)tapGestureRecognizer{

    for (FZViewItem* view in bgView.subviews) {
        
        if ([view respondsToSelector:@selector(endEditingState)]) {
            
            [view endEditingState];
        }
        
    }
    


}
- (void)pushListController{

    ListViewController* list = [[ListViewController alloc]init];
    
    list.currentList = _dataList;
    
    [list setBlock:^(NSDictionary* dict){
    
        
        [self addButtonAction:dict];
        
    
    }];
    
    [self.navigationController pushViewController:list animated:YES];


}
//根据坐标获取当前view是第几个
- (NSInteger)viewIndexforPoint:(CGPoint)point{

    NSInteger a = point.x/SCREEN_WIDTH*4;
    NSInteger b = point.y/((SCREEN_WIDTH-5*10)/4+30);
    
    return 4*b+a;
    

}
//根据索引获取view
- (CGPoint)viewPointAtIndex:(NSInteger)index{

    
    return  CGPointMake((SCREEN_WIDTH-5*10)/4*(index%4)+(10*(index%4+1)), (index/4)*10+((SCREEN_WIDTH-5*10)/4+30)*(index/4));

}
- (void)addButtonAction:(NSDictionary*)dict{
    
    [self tapAction:nil];
    
    NSInteger i = viewItemArr.count-1;
    
    FZViewItem* viewItem = [[FZViewItem alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-5*10)/4*(i%4)+(10*(i%4+1)), (i/4)*10+((SCREEN_WIDTH-5*10)/4+30)*(i/4), (SCREEN_WIDTH-5*10)/4, (SCREEN_WIDTH-5*10)/4+30)  atIndex:i];
    
    viewItem.model = dict;
    
    viewItem.delegate = self;
    
    [bgView addSubview:viewItem];
    
    [viewItemArr insertObject:viewItem atIndex:i];

    [_addButton setFrame:CGRectMake((SCREEN_WIDTH-5*10)/4*((i+1)%4)+(10*((i+1)%4+1)), ((i+1)/4)*10+((SCREEN_WIDTH-5*10)/4+30)*((i+1)/4), 100,100)];
    
    [_dataList addObject:dict];
    
    [[NSUserDefaults standardUserDefaults]setObject:_dataList forKey:@"currentViewItemData"];
    NSMutableArray* arr =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"viewItemData"]];
    [arr removeObject:dict];
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"viewItemData"];
   
}
//交换两个view的index
- (void)changeOldViewPlaceIndex:(NSInteger)oldIndex withNewIndex:(NSInteger)newIndex{

    
    ((FZViewItem*)[viewItemArr objectAtIndex:oldIndex]).index = newIndex;
    ((FZViewItem*)[viewItemArr objectAtIndex:newIndex]).index = oldIndex;
    [viewItemArr exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
    [_dataList exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
     [[NSUserDefaults standardUserDefaults]setObject:_dataList forKey:@"currentViewItemData"];
    
}
#pragma mark - FZViewDelegate
- (void)ViewItemEnterEditingMode:(FZViewItem*)viewItem{

    for (FZViewItem* view  in bgView.subviews) {
        
        if ([view respondsToSelector:@selector(enterEditingState)]) {
            
            [view enterEditingState];
        }
        
    }
    


}
- (void)viewItemMovingWithItem:(FZViewItem*)viewItem withGesture:(UILongPressGestureRecognizer*)gesture withPoint:(CGPoint)oldPoint{

    CGRect oldFrame = viewItem.frame;
    
    CGPoint newPoint = [gesture locationInView:bgView];
    
    oldFrame.origin.x = newPoint.x - oldPoint.x;
    oldFrame.origin.y = newPoint.y - oldPoint.y;
    
    viewItem.frame = oldFrame;
    
    NSInteger toViewIndex = [self viewIndexforPoint:CGPointMake(newPoint.x, newPoint.y)];

    NSInteger fromViewIndex = viewItem.index;

    if ((toViewIndex!=fromViewIndex) && (toViewIndex<viewItemArr.count-1 && fromViewIndex<viewItemArr.count-1)) {
        
        [UIView animateWithDuration:.15 animations:^{
            
            for (FZViewItem* item in bgView.subviews) {
                
                if ([item isKindOfClass:[FZViewItem class]] ) {
                    
                    if (item.index == toViewIndex  ) {
                        
                        CGPoint point = [self viewPointAtIndex:fromViewIndex];
                        
                        item.frame = CGRectMake(point.x, point.y, item.frame.size.width, item.frame.size.height) ;
                    }
                }
                
                
            }
            
        }];
        [self changeOldViewPlaceIndex:toViewIndex withNewIndex:fromViewIndex];
        
        
        
    }
    


}
- (void)viewItemDidMoved:(FZViewItem*)viewItem withLocation:(CGPoint)point withGesture:(UILongPressGestureRecognizer*)gesture{
    
    NSInteger i = viewItem.index;
    
    [viewItem setFrame:CGRectMake((SCREEN_WIDTH-5*10)/4*((i)%4)+(10*((i)%4+1)), ((i)/4)*10+((SCREEN_WIDTH-5*10)/4+30)*((i)/4), 100,100)];

}


- (void)viewItemDeletedFromSuperView:(FZViewItem*)viewItem{

    FZViewItem* item = [viewItemArr objectAtIndex:viewItem.index];
    
    [item removeFromSuperview];
    
    [viewItemArr removeObjectAtIndex:viewItem.index];
    
    [_dataList removeObjectAtIndex:viewItem.index];
    [[NSUserDefaults standardUserDefaults]setObject:_dataList forKey:@"currentViewItemData"];
    NSMutableArray* arr = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"viewItemData"]];
    [arr addObject:viewItem.model];
    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"viewItemData"];
    
    //删除之后序号变化，原来i的位置被i+1替代，需要把i+1的序号跟frame改变
    for (int i = (int)viewItem.index; i<viewItemArr.count; i++) {
        
        FZViewItem* viewItemTemp = [viewItemArr objectAtIndex:i];
        
        CGPoint point = [self viewPointAtIndex:i];
        
        if ([viewItemTemp isKindOfClass:[FZViewItem class]]) {
            
             viewItemTemp.index = viewItemTemp.index-1;
            
            viewItemTemp.frame = CGRectMake(point.x, point.y, viewItemTemp.frame.size.width, viewItemTemp.frame.size.height);
        }else{
        
            viewItemTemp.frame = CGRectMake(point.x, point.y, viewItemTemp.frame.size.width, viewItemTemp.frame.size.height);
        
        }

    }
    
    

    
    

}
- (void)pushDetail:(FZViewItem*)viewItem{


    CommenViewController* controller = [[CommenViewController alloc]init];
    controller.title = viewItem.model[@"title"];
    [self.navigationController pushViewController:controller animated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
