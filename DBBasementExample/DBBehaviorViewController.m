//
//  DBBehaviorViewController.m
//  DBBasementExample
//
//  Created by David Barry on 4/28/13.
//  Copyright (c) 2013 David Barry. All rights reserved.
//

#import "DBBehaviorViewController.h"
#import "DBBasementController.h"
#import "DBAppearanceManager.h"

@interface DBBehaviorViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *bounceWhenNavigatingSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *bounceOpenCloseSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *tapToDismissSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *disableInteractionSwitch;

- (IBAction)switchChanged:(id)sender;
@end

@implementation DBBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.basementController action:@selector(toggleMenu)];
    self.title = @"Behavior";
    [self displayCurrentOptions];
    self.view.backgroundColor = [DBAppearanceManager contentBackgroundColor];
}

- (void)menuWillClose {
    [self displayCurrentOptions];
}

- (void)displayCurrentOptions {
    DBBasementOptions *options = self.basementController.options;
    [self.bounceWhenNavigatingSwitch setOn:options.bounceWhenNavigating];
    [self.bounceOpenCloseSwitch setOn:options.bounceOnOpenAndClose];
    [self.tapToDismissSwitch setOn:options.allowTapToDismiss];
    [self.disableInteractionSwitch setOn:options.disableContentViewInteractionWhenMenuIsOpen];
}

- (IBAction)switchChanged:(id)sender {
    DBBasementOptions *options = self.basementController.options;
    if (sender == self.bounceWhenNavigatingSwitch) {
        options.bounceWhenNavigating = [self.bounceWhenNavigatingSwitch isOn];
    } else if (sender == self.bounceOpenCloseSwitch) {
        options.bounceOnOpenAndClose = [self.bounceOpenCloseSwitch isOn];
    } else if (sender == self.tapToDismissSwitch) {
        options.allowTapToDismiss = [self.tapToDismissSwitch isOn];
    } else if (sender == self.disableInteractionSwitch) {
        options.disableContentViewInteractionWhenMenuIsOpen = [self.disableInteractionSwitch isOn];
    }

    self.basementController.options = options;
}
@end
