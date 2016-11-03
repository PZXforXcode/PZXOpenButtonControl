# PZXOpenButtonControl
  模仿书摘中心的展开按钮封装的一个控件，轻量级，很好用好用，不支持cocoaPod。

   //pzxopen按钮初始化\n
    CGRect frame = CGRectMake(0,0, 45, 45);
    PZXOpenButton *pzxButton = [[PZXOpenButton alloc]initWithCenterImage:[UIImage imageNamed:@"加号"] hilightedImage:[UIImage imageNamed:@"加号"] centerFrame:frame];
        //可以自己设置控件的中心点
     pzxButton.foldCenter = CGPointMake(200, 200);
  //添加f附属按钮
   PZXOpenSubButton *itemButton_1 = [[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"01"]
                                                           highlightedImage:[UIImage imageNamed:@"01"] buttonFrame:frame];
                                      
    PZXOpenSubButton *itemButton_2 =[[PZXOpenSubButton alloc]initWithImage:[UIImage imageNamed:@"03"]
                                                          highlightedImage:[UIImage imageNamed:@"03"] buttonFrame:frame];

  //add附属按钮
    [pzxButton addSubItems:@[itemButton_1, itemButton_2]];
    [self.view addSubview:pzxButton];
    
    //d点击事件代理
    -(void)subButtonPressedWithIndex:(NSUInteger)index

![image](https://github.com/PZXforXcode/PZXOpenButtonControl/blob/master/PZXOpenButtonControl/sz控件.gif) 
