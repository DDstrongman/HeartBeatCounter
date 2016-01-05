//
//  HistoryDetailViewController.m
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import "HistoryDetailViewController.h"

@interface HistoryDetailViewController ()

{
    NSMutableArray *plottingHeart;
    NSMutableArray *plottingTime;
    NSString  *detailHeartRate;
    NSString  *detailTimeStamp;
}

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editButtonItem.title=NSLocalizedString(@"editTitle", @"");
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title              = NSLocalizedString(@"historyviewTitle", @"");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backTitle", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    plottingHeart =[[NSMutableArray alloc]init];
    plottingTime  =[[NSMutableArray alloc]init];
    [self searchData];
    
    
    // Create manager
    //
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    // ================= Deletable & Movable =================
    //
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@""];
    [_manager addSection:section];
    
    for (NSInteger i = 0; i < [plottingHeart count]; i++)
    {
        
        RETableViewItem *item = [RETableViewItem itemWithTitle:[NSString stringWithFormat:NSLocalizedString(@"historyDetailHeartRateIcon", @""), [plottingTime objectAtIndex:i],[plottingHeart objectAtIndex:i]] accessoryType:UITableViewCellAccessoryNone selectionHandler:nil];
        item.editingStyle = UITableViewCellEditingStyleDelete;
        item.deletionHandler = ^(RETableViewItem *item)
        {
            NSLog(@"Item removed: %@",[item.title substringWithRange:NSMakeRange(0, 19)]);
            [self removeData:[item.title substringWithRange:NSMakeRange(0, 19)]];
        };
        item.moveHandler = ^BOOL(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath)
        {
            return YES;
        };
        item.moveCompletionHandler = ^(RETableViewItem *item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) {
            NSLog(@"Moved item: %@ from [%i,%i] to [%i,%i]", item.title, sourceIndexPath.section, sourceIndexPath.row, destinationIndexPath.section, destinationIndexPath.row);
        };
        [section addItem:item];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [plottingTime  addObject:heartBeats.time];
    }
}

-(void)removeData:(NSString *)TimeStamp
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* heartBeats=[NSEntityDescription entityForName:@"HeartBeatsInfo" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:heartBeats];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"time==%@", TimeStamp];
    [request setPredicate:predicate];
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

-(void)back
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
