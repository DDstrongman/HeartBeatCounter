//
//  UserInfoViewController.m
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()
{
    NSString *textvalue;
    NSString *radiovalue;
    NSDate   *datevalue;
    UIButton *leftButton;
}

@property (strong, readwrite, nonatomic) RETextItem *textItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *dateTimeItem;
@property (strong, readwrite, nonatomic) RERadioItem *radioItem;

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title=NSLocalizedString(@"userInfoTitle", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    

    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    self.userInfoSection = [self addUserInfo];
}

#pragma mark -
#pragma mark UserInfo

- (RETableViewSection *)addUserInfo
{
    __typeof (&*self) __weak weakSelf = self;
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@""];
    [_manager addSection:section];
    
    // Add items to this section
    //
    
    if([self searchDataSource])
    {
        textvalue=nil;
        radiovalue=NSLocalizedString(@"GenderRadioMale", @"");
        datevalue=[NSDate date];
    }
    
    self.textItem = [RETextItem itemWithTitle:NSLocalizedString(@"userNameCell", @"") value:textvalue placeholder:NSLocalizedString(@"userNameRemindCell", @"")];
    self.dateTimeItem = [REDateTimeItem itemWithTitle:NSLocalizedString(@"BirthdayCell", @"") value:datevalue placeholder:nil format:@"yyyy/MM/dd" datePickerMode:UIDatePickerModeDate];
    
    
    self.radioItem = [RERadioItem itemWithTitle:NSLocalizedString(@"GenderCell", @"") value:radiovalue selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        // Generate sample options
        //
        NSMutableArray *options = [[NSMutableArray alloc] init];
        [options addObject:NSLocalizedString(@"GenderRadioMale", @"")];
        [options addObject:NSLocalizedString(@"GenderRadioFemale", @"")];
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        // Adjust styles
        //
        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        // Push the options controller
        //
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    
    [section addItem:self.textItem];
    [section addItem:self.dateTimeItem];
    [section addItem:self.radioItem];
    
    return section;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    NSLog(@"textItem.value = %@", self.textItem.value);
    NSLog(@"dateTimeItem = %@", self.dateTimeItem.value);
    NSLog(@"radioItem.value = %@", self.radioItem.value);
    
    NSDate *  senddate=self.dateTimeItem.value;
    
    [self addIntoDataSource:senddate Sex:self.radioItem.value Name:self.textItem.value];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addIntoDataSource:(NSDate *)birthday Sex:(NSString *)sex Name:(NSString *)name
{
    if ([self searchDataSource])
    {
        User* user=(User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    
        [user setBirthday:birthday];
        [user setName:name];
        [user setSex:sex];
        NSError* error;
        BOOL isSaveSuccess=[_myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
        }else{
            NSLog(@"Save successful!");
        }
    }
    else
    {
        [self updateDataSource:birthday Sex:sex Name:name];
    }
}

-(BOOL)searchDataSource
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
        return YES;
    }
    else
    {
        for (User* user in mutableFetchResult)
        {
            textvalue=user.name;
            radiovalue=user.sex;
            datevalue=user.birthday;
        }
        return NO;
    }
}

-(void)updateDataSource:(NSDate *)birthday Sex:(NSString *)sex Name:(NSString *)name
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
    //更新age后要进行保存，否则没更新
    for (User* user in mutableFetchResult)
    {
        [user setBirthday:birthday];
        [user setSex:sex];
        [user setName:name];
    }
    [_myAppDelegate.managedObjectContext save:&error];
}


@end
