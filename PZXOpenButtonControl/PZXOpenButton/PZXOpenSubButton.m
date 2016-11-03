//
//  PZXOpenSubButton.m
//  coreAnimationStudy
//
//  Created by pzx on 16/11/3.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import "PZXOpenSubButton.h"

@interface PZXOpenSubButton ()

//背景
@property(strong, nonatomic)UIImageView *backgroundImageView;

@end

@implementation PZXOpenSubButton

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage buttonFrame:(CGRect)frame
{
    if (self = [super init]) {
        
        //设置按钮frame
        CGRect itemFrame = frame;
        

        self.frame = itemFrame;
        
        //设置按钮图片
//        self.image = backgroundImage;
//        self.highlightedImage = backgroundHighlightedImage;
        
        self.userInteractionEnabled = YES;
        
        //设置背景view
        _backgroundImageView = [[UIImageView alloc]initWithImage:image
                                                highlightedImage:highlightedImage];
        _backgroundImageView.frame = itemFrame;
        _backgroundImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:_backgroundImageView];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    self.backgroundImageView.highlighted = YES;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if ([_delegate respondsToSelector:@selector(subButtonPressed:)]) {
        [_delegate subButtonPressed:self];
    }
    
    self.highlighted = NO;
    self.backgroundImageView.highlighted = NO;
}

@end
