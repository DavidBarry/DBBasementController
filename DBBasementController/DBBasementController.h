//
//  DBBasementController.h
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

#import <UIKit/UIKit.h>
#import "DBBasementOptions.h"

@interface DBBasementController : UIViewController
@property (strong, nonatomic, readonly) UIViewController *menuViewController;
@property (strong, nonatomic, readonly) UIViewController *contentViewController;
@property (copy, nonatomic) DBBasementOptions *options;
@property (assign, nonatomic) BOOL panGestureEnabled;

- (id)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController;
- (id)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController options:(DBBasementOptions *)options;

- (void)openMenuAnimated:(BOOL)animated;
- (void)closeMenuAnimated:(BOOL)animated;
- (void)closeMenuAndChangeContentViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)toggleMenu;

- (BOOL)menuIsOpen;
@end

@protocol DBBasementControllerCallbacks <NSObject>
@optional
- (void)menuWillOpen;
- (void)menuDidOpen;
- (void)menuWillClose;
- (void)menuDidClose;

- (void)menuIsAnimatingOpen;
- (void)menuIsAnimatingClosed;

// This is called as the menu is dragged, percentOpen will be between 0 and 1
- (void)menuDidMove:(CGFloat)percentOpen;

@end

@interface UIViewController (DBBasementController) <DBBasementControllerCallbacks>
- (DBBasementController *)basementController;
@end
