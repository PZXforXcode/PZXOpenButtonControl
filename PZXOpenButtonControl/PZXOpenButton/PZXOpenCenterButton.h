//
//  PZXOpenCenterButton.h
//  coreAnimationStudy
//
//  Created by pzx on 16/11/3.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PZXCenterButtonDelegate <NSObject>

-(void)centerButtonPressed;

@end


@interface PZXOpenCenterButton : UIImageView

@property (weak, nonatomic) id<PZXCenterButtonDelegate> delegate;

@end
