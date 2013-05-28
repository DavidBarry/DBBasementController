//
//  DBBasementController.m
//  DBBasementController
//
//  Created by David Barry on 4/19/13.
//  Copyright (c) 2013 David Barry. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DBBasementController.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, DBBasementMenuAction) {
    DBBasementMenuOpen,
    DBBasementMenuClose
};

typedef struct {
    DBBasementMenuAction menuAction;
    BOOL shouldBounce;
    CGFloat velocity;
} DBBasementPanResultInfo;

@interface DBBasementController ()
@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentContainerView;
@property (strong, nonatomic) UIView *contentOverlayView;
@property (strong, nonatomic) UIView *menuObstructingView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

- (void)updateContentViewShadow;
- (void)applyContentOverlayView;
- (void)removeContentOverlayView;
- (void)applyViewToHideMenuDuringBounce;
- (void)removeViewToHideMenuDuringBounce;
@end

@implementation DBBasementController
@synthesize options = _options;

#pragma mark - Initializers
- (id)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController {
    return [self initWithMenuViewController:menuViewController contentViewController:contentViewController options:[DBBasementOptions new]];
}

- (id)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController options:(DBBasementOptions *)options {
    if (self = [super init]) {
        NSAssert(menuViewController != nil, @"You must provide a menuViewController when initializing DBBasementController.");
        NSAssert(contentViewController != nil, @"You must provide a contentViewController when initializing DBBasementController.");
        
        self.options = options;
        self.menuViewController = menuViewController;
        self.contentViewController = contentViewController;
    }
    
    return self;
}

#pragma mark - Appearance Methods
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.contentViewController beginAppearanceTransition:YES animated:animated];
    if ([self menuIsOpen]) [self.menuViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.contentViewController endAppearanceTransition];
    if ([self menuIsOpen]) [self.menuViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.contentViewController beginAppearanceTransition:NO animated:animated];
    if ([self menuIsOpen]) [self.menuViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.contentViewController endAppearanceTransition];
    if ([self menuIsOpen]) [self.menuViewController endAppearanceTransition];
}

#pragma mark - Menu Open/Close
- (void)openMenuAnimated:(BOOL)animated {
    NSTimeInterval duration = animated ? self.options.openCloseDuration : 0.0f;
    CGFloat openXOrigin = self.view.bounds.size.width - self.options.contentViewOverlapWidth;
    CGRect contentFrame = self.contentViewController.view.frame;
    contentFrame.origin.x = openXOrigin;
    
    void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
        [self.menuViewController endAppearanceTransition];
        [self menuDidOpen];
        [self applyContentOverlayView];
    };
    
    if (self.options.bounceOnOpenAndClose) {
        CGRect postBounceFrame = contentFrame;
        contentFrame.origin.x += self.options.openCloseBounceDistance;
        
        NSTimeInterval bounceDuration = animated ? self.options.openCloseBounceDuration : 0.0f;
        
        completionBlock = ^(BOOL finished) {
            [UIView animateWithDuration:bounceDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentContainerView.frame = postBounceFrame;
            } completion:completionBlock];
        };
    }
    
    self.menuViewController.view.transform = self.options.closedMenuTransform;
    
    [self.menuViewController beginAppearanceTransition:YES animated:animated];
    [self menuWillOpen];
    
    [UIView animateWithDuration:duration delay:0.0f options:self.options.openCloseAnimationOptions animations:^{
        self.contentContainerView.frame = contentFrame;
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        [self menuIsAnimatingOpen];
        
    } completion:completionBlock];
    
}

- (void)closeMenuAnimated:(BOOL)animated {
    [self closeMenuAnimated:animated completion:nil];
}

