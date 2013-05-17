//
//  DBMenuViewController.m
//  DBBasementExample
//
//  Created by David Barry on 4/20/13.
//  Copyright (c) 2013 David Barry. All rights reserved.
//

#import "DBMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DBBasementController.h"
#import "DBBehaviorViewController.h"
#import "DBAnimationDetailsViewController.h"

typedef NS_ENUM(NSInteger, DBMenuRow) {
    DBMenuRowAnimation = 0,
    DBMenuRowBehavior,
    DBMenuRowRestoreDefaults,
    DBMenuRowNumberOfRows
};

@interface DBMenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation DBMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DBMenuRowNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CellID";
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-cell-bg"]];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:20.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    NSString *cellText = nil;
    if (indexPath.row == DBMenuRowAnimation) {
        cellText = @"Animation";
    } else if (indexPath.row == DBMenuRowBehavior) {
        cellText = @"Behavior";
    } else if (indexPath.row == DBMenuRowRestoreDefaults) {
        cellText = @"Restore Defaults";
    }
    cell.textLabel.text = cellText;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *contentViewController = nil;
    
    if (indexPath.row == DBMenuRowAnimation) {
        contentViewController = [DBAnimationDetailsViewController new];
    } else if (indexPath.row == DBMenuRowBehavior) {
        contentViewController = [DBBehaviorViewController new];
    } else if (indexPath.row == DBMenuRowRestoreDefaults) {
        self.basementController.options = [DBBasementOptions new];
    }
    
    if (contentViewController) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
        [self.basementController closeMenuAndChangeContentViewController:navController animated:YES];
    } else {
        [self.basementController closeMenuAnimated:YES];
    }

}
@end
