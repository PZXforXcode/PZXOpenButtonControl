//
//  PZXOpenCenterButton.m
//  coreAnimationStudy
//
//  Created by pzx on 16/11/3.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import "PZXOpenCenterButton.h"

@implementation PZXOpenCenterButton

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        
        self.userInteractionEnabled = YES;
        
        self.image = image;
        self.highlightedImage = highlightedImage;
        
    }
    return self;
}


//点击事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.highlighted = YES;
    // 点击之后通过代理在button主控件里面触发事件
    if ([_delegate respondsToSelector:@selector(centerButtonPressed)]) {
        [_delegate centerButtonPressed];
    }

}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.highlighted = NO;//高光关闭


}
@end