- (void)closeMenuAnimated:(BOOL)animated completion:(void (^)())closeCompletionBlock {
    if (![self menuIsOpen]) {
        if (closeCompletionBlock) closeCompletionBlock();
        return;
    };
    
    NSTimeInterval duration = animated ? self.options.openCloseDuration : 0.0f;
    CGRect contentFrame = self.view.bounds;
    
    void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
        [self.menuViewController endAppearanceTransition];
        [self menuDidClose];
        self.menuViewController.view.transform = CGAffineTransformIdentity;
        [self removeViewToHideMenuDuringBounce];
        if (closeCompletionBlock) closeCompletionBlock();
    };
    
    if (self.options.bounceOnOpenAndClose) {
        CGRect postBounceFrame = contentFrame;
        contentFrame.origin.x -= self.options.openCloseBounceDistance;
        
        NSTimeInterval bounceDuration = animated ? self.options.openCloseBounceDuration : 0.0f;
        
        completionBlock = ^(BOOL finished) {
            [UIView animateWithDuration:bounceDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentContainerView.frame = postBounceFrame;
            } completion:completionBlock];
        };
    }
    
    [self removeContentOverlayView];
    [self applyViewToHideMenuDuringBounce];
    
    [self.menuViewController beginAppearanceTransition:NO animated:animated];
    [self menuWillClose];
    
    [UIView animateWithDuration:duration delay:0.0f options:self.options.openCloseAnimationOptions animations:^{
        self.contentContainerView.frame = contentFrame;
        self.menuViewController.view.transform = self.options.closedMenuTransform;
        [self menuIsAnimatingClosed];
        
    } completion:completionBlock];
}

- (void)closeMenuAndChangeContentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self closeMenuAndChangeContentViewController:viewController animated:animated completion:nil];
}

- (void)closeMenuAndChangeContentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())closeCompletionBlock {
    UIViewController *oldContentViewController = self.contentViewController;
    //If the view controllers are the same we don't need to bother with appearance transition calls
    BOOL callAppearanceMethods = oldContentViewController != viewController;
    
    if (self.options.bounceWhenNavigating && animated && [self menuIsOpen]) {
        CGFloat offscreenDistance = 10.0f;
        CGRect offScreenFrame = self.contentContainerView.frame;
        offScreenFrame.origin.x = self.view.bounds.size.width + offscreenDistance;
        
        if (callAppearanceMethods) [oldContentViewController beginAppearanceTransition:NO animated:animated];
        
        [UIView animateWithDuration:self.options.navigationBounceDuration delay:0.0f options:self.options.navigationBounceAnimationOptions animations:^{
            self.contentContainerView.frame = offScreenFrame;
            
        } completion:^(BOOL finished) {
            if (callAppearanceMethods) [oldContentViewController endAppearanceTransition];
            self.contentViewController = viewController;
            if (callAppearanceMethods) [viewController beginAppearanceTransition:YES animated:animated];
            
            [self closeMenuAnimated:animated completion:^{
                if (callAppearanceMethods) [viewController endAppearanceTransition];
                if (closeCompletionBlock) closeCompletionBlock();
            }];
        }];
        
    } else {
        if (callAppearanceMethods) {
            [oldContentViewController beginAppearanceTransition:NO animated:NO];
            [oldContentViewController endAppearanceTransition];
        }
        self.contentViewController = viewController;
        if (callAppearanceMethods) [viewController beginAppearanceTransition:YES animated:animated];
        
        [self closeMenuAnimated:animated completion:^{
            if (callAppearanceMethods) [viewController endAppearanceTransition];
            if (closeCompletionBlock) closeCompletionBlock();
        }];
    }
}

- (void)toggleMenu {
    [self menuIsOpen] ? [self closeMenuAnimated:YES] : [self openMenuAnimated:YES];
}

- (BOOL)menuIsOpen {
    //If the x origin of the content view is 0 that means the menu is closed.
    return self.contentContainerView.frame.origin.x != 0.0f;
}

#pragma mark - Accessory Views
- (void)applyContentOverlayView {
    [self removeContentOverlayView];
    
    if (self.options.disableContentViewInteractionWhenMenuIsOpen) {
        self.contentOverlayView = [[UIView alloc] initWithFrame:self.contentContainerView.bounds];
        [self.contentOverlayView addGestureRecognizer:self.tapGesture];
        [self.contentOverlayView addGestureRecognizer:self.panGesture];
        
        [self.contentContainerView addSubview:self.contentOverlayView];
    }
    
    self.tapGesture.enabled = self.options.allowTapToDismiss;
}

