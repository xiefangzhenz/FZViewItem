//
//  ListViewController.h
//  图片排列
//
//  Created by 谢方振 on 15/12/2.
//  Copyright © 2015年 谢方振. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TransFormBlock)(NSDictionary* dict);
@interface ListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray* currentList;
@property(copy,nonatomic)TransFormBlock block;
@end
