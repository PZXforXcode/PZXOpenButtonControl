//
//  PZXOpenButton.h
//  coreAnimationStudy
//
//  Created by pzx on 16/11/2.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZXOpenSubButton.h"
#import <UIKit/UIKit.h>


@protocol PZXOpenButtonDelegate <NSObject>

-(void)subButtonPressedWithIndex:(NSUInteger)index;

@end

@interface PZXOpenButton : UIView

@property (weak,nonatomic)id<PZXOpenButtonDelegate> delegate;

//展开按钮图片数组
@property(strong, nonatomic)NSMutableArray *subButtonImages;
@property(strong, nonatomic)NSMutableArray *subButtonHighlightedImages;

//折叠时的中心点
@property (assign, nonatomic) CGPoint foldCenter;
//展开弧度，弧度越大按钮圆弧越大
@property (assign, nonatomic) CGFloat bloomRadius;

//初始化方法
- (instancetype)initWithCenterImage:(UIImage *)centerImage hilightedImage:(UIImage *)centerHighlightedImage centerFrame:(CGRect )frame;

//增加副按钮方法
- (void)addSubItems:(NSArray *)subButtons;




@end
