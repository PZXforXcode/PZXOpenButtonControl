//
//  ViewController.m
//  PZXOpenButtonControl
//
//  Created by pzx on 16/11/3.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import "ViewController.h"
#import "PZXOpenButton.h"
@interface ViewController ()<PZXOpenButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initPZXButton];
}

-(void)initPZXButton{
    //pzxopen按钮初始化
    CGRect frame = CGRectMake(0,0, 45, 45);
    PZXOpenButton *pzxButton = [[PZXOpenButton alloc]initWithCenterImage:[UIImage imageNamed:@"加号"] hilightedImage:[UIImage imageNamed:@"加号"] centerFrame:frame];
    //可以自己设置控件的中心点
//    pzxButton.foldCenter = CGPointMake(200, 200);
    pzxButton.delegate = self;
    
    
    PZXOpenSubButton *itemButton_1 = [[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"01"]
                                                           highlightedImage:[UIImage imageNamed:@"01"] buttonFrame:frame];
                                      
    PZXOpenSubButton *itemButton_2 =[[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"03"]
                                                          highlightedImage:[UIImage imageNamed:@"03"] buttonFrame:frame];
    
    PZXOpenSubButton *itemButton_3 =[[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"04"]
                                                          highlightedImage:[UIImage imageNamed:@"04"] buttonFrame:frame];
    
    PZXOpenSubButton *itemButton_4 = [[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"07"]
                                                           highlightedImage:[UIImage imageNamed:@"07"] buttonFrame:frame];;
    PZXOpenSubButton *itemButton_5 = [[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"08"]
                                                           highlightedImage:[UIImage imageNamed:@"08"] buttonFrame:frame];;
    
    [pzxButton addSubItems:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
    [self.view addSubview:pzxButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)subButtonPressedWithIndex:(NSUInteger)index{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您点击了%ld号按钮",index] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
