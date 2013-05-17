//
//  DBAnimationDetailsViewController.m
//  DBBasementExample
//
//  Created by David Barry on 4/28/13.
//  Copyright (c) 2013 David Barry. All rights reserved.
//

#import "DBAnimationDetailsViewController.h"
#import "DBBasementController.h"
#import "DBAppearanceManager.h"

@interface DBAnimationDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *openCloseLabel;
@property (strong, nonatomic) IBOutlet UISlider *openCloseSlider;
@property (strong, nonatomic) IBOutlet UILabel *openCloseBounceLabel;
@property (strong, nonatomic) IBOutlet UISlider *openCloseBounceSlider;
@property (strong, nonatomic) IBOutlet UILabel *openCloseBounceDistanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *openCloseBounceDistanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *navigationBounceDurationLabel;
@property (strong, nonatomic) IBOutlet UISlider *navigationBounceDurationSlider;
@property (strong, nonatomic) IBOutlet UILabel *contentViewOverlapLabel;
@property (strong, nonatomic) IBOutlet UISlider *contentViewOverlapSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *transformSegmentedControl;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)segmentedControlValueChanged:(id)sender;
@end

@implementation DBAnimationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.basementController action:@selector(toggleMenu)];
    self.title = @"Animation";
    
    [self displayCurrentOptions];
    self.view.backgroundColor = [DBAppearanceManager contentBackgroundColor];
}

- (void)menuWillClose {
    [self displayCurrentOptions];
}

- (void)displayCurrentOptions {
    DBBasementOptions *options = self.basementController.options;
    
    CGFloat value = options.openCloseDuration;
    self.openCloseLabel.text = [NSString stringWithFormat:@"%.2f", value];
    self.openCloseSlider.value = value;
    
    value = options.openCloseBounceDuration;
    self.openCloseBounceLabel.text = [NSString stringWithFormat:@"%.2f", value];
    self.openCloseBounceSlider.value = value;
    
    value = ceil(options.openCloseBounceDistance);
    self.openCloseBounceDistanceLabel.text = [NSString stringWithFormat:@"%.0f", value];
    self.openCloseBounceDistanceSlider.value = value;
    
    value = options.navigationBounceDuration;
    self.navigationBounceDurationLabel.text = [NSString stringWithFormat:@"%.2f", value];
    self.navigationBounceDurationSlider.value = value;
    
    value = ceil(options.contentViewOverlapWidth);
    self.contentViewOverlapLabel.text = [NSString stringWithFormat:@"%.0f", value];
    self.contentViewOverlapSlider.value = value;
    
    self.transformSegmentedControl.selectedSegmentIndex = [self indexForTransform:options.closedMenuTransform];
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *slider = sender;
    DBBasementOptions *options = self.basementController.options;
    CGFloat value = slider.value;
    
    //When a slider is active disable panning in the basement controller
    self.basementController.panGestureEnabled = !slider.tracking;

    if (slider == self.openCloseSlider) {
        value = value;
        self.openCloseLabel.text = [NSString stringWithFormat:@"%.2f", value];
        self.openCloseSlider.value = value;
        if (!slider.tracking && value != options.openCloseDuration) {
            options.openCloseDuration = value;
            self.basementController.options = options;
        }
        
    } else if (sender == self.openCloseBounceSlider) {
        value = value;
        self.openCloseBounceLabel.text = [NSString stringWithFormat:@"%.2f", value];
        self.openCloseBounceSlider.value = value;
        if (!slider.tracking && value != options.openCloseBounceDuration) {
            options.openCloseBounceDuration = value;
            self.basementController.options = options;
        }
        
    } else if (sender == self.openCloseBounceDistanceSlider) {
        value = ceil(value);
        self.openCloseBounceDistanceLabel.text = [NSString stringWithFormat:@"%.0f", value];
        self.openCloseBounceDistanceSlider.value = value;
        if (!slider.tracking && value != options.openCloseBounceDistance) {
            options.openCloseBounceDistance = value;
            self.basementController.options = options;
        }
        
    } else if (sender == self.navigationBounceDurationSlider) {
        value = value;
        self.navigationBounceDurationLabel.text = [NSString stringWithFormat:@"%.2f", value];
        self.navigationBounceDurationSlider.value = value;
        if (!slider.tracking && value != options.navigationBounceDuration) {
            options.navigationBounceDuration = value;
            self.basementController.options = options;
        }
    
    } else if (sender == self.contentViewOverlapSlider) {
        value = ceil(value);
        self.contentViewOverlapLabel.text = [NSString stringWithFormat:@"%.0f", value];
        self.contentViewOverlapSlider.value = value;
        if (!slider.tracking && value != options.contentViewOverlapWidth) {
            options.contentViewOverlapWidth = value;
            self.basementController.options = options;
        }
    }
}

- (IBAction)segmentedControlValueChanged:(id)sender {
    DBBasementOptions *options = self.basementController.options;
    options.closedMenuTransform = [self transformForSegmentIndex:self.transformSegmentedControl.selectedSegmentIndex];
    self.basementController.options = options;
}

- (CGAffineTransform)transformForSegmentIndex:(NSInteger)index {
    if (index == 0) {
        return CGAffineTransformIdentity;
    } else if (index == 1) {
        return CGAffineTransformMakeScale(0.8, 0.8);
    } else if (index == 2) {
        return CGAffineTransformMakeTranslation(100.0f, 0.0f);
    }
    
    return CGAffineTransformIdentity;
}

- (NSInteger)indexForTransform:(CGAffineTransform)transform {
    if (CGAffineTransformEqualToTransform(transform, CGAffineTransformIdentity)) {
        return 0;
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeScale(0.8, 0.8))) {
        return 1;
    } else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeTranslation(100.0f, 0.0f))) {
        return 2;
    }
    
    return 0;
}
@end
