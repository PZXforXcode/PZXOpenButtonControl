//
//  PZXOpenButton.m
//  coreAnimationStudy
//
//  Created by pzx on 16/11/2.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import "PZXOpenButton.h"
#import "PZXOpenCenterButton.h"

#define items


@interface PZXOpenButton ()<PZXOpenSubButtonDelegate,PZXCenterButtonDelegate>

#pragma mark - 私有属性

//中心按钮图片
@property (strong, nonatomic) UIImage *centerImage;
@property (strong, nonatomic) UIImage *centerHighlightedImage;

//是否展开
@property (assign, nonatomic, getter = isBloom) BOOL bloom;

//折叠时的size
@property (assign, nonatomic) CGSize foldedSize;
//展开时的size
@property (assign, nonatomic) CGSize bloomSize;

//展开按钮中心店
@property (assign, nonatomic) CGPoint ButtonBloomCenter;
//底层view
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) PZXOpenCenterButton *CenterButton;
//副按钮数组
@property (strong, nonatomic) NSMutableArray *itemButtons;

//按钮frame
@property (assign, nonatomic) CGRect centerButtonFrame;

@end

@implementation PZXOpenButton

#pragma mark - Initialization
-(instancetype)initWithCenterImage:(UIImage *)centerImage hilightedImage:(UIImage *)centerHighlightedImage centerFrame:(CGRect)frame{
    if (self = [super init]) {
        
        self.centerImage = centerImage;
        self.centerHighlightedImage = centerHighlightedImage;
        
        
        self.subButtonImages = [[NSMutableArray alloc]init];
        self.subButtonHighlightedImages = [[NSMutableArray alloc]init];
        self.itemButtons = [[NSMutableArray alloc]init];
    
        self.foldedSize = frame.size;
        self.centerButtonFrame = frame;

        //初始化界面
        [self initializeUserInterface];
        
    }
    return self;

}

-(void)initializeUserInterface{
    
    //折叠size等于中心图片的size,如果改大会挡道其他控件的事件，最好等于中心图片size
    //展开size等于屏幕的size,bottomView的size=他。
    self.bloomSize = [UIScreen mainScreen].bounds.size;
    //一开始是不展开状态，一开始只能为no。不是这个属性改变状态是为了判断
    self.bloom = NO;
    //展开弧度
    self.bloomRadius  = 100.f;
    //折叠按钮的中心点位置（改为可变）
    self.foldCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height/2);
    
   //调解button的frame和center
    self.frame = CGRectMake(0, 0, self.foldedSize.width, self.foldedSize.height);
    self.center = self.foldCenter;
    
    //设置中心按钮
    _CenterButton = [[PZXOpenCenterButton alloc]initWithImage:self.centerImage highlightedImage:self.centerHighlightedImage];
    _CenterButton.frame = _centerButtonFrame;
    _CenterButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _CenterButton.delegate = self;
    [self addSubview:_CenterButton];

    //设置底层view
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height)];
    _bottomView.backgroundColor = [UIColor blackColor];


}
#pragma mark - set方法们//不能用self. 只能用_
//设置图片
- (void)setCenterImage:(UIImage *)centerImage
{
    if (!centerImage) {
        NSLog(@"读取图片出错了!");
        return ;
    }
    _centerImage = centerImage;
}

- (void)setCenterHighlightedImage:(UIImage *)highlightedImage
{
    if (!highlightedImage) {
        NSLog(@"读取图片出错了!");
        return ;
    }
    _centerHighlightedImage = highlightedImage;
}
//设置控件在屏幕位置
-(void)setFoldCenter:(CGPoint)foldCenter{
    
    
        _foldCenter = foldCenter;
        self.center = _foldCenter;
 
}
//设置扩展点中心
- (void)setPathCenterButtonBloomCenter:(CGPoint)centerButtonBloomCenter
{
    // Just set the bloom center once
    //
    if (_ButtonBloomCenter.x == 0) {
        _ButtonBloomCenter = centerButtonBloomCenter;
    }
    return ;
}

//是否展开
- (BOOL)isBloom
{
    return _bloom;
}


#pragma mark - 中心按钮代理PZXCenterButtonDelegate
-(void)centerButtonPressed{

    self.isBloom? [self CenterButtonFold] : [self CenterButtonBloom];
}


#pragma mark - 计算副按钮的结束点