- (void)removeContentOverlayView {
    [self.contentContainerView addGestureRecognizer:self.panGesture];
    [self.contentViewController.view addGestureRecognizer:self.tapGesture];
    self.tapGesture.enabled = NO;
    [self.contentOverlayView removeFromSuperview];
    self.contentOverlayView = nil;
}

// If bouncing is enabled when closing the menu we see a bit of the menu
// when the content view is bouncing closed. This can look bad, especially
// if there is a transform placed on the menu in it's closed state.
// This creates a simple view to cover up that overlap that is the same color
// as the basement background.
- (void)applyViewToHideMenuDuringBounce {
    if (self.options.bounceOnOpenAndClose && self.menuObstructingView ==  nil) {
        CGRect frame = self.view.bounds;
        frame.origin.x = self.contentContainerView.frame.size.width - self.options.contentCornerRadius;
        
        self.menuObstructingView = [[UIView alloc] initWithFrame:frame];
        self.menuObstructingView.backgroundColor = self.options.basementBackgroundColor;
        self.menuObstructingView.alpha = 1.0f;
        [self.contentContainerView insertSubview:self.menuObstructingView atIndex:0];
    }
}

- (void)removeViewToHideMenuDuringBounce {
    [self.menuObstructingView removeFromSuperview];
    self.menuObstructingView = nil;
}

- (void)updateContentViewShadow; {
    CALayer *layer = self.contentContainerView.layer;
    layer.shadowColor = [self.options.shadowColor CGColor];
    layer.shadowOpacity = self.options.shadowOpacity;
    layer.shadowRadius = self.options.shadowRadius;
    layer.shadowOffset = CGSizeMake(0.0f, (self.options.shadowRadius / 2.0f));
    
    CGRect shadowRect = self.contentContainerView.bounds;
    
    CGFloat cornerRadius = self.contentViewController.view.layer.cornerRadius;
    
    layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:cornerRadius] CGPath];
}

#pragma mark - Properties
// Return a copy here to prevent tampering with the options instance variables
- (DBBasementOptions *)options {
    return [_options copy];
}

- (void)setOptions:(DBBasementOptions *)options {
    _options = options;
    self.view.backgroundColor = _options.basementBackgroundColor;
    self.menuViewController.view.layer.cornerRadius = options.menuCornerRadius;
    self.contentViewController.view.layer.cornerRadius = options.contentCornerRadius;
    if (_contentContainerView) [self updateContentViewShadow];
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    if (_menuViewController != menuViewController) {
        [_menuViewController willMoveToParentViewController:nil];
        [_menuViewController.view removeFromSuperview];
        [_menuViewController removeFromParentViewController];
        
        _menuViewController = menuViewController;
        
        [self addChildViewController:_menuViewController];
        _menuViewController.view.frame = self.view.bounds;
        _menuViewController.view.layer.cornerRadius = self.options.menuCornerRadius;
        _menuViewController.view.layer.masksToBounds = YES;
        [self.view insertSubview:_menuViewController.view atIndex:0];
        [_menuViewController didMoveToParentViewController:self];
    }
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (_contentViewController != contentViewController) {
        CGRect frame = self.contentContainerView.bounds;
        
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController.view removeFromSuperview];
        [_contentViewController removeFromParentViewController];
        
        _contentViewController = contentViewController;
        
        [self addChildViewController:_contentViewController];
        _contentViewController.view.frame = frame;
        _contentViewController.view.layer.cornerRadius = self.options.contentCornerRadius;
        _contentViewController.view.layer.masksToBounds = YES;
        [self.contentContainerView addSubview:_contentViewController.view];
        [_contentViewController.view addGestureRecognizer:self.panGesture];
        [self updateContentViewShadow];
        [_contentViewController didMoveToParentViewController:self];
    }
}

