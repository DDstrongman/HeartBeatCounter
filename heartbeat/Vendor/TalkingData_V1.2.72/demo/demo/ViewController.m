//
//  ViewController.m
//  demo
//
//  Created by Biao Hou on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "TalkingData.h"
#import "SecondViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)buttonClick:(UIButton *)button {
    switch (button.tag) {

        case 1: {
            [TalkingData trackEvent:@"myEvent1"];
            [TalkingData trackEvent:@"myEvent2"];
            [TalkingData trackEvent:@"myEvent3"];
            [TalkingData trackEvent:@"myEvent4"];
            [TalkingData trackEvent:@"myEvent5"];
            [TalkingData trackEvent:@"myEvent6"];
            [TalkingData trackEvent:@"myEvent7"];
            [TalkingData trackEvent:@"myEvent8"];
            [TalkingData trackEvent:@"myEvent9"];
            [TalkingData trackEvent:@"myEvent0"];
            break;
        }
        case 2: {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"value", @"string", 
                                 [NSNumber numberWithInt:10], @"int",
                                 [NSNumber numberWithShort:8], @"short",
                                 [NSNumber numberWithLongLong:7788], @"int64", 
                                 [NSNumber numberWithDouble:10.3], @"double", 
                                 [NSNumber numberWithBool:YES], @"bool",
                                 [NSNumber numberWithUnsignedInt:30], @"uint", nil];
            [TalkingData trackEvent:@"myEvent1" label:@"label1" parameters:dic];
            break;
        }
        case 3: {
            NSArray *arr = [NSArray array];
            [arr objectAtIndex:NSIntegerMax];
            break;
        } 
        case 4: {
            raise(SIGSEGV);
//            for (int i = 0; i < 1000; i++) {
//                [TalkingData trackEvent:[NSString stringWithFormat:@"%d", i]];
//            }
            break;
        }
        case 5: {
            SecondViewController *second = [[SecondViewController alloc] init];
            [self presentModalViewController:second animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.tag = 1;
    button1.frame = CGRectMake(10, 10, 200, 30);
    [button1 setTitle:@"event:myEvent1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.tag = 2;
    button2.frame = CGRectMake(10, 50, 200, 30);
    [button2 setTitle:@"event:myEvent1:标签1" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.tag = 3;
    button3.frame = CGRectMake(10, 90, 200, 30);
    [button3 setTitle:@"exception" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.tag = 4;
    button4.frame = CGRectMake(10, 130, 200, 30);
    [button4 setTitle:@"signal" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button5.tag = 5;
    button5.frame = CGRectMake(10, 170, 200, 30);
    [button5 setTitle:@"trackPageView" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload]; 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[TalkingData trackPageBegin:@"home_page"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    //[TalkingData trackPageEnd:@"home_page"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