- (CGPoint)createEndPointWithRadius:(CGFloat)itemExpandRadius andAngel:(CGFloat)angel
{
    
    //中心点相减x弧度,密码线。
    //1.10个圆形算法(如果减少圆形个数，就要加大2.25这个基数)：
    return CGPointMake(self.ButtonBloomCenter.x - cosf((angel*2.25) * M_PI) * itemExpandRadius,
                       self.ButtonBloomCenter.y - sinf((angel*2.25) * M_PI) * itemExpandRadius);
    //1.半圆算法：
//    return CGPointMake(self.ButtonBloomCenter.x - cosf((angel) * M_PI) * itemExpandRadius,
//                       self.ButtonBloomCenter.y - sinf((angel) * M_PI) * itemExpandRadius);
    
}

#pragma mark - 中心按钮折叠
- (void)CenterButtonFold{
    
    for (int i = 0; i<self.itemButtons.count;i++) {
        
        PZXOpenSubButton *itemButton = self.itemButtons[i];

        //当前按钮的角度
        CGFloat currentAngel = (i+1) / ((CGFloat)self.itemButtons.count + 1);
        
        //算出远点(动画有个像远点拉一下的效果需要远点)，密码线
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 5.0f andAngel:currentAngel];
        //制作组合动画
        CAAnimationGroup *foldAnimation = [self foldAnimationFromPoint:itemButton.center withFarPoint:farPoint];

        //给按钮加上动画并设置按钮展开中心
        [itemButton.layer addAnimation:foldAnimation forKey:@"foldAnimation"];
        itemButton.center = self.ButtonBloomCenter;
    }
    
    //把中心按钮放到最前面
    [self bringSubviewToFront:self.CenterButton];
    //旋转中心按钮回去以及撤销背景view
    [self resizeToFoldedFrame];
}


- (void)resizeToFoldedFrame
{
    //动画比较简单用的uikit框架
    _CenterButton.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    //旋转按钮动画
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0618f * 2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _CenterButton.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:nil];
   
    //背景view隐藏
    [UIView animateWithDuration:0.1f
                          delay:0.35f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _bottomView.alpha = 0.0f;
                     }
                     completion:nil];
    
    //GCD在主线程刷新UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //删除数组里面的所有副按钮
        for (PZXOpenSubButton *itemButton in self.itemButtons) {
            [itemButton performSelector:@selector(removeFromSuperview)];
        }
        //设置控件frame以及中心
        self.frame = CGRectMake(0, 0, self.foldedSize.width, self.foldedSize.height);
        self.center = self.foldCenter;
            //设置中心按钮的center
        self.CenterButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        //删除底层view
        [self.bottomView removeFromSuperview];
        _CenterButton.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
    });
    //展开状态关闭
    _bloom = NO;
    
}
//用CAAnimationGroup制作组合动画，学习动画核心。
- (CAAnimationGroup *)foldAnimationFromPoint:(CGPoint)endPoint withFarPoint:(CGPoint)farPoint{
    
    //1.旋转动画
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //0 - π - 2π
    rotationAnimation.values = @[@(0), @(M_PI), @(M_PI * 2)];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.35f;
    // 2.移动动画
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 画移动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //按钮点
    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    //远点路径
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    //中心路径
    CGPathAddLineToPoint(path, NULL, self.ButtonBloomCenter.x, self.ButtonBloomCenter.y);
    
    //设置关键时间点
    movingAnimation.keyTimes = @[@(0.0f), @(0.75), @(1.0)];
    //路径= path
    movingAnimation.path = path;
    movingAnimation.duration = 0.35f;
    //释放路径
    CGPathRelease(path);

    //组合2个动画
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[rotationAnimation, movingAnimation];
    animations.duration = 0.35f;
    
    return animations;
    
}