- (UIView *)contentContainerView {
    if (_contentContainerView == nil) {
        _contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentContainerView.backgroundColor = [UIColor clearColor];
        _contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view addSubview:_contentContainerView];
    }
    
    return _contentContainerView;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.contentContainerView addGestureRecognizer:_panGesture];
    }
    
    return _panGesture;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        _tapGesture.enabled = NO;
    }
    
    return _tapGesture;
}

- (BOOL)panGestureEnabled {
    return self.panGesture.enabled;
}

- (void)setPanGestureEnabled:(BOOL)panGestureEnabled {
    self.panGesture.enabled = panGestureEnabled;
}

#pragma mark - Pan Gesture
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    static CGRect contentFrameAtStartOfPan;
    static BOOL menuWasOpenAtStartOfPan;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        contentFrameAtStartOfPan = self.contentContainerView.frame;
        menuWasOpenAtStartOfPan = [self menuIsOpen];
        
        if (menuWasOpenAtStartOfPan) {
            [self menuWillClose];
            [self.menuViewController beginAppearanceTransition:NO animated:YES];
        } else {
            [self menuWillOpen];
            [self.menuViewController beginAppearanceTransition:YES animated:YES];
        }
    }
    
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    self.contentContainerView.frame = [self applyTranslation:translation toFrame:contentFrameAtStartOfPan];
    self.menuViewController.view.transform = [self transformBetweenStartTransform:self.options.closedMenuTransform endTransform:CGAffineTransformIdentity distance:[self percentMenuIsOpenForContentOrigin:self.contentContainerView.frame.origin]];
    
    CGFloat percentOpen = self.contentContainerView.frame.origin.x / (self.view.bounds.size.width - self.options.contentViewOverlapWidth);
    percentOpen = fmin(fmax(0.0f, percentOpen), 1.0f);
    [self menuDidMove:percentOpen];
    
    CGPoint velocity = [panGesture velocityInView:panGesture.view];
    if (velocity.x < 0.0f && percentOpen <= 0.1) {
        [self applyViewToHideMenuDuringBounce];
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        void (^completionBlock)() = nil;
        
        DBBasementPanResultInfo panInfo = [self panResultInfoForVelocity:velocity];
        BOOL willOpen = panInfo.menuAction == DBBasementMenuOpen;
        if (willOpen) {
            if (menuWasOpenAtStartOfPan) {
                [self menuWillOpen];
                [self.menuViewController beginAppearanceTransition:YES animated:YES];
            }
            
            completionBlock = ^{
                [self.menuViewController endAppearanceTransition];
                [self menuDidOpen];
                [self removeViewToHideMenuDuringBounce];
                
            };
        } else {
            if (!menuWasOpenAtStartOfPan) {
                [self menuWillClose];
                [self.menuViewController beginAppearanceTransition:NO animated:YES];
            }
            
            [self applyViewToHideMenuDuringBounce];
            completionBlock = ^{
                [self.menuViewController endAppearanceTransition];
                [self menuDidClose];
                [self removeViewToHideMenuDuringBounce];
            };
        }
        
        [self finishOpenOrCloseWithPanInfo:panInfo completion:completionBlock];
    }

}

- (CGRect)applyTranslation:(CGPoint)translation toFrame:(CGRect)frame {
    CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;

    CGFloat minOrigin = 0.0f;
    CGFloat maxOrigin = self.view.bounds.size.width - self.options.contentViewOverlapWidth;
    CGRect newFrame = frame;
    
    if (newOrigin < minOrigin) {
        if (self.options.bounceOnOpenAndClose) {
            CGFloat adjustedXTranslation = newOrigin - minOrigin;
            newOrigin = minOrigin + (adjustedXTranslation * 0.1);
        } else {
            newOrigin = minOrigin;
        }
        
    } else if (newOrigin > maxOrigin) {
        if (self.options.bounceOnOpenAndClose) {
            CGFloat adjustedXTranslation = newOrigin - maxOrigin;
            newOrigin = maxOrigin + (adjustedXTranslation * 0.1);
        } else {
            newOrigin = maxOrigin;
        }
    }

    newFrame.origin.x = newOrigin;
    return newFrame;
}

