//
//  FZViewItem.h
//  图片排列
//
//  Created by 谢方振 on 15/11/30.
//  Copyright © 2015年 谢方振. All rights reserved.
//
#define SCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width

#import <UIKit/UIKit.h>

@class FZViewItem;
@protocol FZViewItemDelegate <NSObject>

- (void)ViewItemEnterEditingMode:(FZViewItem*)viewItem;
- (void)viewItemMovingWithItem:(FZViewItem*)viewItem withGesture:(UILongPressGestureRecognizer*)gesture withPoint:(CGPoint)oldPoint;
- (void)viewItemDidMoved:(FZViewItem*)viewItem withLocation:(CGPoint)point withGesture:(UILongPressGestureRecognizer*)gesture;
- (void)viewItemDeletedFromSuperView:(FZViewItem*)viewItem;
- (void)pushDetail:(FZViewItem*)viewItem;
@end

@interface FZViewItem : UIView
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSDictionary* model;
@property(nonatomic,weak)id<FZViewItemDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame atIndex:(NSInteger)index;
- (void)enterEditingState;
- (void)endEditingState;
@end