#pragma mark - 中心按钮展开
- (void)CenterButtonBloom{
    _CenterButton.userInteractionEnabled = NO;

    //1.设置展开中心为当前中心
    self.ButtonBloomCenter = self.center;
    // 2. 设置
    self.frame = CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height);
    self.center = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height / 2);

    //插入view到中心按钮
    [self insertSubview:self.bottomView belowSubview:self.CenterButton];

    
    // 3. uikit动画
    //
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bottomView.alpha = 0.618f;
                     }
                     completion:^(BOOL finished) {
                         _CenterButton.userInteractionEnabled = YES;

                     }];
    
    //
    [UIView animateWithDuration:0.1575f
                     animations:^{
                         _CenterButton.transform = CGAffineTransformMakeRotation(-0.75f * M_PI);
                     }];

    self.CenterButton.center = self.ButtonBloomCenter;


    // 4.展开动画设置
    
    //设置基本角度（扇形展开的角度）
    CGFloat basicAngel = 180 / (self.itemButtons.count + 1) ;
    
    for (int i = 0; i<self.itemButtons.count; i++) {
        
        PZXOpenSubButton *pathItemButton = self.itemButtons[i];
        pathItemButton.delegate = self;
        pathItemButton.tag = i;
        pathItemButton.transform = CGAffineTransformMakeTranslation(1, 1);
        pathItemButton.alpha = 1.0f;
        
        // 1. 添加按钮
        
        //计算当前按钮角度
        CGFloat currentAngel = (basicAngel * (i+1))/180;
        
        
        pathItemButton.center = self.ButtonBloomCenter;
        
        [self insertSubview:pathItemButton belowSubview:self.CenterButton];

        // 2.设置扩展动画
        //
        //设置展开的落点
        CGPoint endPoint = [self createEndPointWithRadius:self.bloomRadius andAngel:currentAngel];
        //设置最远点（动画有个从最远点回来的效果）
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 10.0f andAngel:currentAngel];
        //设置近点（动画有个从远点到近点在回去的效果）
        CGPoint nearPoint = [self createEndPointWithRadius:self.bloomRadius - 5.0f andAngel:currentAngel];
        
        CAAnimationGroup *bloomAnimation = [self bloomAnimationWithEndPoint:endPoint
                                                                andFarPoint:farPoint
                                                               andNearPoint:nearPoint];
        
        [pathItemButton.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];
        pathItemButton.center = endPoint;

        
    }
    
    _bloom = YES;


}


- (CAAnimationGroup *)bloomAnimationWithEndPoint:(CGPoint)endPoint andFarPoint:(CGPoint)farPoint andNearPoint:(CGPoint)nearPoint{
    //1.旋转动画
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0.0), @(- M_PI), @(- M_PI * 1.5), @(- M_PI * 2)];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.keyTimes = @[@(0.0), @(0.3), @(0.6), @(1.0)];
    
    //2.移动动画
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    

    //
    CGMutablePathRef path = CGPathCreateMutable();
    //中心点开始
    CGPathMoveToPoint(path, NULL, self.ButtonBloomCenter.x, self.ButtonBloomCenter.y);
    //先到远点
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    //然后到近点
    CGPathAddLineToPoint(path, NULL, nearPoint.x, nearPoint.y);
    //最后到到达点
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    movingAnimation.path = path;
    movingAnimation.keyTimes = @[@(0.0), @(0.5), @(0.7), @(1.0)];
    movingAnimation.duration = 0.3f;
    CGPathRelease(path);
    
    
    // 3.组合动画
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[movingAnimation, rotationAnimation];
    animations.duration = 0.3f;
    
    return animations;

}
#pragma mark - 添加按钮方法

- (void)addSubItems:(NSArray *)pathItemButtons
{
    [self.itemButtons addObjectsFromArray:pathItemButtons];
}
#pragma mark - 点击背景触发

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self CenterButtonFold];
}

#pragma mark - 副按钮代理PZXOpenSubButtonDelegate
-(void)subButtonPressed:(PZXOpenSubButton *)subSender{

    NSLog(@"tag=%ld",subSender.tag);

    if ([_delegate respondsToSelector:@selector(subButtonPressedWithIndex:)]  ) {
        
        PZXOpenSubButton *selectedButton= self.itemButtons[subSender.tag];//tag来判断点击的哪个
        
        //放大和渐隐动画
        [UIView animateWithDuration:0.0618f * 5
                         animations:^{
                             selectedButton.transform = CGAffineTransformMakeScale(3, 3);
                             selectedButton.alpha = 0.0f;
                         }];
        
        // Excute the dismiss animation when the item is unselected
        //
        for (int i = 0; i < self.itemButtons.count; i++) {
            //如果是当前按钮不走这个动画
            if (i == selectedButton.tag) {
                continue;
            }
            //其他按钮消失
            PZXOpenSubButton *unselectedButton = self.itemButtons[i];
            [UIView animateWithDuration:0.0618f * 2
                             animations:^{
                                 unselectedButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
                             }];
        }

        [_delegate subButtonPressedWithIndex:subSender.tag];
        
        [self resizeToFoldedFrame];


        
    }
    
    
}

@end
