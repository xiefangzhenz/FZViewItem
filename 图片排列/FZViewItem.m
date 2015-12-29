//
//  FZViewItem.m
//  图片排列
//
//  Created by 谢方振 on 15/11/30.
//  Copyright © 2015年 谢方振. All rights reserved.
//

#import "FZViewItem.h"
@interface FZViewItem(){

    
    
    UIButton* deleteButton;
    
    UIButton* selectButton;
    
    UILabel* selectLabel;
    
    CGPoint _point;
    


}
@end
@implementation FZViewItem

- (instancetype)initWithFrame:(CGRect)frame atIndex:(NSInteger)index {

    self  = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        _index = index;
        
        
        selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectButton];
        
        selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, selectButton.frame.size.height, frame.size.width, frame.size.height-frame.size.width)];
        selectLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:selectLabel];
        
        deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-15,0 , 15, 15)];
        [deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.hidden = YES;
        [self addSubview:deleteButton];
        
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        
        [self addGestureRecognizer:longPress];
        
        

    }
    
    
    return self;

}
-(void)setModel:(NSDictionary *)model{

    _model = model;
    
    [selectButton setImage:[UIImage imageNamed:model[@"imageName"]] forState:UIControlStateNormal];

    selectLabel.text = model[@"title"];

}
- (void)deleteAction{

    
    [self.delegate viewItemDeletedFromSuperView:self];

}

- (void)selectButtonAction:(UIButton*)sender{
    
    
    [self.delegate pushDetail:self];
    
}
- (void)longPressAction:(UILongPressGestureRecognizer*)longGesture{

    
    switch (longGesture.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            _point = [longGesture locationInView:self];
            
            [self.delegate ViewItemEnterEditingMode:self];
            
            break;
        }
        
        case UIGestureRecognizerStateChanged:
        {
        
            [self.delegate viewItemMovingWithItem:self withGesture:longGesture withPoint:_point];
            
            break;
        }
           
        case UIGestureRecognizerStateEnded:
        {
            
            [self.delegate viewItemDidMoved:self withLocation:_point withGesture:longGesture];
            
            break;
        
        }
        default:
            break;
    }


}
- (void)enterEditingState{

    deleteButton.hidden = NO;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.repeatCount = MAXFLOAT;
    shake.autoreverses = YES;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.03, 0.0, 0.0, 1.0)];
    shake.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.03, 0.0, 0.0, 1.0)];
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    

}
- (void)endEditingState{

    [self.layer removeAnimationForKey:@"shakeAnimation"];
    deleteButton.hidden = YES;

}

@end