- (DBBasementPanResultInfo)panResultInfoForVelocity:(CGPoint)velocity {
    static CGFloat thresholdVelocity = 450.0f;
    CGFloat pointOfNoReturn = floorf((self.view.bounds.size.width - self.options.contentViewOverlapWidth) / 2.0f);
    CGFloat contentOrigin = self.contentContainerView.frame.origin.x;
    
    DBBasementPanResultInfo panInfo = { 0, NO, 0.0f };
    
    //It will default to opening or closing based on the point of no return, which divies the screen in half.
    panInfo.menuAction = contentOrigin <= pointOfNoReturn ? DBBasementMenuClose : DBBasementMenuOpen;
    
    //If the velocity is past the threshold open/closed based on the swipe direction.
    if (velocity.x >= thresholdVelocity) {
        panInfo.menuAction = DBBasementMenuOpen;
        panInfo.velocity = velocity.x;
    } else if (velocity.x <= (-1.0f * thresholdVelocity)) {
        panInfo.menuAction = DBBasementMenuClose;
        panInfo.velocity = velocity.x;
    }
    
    CGFloat bouncePointOfNoReturn = 2.0f * self.options.openCloseBounceDistance;
    panInfo.shouldBounce = contentOrigin > bouncePointOfNoReturn;
    if (panInfo.menuAction == DBBasementMenuOpen) {
        bouncePointOfNoReturn = (self.view.bounds.size.width - (self.options.contentViewOverlapWidth + bouncePointOfNoReturn));
        panInfo.shouldBounce = contentOrigin < bouncePointOfNoReturn;
    }
    
    panInfo.shouldBounce = panInfo.shouldBounce && self.options.bounceOnOpenAndClose;
    
    return panInfo;
}

- (void)finishOpenOrCloseWithPanInfo:(DBBasementPanResultInfo)panInfo completion:(void(^)())completion {
    CGFloat contentXOrigin = self.contentContainerView.frame.origin.x;
    CGRect finalFrame = self.view.bounds;
    CGAffineTransform finalMenuTransform = self.options.closedMenuTransform;
    
    void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
        completion();
    };
    
    if (panInfo.menuAction == DBBasementMenuOpen) {
        finalFrame.origin.x = finalFrame.size.width - self.options.contentViewOverlapWidth;
        finalMenuTransform = CGAffineTransformIdentity;
        [self applyContentOverlayView];
    } else {
        [self removeContentOverlayView];
    }
    
    if (panInfo.shouldBounce) {
        CGFloat bounceDistance = self.options.openCloseBounceDistance;
        if (panInfo.menuAction == DBBasementMenuClose) bounceDistance *= -1.0f;
        
        CGRect originalEndFrame = finalFrame;
        finalFrame.origin.x += bounceDistance;
        
        completionBlock = ^(BOOL finished) {
            [UIView animateWithDuration:self.options.openCloseBounceDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.contentContainerView.frame = originalEndFrame;
            } completion:completionBlock];
        };
    }
    
    NSTimeInterval duration;
    if (panInfo.velocity == 0.0f) {
        duration = self.options.openCloseDuration;
    } else {
        duration = fabsf((finalFrame.origin.x - contentXOrigin) / panInfo.velocity);
        duration = fmax(0.1, fmin(1.0f, duration));
    }
    
    [UIView animateWithDuration:duration delay:0.0f options:self.options.openCloseAnimationOptions animations:^{
        self.contentContainerView.frame = finalFrame;
        self.menuViewController.view.transform = finalMenuTransform;
        panInfo.menuAction == DBBasementMenuOpen ? [self menuIsAnimatingOpen] : [self menuIsAnimatingClosed];
    } completion:completionBlock];
}

- (CGFloat)percentMenuIsOpenForContentOrigin:(CGPoint)origin {
    CGFloat totalWidth = self.view.bounds.size.width - self.options.contentViewOverlapWidth;
    CGFloat currentWidth = origin.x;
    CGFloat rawPercentage = currentWidth / totalWidth;
    CGFloat percentage = fmin(fmax(0.0f, rawPercentage), 1.0);
    return percentage;
}

