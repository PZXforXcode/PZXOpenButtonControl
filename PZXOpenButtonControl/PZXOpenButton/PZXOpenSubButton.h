//
//  PZXOpenSubButton.h
//  coreAnimationStudy
//
//  Created by pzx on 16/11/3.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PZXOpenSubButton;//声明类，不然下面代理方法报错

@protocol PZXOpenSubButtonDelegate <NSObject>

-(void)subButtonPressed:(PZXOpenSubButton *)subSender;

@end

@interface PZXOpenSubButton : UIImageView


@property (assign, nonatomic) NSUInteger index;
@property (weak, nonatomic) id<PZXOpenSubButtonDelegate > delegate;


- (instancetype)initWithImage:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage
                  buttonFrame:(CGRect )frame;
@end
