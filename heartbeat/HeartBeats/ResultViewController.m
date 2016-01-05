//
//  ResultViewController.m
//  HeartBeats
//
//  Created by jt3 on 15/3/11.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import "ResultViewController.h"


@interface ResultViewController ()

{
    int totalRateNumber;
    NSMutableArray *plottingHeart;
    NSDate *userBirthday;
    int age;
    NSString *averangeRateNumber;
    NSString *lastRateNumber;
}

@property (assign, nonatomic) NSInteger rowsCount;

@end

@implementation ResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totalRateNumber=0;
    
    plottingHeart=[[NSMutableArray alloc]init];
    self.navigationItem.title=NSLocalizedString(@"resultviewTitle", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(back)];

    self.rowsCount=4;
    
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self searchData];
    NSLog(@"%@   %@",plottingHeart,userBirthday);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)searchData
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* heartBeats=[NSEntityDescription entityForName:@"HeartBeatsInfo" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:heartBeats];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"beats<300"];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
    }
    for (HeartBeatsInfo* heartBeats in mutableFetchResult)
    {
        [plottingHeart addObject:heartBeats.beats];
    }
    for(NSNumber *rateNumber in plottingHeart)
    {
        totalRateNumber+=[rateNumber intValue];
    }
    int count=[plottingHeart count];
    if(count>0)
    {
        lastRateNumber=[NSString stringWithFormat:@"%@",[plottingHeart objectAtIndex:count-1]];
    }
    averangeRateNumber=[NSString stringWithFormat:@"%d",totalRateNumber/count];
    NSFetchRequest* requestUser=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [requestUser setEntity:user];
    NSError* errorUser=nil;
    NSMutableArray* mutableFetchResultUser=[[_myAppDelegate.managedObjectContext executeFetchRequest:requestUser error:&errorUser] mutableCopy];
    if (mutableFetchResultUser==nil) {
    }
    for (User* user in mutableFetchResultUser)
    {
        userBirthday=user.birthday;
    }
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:userBirthday];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    age = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        age++;
    }
}

-(void)back
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)setRowsCount:(NSInteger)rowsCount
{
    if (rowsCount < 0)
    {
        _rowsCount = 0;
    }
    else
    {
        _rowsCount = rowsCount;
    }
}

#pragma mark * Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0)
    {
        static NSString *CellIdentifier1 = @"AverangeHeartRate";
        DAContextMenuCell *cellAverange = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        cellAverange.delegate = self;
        cellAverange.tag=1;
        
        
        
        UILabel *averangeHeartNumber=(UILabel *)[cellAverange viewWithTag:100];
        UIButton *averangeButton=(UIButton *)[cellAverange viewWithTag:110];
        [averangeButton addTarget:self action:@selector(goToHistoryDetailView) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *averangeHeartRemind=(UILabel *)[cellAverange viewWithTag:105];
        averangeHeartRemind.text=NSLocalizedString(@"cellTitle1", @"");
        [averangeButton setTitle:NSLocalizedString(@"moreButtonTitle", @"") forState:UIControlStateNormal];
         
        if([averangeRateNumber isEqual:@"0"])
        {
            averangeHeartNumber.text=@"--";
        }
        else
        {
            averangeHeartNumber.text=averangeRateNumber;
        }
        return cellAverange;
    }
    else if(indexPath.row==1)
    {
        static NSString *CellIdentifier2 = @"TopHeartRate";
        DAContextMenuCell *cellTop = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        cellTop.tag=2;
        UILabel *topHeartNumber=(UILabel *)[cellTop viewWithTag:200];
        UIButton *topButton=(UIButton *)[cellTop viewWithTag:210];
        [topButton addTarget:self action:@selector(goToTopHeartView) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *MaxHeartRateRemind=(UILabel *)[cellTop viewWithTag:205];
        MaxHeartRateRemind.text=NSLocalizedString(@"cellTitle2", @"");
        [topButton setTitle:NSLocalizedString(@"moreButtonTitle", @"") forState:UIControlStateNormal];
        
        if(age>0&&age<180)
        {
            topHeartNumber.text=[NSString stringWithFormat:@"%d",220-age];
        }
        else
        {
            topHeartNumber.text=@"--";
        }
        cellTop.delegate = self;
        return cellTop;
    }
    else if(indexPath.row==2)
    {
        static NSString *CellIdentifier3 = @"HealthNumber";
        DAContextMenuCell *cellHealth = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
        cellHealth.tag=3;
        UILabel *healthNumber=(UILabel *)[cellHealth viewWithTag:300];
        UIButton *healthButton=(UIButton *)[cellHealth viewWithTag:310];
        [healthButton addTarget:self action:@selector(goToHealthNumberView) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *HealthRemind=(UILabel *)[cellHealth viewWithTag:305];
        HealthRemind.text=NSLocalizedString(@"cellTitle3", @"");
        [healthButton setTitle:NSLocalizedString(@"moreButtonTitle", @"") forState:UIControlStateNormal];
        
        if([averangeRateNumber isEqual:@"0"]||age<=0||age>180)
        {
            healthNumber.text=@"--";
        }
        else
        {
            int lasttemp=[lastRateNumber intValue];
            int healEvaluate;
            if(lasttemp/(220-age)<0.6)
            {
                healEvaluate=100-((220-age)*0.6-lasttemp)*2;
            }
            else if(lasttemp/(220-age)<=0.7&&lasttemp/(220-age)>=0.6)
            {
                healEvaluate=100;
            }
            else
            {
                healEvaluate=100-(lasttemp-(220-age)*0.7)*2;
            }
            healthNumber.text=[NSString stringWithFormat:@"%d",healEvaluate];
        }
        cellHealth.delegate = self;
        return cellHealth;
    }
    else
    {
        static NSString *CellIdentifier4 = @"BurningFatOrNot";
        DAContextMenuCell *cellBurning = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4 forIndexPath:indexPath];
        cellBurning.tag=4;
        UILabel *burnFat=(UILabel *)[cellBurning viewWithTag:400];
        UIButton *burnButton=(UIButton *)[cellBurning viewWithTag:410];
        [burnButton addTarget:self action:@selector(goToBurningView) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *BurningFatRemind=(UILabel *)[cellBurning viewWithTag:405];
        BurningFatRemind.text=NSLocalizedString(@"cellTitle4", @"");
        [burnButton setTitle:NSLocalizedString(@"moreButtonTitle", @"") forState:UIControlStateNormal];
        
        if([averangeRateNumber isEqual:@"0"]||age<=0||age>180)
        {
            burnFat.text=@"--";
        }
        else if([lastRateNumber intValue]/(220-age)>0.6)
        {
            burnFat.text=@"Yes";
        }
        else
        {
            burnFat.text=@"No";
        }
        cellBurning.delegate = self;
        return cellBurning;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.;
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    [super contextMenuCellDidSelectDeleteOption:cell];
    self.rowsCount -= 1;
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    if(cell.tag==1)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HistoryDetailView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(cell.tag==2)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"TopHeartView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(cell.tag==3)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HealthNumberView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"BurningFatView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)goToHistoryDetailView
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HistoryDetailView"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToTopHeartView
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"TopHeartView"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToHealthNumberView
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HealthNumberView"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToBurningView
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"BurningFatView"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
