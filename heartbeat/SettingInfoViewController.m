


#import "SettingInfoViewController.h"

//static float Version=1.0;

@interface SettingInfoViewController ()

{
    NSString *name;
    NSString *sex;
    NSString *age;
    NSDate   *birthday;
}

@property (strong, nonatomic) OCBorghettiView *accordion;

@end

@implementation SettingInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"settingViewTitle", @"");
    self.navigationItem.hidesBackButton=YES;
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
    rightButton.tintColor=[UIColor purpleColor];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"cancelMeasurementNavBarIcon@2x.png"]  forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    
    [self setupAccordion];
}

- (void)setupAccordion
{
    self.accordion = [[OCBorghettiView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60)];
    self.accordion.accordionSectionHeight = 40;
    
    self.accordion.accordionSectionFont = [UIFont fontWithName:@"Avenir" size:16];
    
    self.accordion.accordionSectionBorderColor = [UIColor whiteColor];
    self.accordion.accordionSectionColor = [UIColor orangeColor];
    [self.view addSubview:self.accordion];
    
    // Section User
    UITableView *sectionTwo = [[UITableView alloc] init];
    [sectionTwo setTag:1];
    [sectionTwo setDelegate:self];
    [sectionTwo setDataSource:self];
    [self.accordion addSectionWithTitle:NSLocalizedString(@"historyTitle", @"")
                                andView:sectionTwo];
    // Section Two
    UITableView *sectionUser = [[UITableView alloc] init];
    [sectionUser setTag:2];
    [sectionUser setDelegate:self];
    [sectionUser setDataSource:self];
    [self.accordion addSectionWithTitle:NSLocalizedString(@"userTitle", @"")
                                andView:sectionUser];
    
    // Section Three
//    UITableView *sectionThree = [[UITableView alloc] init];
//    [sectionThree setTag:3];
//    [sectionThree setDelegate:self];
//    [sectionThree setDataSource:self];
//    [self.accordion addSectionWithTitle:@"App Information"
//                                andView:sectionThree];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1)
    {
        return 3;
    }
    else// if (tableView.tag==2)
    {
        return 3;
    }
//    else
//    {
//        return 3;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"borghetti_cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"borghetti_cell"];
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    [self searchDataSource];
    if(tableView.tag==2)
    {
        if(indexPath.row==0)
        {
            if(name!=nil)
            {
                cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"userName", @""),name];
            }
            else
            {
                cell.textLabel.text=NSLocalizedString(@"userNameNil", @"");
            }
        }
        else if(indexPath.row==1)
        {
           if(age!=nil)
           {
               cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"userAge", @""),age];
           }
           else
           {
               cell.textLabel.text=NSLocalizedString(@"userAgeNil", @"");
           }
        }
        else
        {
            if(sex!=nil)
            {
                cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"userGender", @""),sex];
            }
            else
            {
                cell.textLabel.text=NSLocalizedString(@"userGenderNil", @"");
            }
        }
        
    }
    else if(tableView.tag==1)
    {
        if(indexPath.row==0)
        {
            cell.textLabel.text=NSLocalizedString(@"historyDetails", @"");
        }
        else if(indexPath.row==1)
        {
            cell.textLabel.text=NSLocalizedString(@"adviceCell", @"");
        }
        else
        {
            cell.textLabel.text=NSLocalizedString(@"resetCell", @"");
        }
    }
//    else
//    {
//        if(indexPath.row==0)
//        {
//            cell.textLabel.text=[NSString stringWithFormat:@"Version: %f", Version];
//        }
//        else if(indexPath.row==1)
//        {
//            cell.textLabel.text=@"FAQ";
//        }
//        else
//        {
//            cell.textLabel.text=@"Contact us";
//        }
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"Table %d - Cell %d", tableView.tag, indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:0.46f green:0.46f blue:0.46f alpha:1.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1)
    {
        if(indexPath.row==0)
        {
//            cell.textLabel.text=@"UserName";
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"UserInfoView"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row==1)
        {
            //            cell.textLabel.text=@"Sex";
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"UserInfoView"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //            cell.textLabel.text=@"Age";
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"UserInfoView"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if(tableView.tag==2)
    {
        if(indexPath.row==0)
        {
            //            cell.textLabel.text=@"History Details";
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HistoryDetailView"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row==1)
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"AdviceView"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"settingInfoResetAllTitle", @"") message:[NSString stringWithFormat:NSLocalizedString(@"settingInfoResetAllContent", @"")] delegate:self cancelButtonTitle:NSLocalizedString(@"settingInfoResetAllCancel", @"") otherButtonTitles:NSLocalizedString(@"settingInfoResetAllConfirm", @""), nil];
            [alert show];
        }
    }
//    else
//    {
//        if(indexPath.row==0)
//        {
////            cell.textLabel.text=[NSString stringWithFormat:@"Version: %f", Version];
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"VersionView"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else if(indexPath.row==1)
//        {
//            //            cell.textLabel.text=@"FAQ";
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"FAQView"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            //            cell.textLabel.text=@"Contact us";
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"ContactUsView"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }

}

-(void)back
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"RootView"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)searchDataSource
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:user];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil)
    {
        NSLog(@"error");
    }
    if([mutableFetchResult count]==0)
    {
        name=nil;
        sex=nil;
        age=nil;
    }
    else
    {
        for (User* user in mutableFetchResult)
        {
            name=user.name;
            sex=user.sex;
            birthday=user.birthday;
        }
        
        if(birthday!=nil)
        {
            // 出生日期转换 年月日
            NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:birthday];
            NSInteger brithDateYear  = [components1 year];
            NSInteger brithDateDay   = [components1 day];
            NSInteger brithDateMonth = [components1 month];
            
            // 获取系统当前 年月日
            NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
            NSInteger currentDateYear  = [components2 year];
            NSInteger currentDateDay   = [components2 day];
            NSInteger currentDateMonth = [components2 month];
            
            // 计算年龄
            NSInteger Age = currentDateYear - brithDateYear - 1;
            if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
                Age++;
            }
            age=[NSString stringWithFormat:@"%ld",(long)Age];
        }
        else
        {
            age=nil;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"111");
        [self removeDataHeart];
        [self removeDataUser];
        _myAppDelegate.ProgressGreenOrNot=-1;
    }
}

-(void)removeDataHeart
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* heartBeats=[NSEntityDescription entityForName:@"HeartBeatsInfo" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:heartBeats];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil)
    {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (HeartBeatsInfo* heartBeats in mutableFetchResult)
    {
        [_myAppDelegate.managedObjectContext deleteObject:heartBeats];
    }
    
    if ([_myAppDelegate.managedObjectContext save:&error])
    {
        
    }
}

-(void)removeDataUser
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:user];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil)
    {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (User* user in mutableFetchResult)
    {
        [_myAppDelegate.managedObjectContext deleteObject:user];
    }
    
    if ([_myAppDelegate.managedObjectContext save:&error])
    {
        
    }
}
@end