- (CGAffineTransform)transformBetweenStartTransform:(CGAffineTransform)startTransform endTransform:(CGAffineTransform)endTransform distance:(CGFloat)distance {
    CGAffineTransform newTransform = startTransform;
    newTransform.a += (endTransform.a - startTransform.a) * distance;
    newTransform.b += (endTransform.b - startTransform.b) * distance;
    newTransform.c += (endTransform.c - startTransform.c) * distance;
    newTransform.d += (endTransform.d - startTransform.d) * distance;
    newTransform.tx += (endTransform.tx - startTransform.tx) * distance;
    newTransform.ty += (endTransform.ty - startTransform.ty) * distance;
    
    
    return newTransform;
}

#pragma mark - DBBasementControllerCallbacks
// DBBasementController adopts DBBasementControllerCallbacks to make it easy to pass all calls to the menu and content view controllers
- (void)menuWillOpen {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuWillOpen)]) [contentViewController menuWillOpen];
    if ([self.menuViewController respondsToSelector:@selector(menuWillOpen)]) [self.menuViewController menuWillOpen];
}

- (void)menuDidOpen {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuDidOpen)]) [contentViewController menuDidOpen];
    if ([self.menuViewController respondsToSelector:@selector(menuDidOpen)]) [self.menuViewController menuDidOpen];
}

- (void)menuWillClose {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuWillClose)]) [contentViewController menuWillClose];
    if ([self.menuViewController respondsToSelector:@selector(menuWillClose)]) [self.menuViewController menuWillClose];
}

- (void)menuDidClose {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuDidClose)]) [contentViewController menuDidClose];
    if ([self.menuViewController respondsToSelector:@selector(menuDidClose)]) [self.menuViewController menuDidClose];
}

- (void)menuIsAnimatingOpen {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuIsAnimatingOpen)]) [contentViewController menuIsAnimatingOpen];
    if ([self.menuViewController respondsToSelector:@selector(menuIsAnimatingOpen)]) [self.menuViewController menuIsAnimatingOpen];
}

- (void)menuIsAnimatingClosed {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuIsAnimatingClosed)]) [contentViewController menuIsAnimatingClosed];
    if ([self.menuViewController respondsToSelector:@selector(menuIsAnimatingClosed)]) [self.menuViewController menuIsAnimatingClosed];
}

- (void)menuDidMove:(CGFloat)percentOpen {
    UIViewController *contentViewController = [self actualContentViewController];
    if ([contentViewController respondsToSelector:@selector(menuDidMove:)]) [contentViewController menuDidMove:percentOpen];
    if ([self.menuViewController respondsToSelector:@selector(menuDidMove:)]) [self.menuViewController menuDidMove:percentOpen];
}

// Check for various container view controller types and return what is likely
// the actual relevant content view controller embedded in the container VC
- (UIViewController *)actualContentViewController {
    UIViewController *contentViewController = self.contentViewController;
    if ([contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)contentViewController;
        contentViewController = navigationController.topViewController;
    } else if ([contentViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)contentViewController;
        contentViewController = tabBarController.selectedViewController;
    }
    
    return contentViewController;
}

#pragma mark - UIViewController Containment
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotate {
    return [self.menuViewController shouldAutorotate] && [self.contentViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.menuViewController supportedInterfaceOrientations] & [self.contentViewController supportedInterfaceOrientations];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ([self menuIsOpen]) {
        CGFloat contentXOrigin = self.view.bounds.size.width - self.options.contentViewOverlapWidth;
        CGRect contentFrame = self.contentContainerView.frame;
        contentFrame.origin.x = contentXOrigin;
        self.contentContainerView.frame = contentFrame;
    }
}

@end

@implementation UIViewController (DBBasementController)

- (DBBasementController *)basementController {
    UIViewController *viewController = self;
    
    while (viewController) {
        if ([viewController isKindOfClass:[DBBasementController class]])
            return (DBBasementController *)viewController;
        
        viewController = viewController.parentViewController;
    }
    
    return nil;
}
@end
