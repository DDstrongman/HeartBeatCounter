//
//  userNavigationViewController.m
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import "userNavigationViewController.h"

@interface userNavigationViewController ()

@end

@implementation userNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor=[UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 40, 40)];
    leftButton.tintColor=[UIColor purpleColor];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"cancelMeasurementNavBarIcon@2x.png"]  forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftBarButton;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navigationbg.png"] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
