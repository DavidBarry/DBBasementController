//
//  DBBasementOptions.m
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

#import "DBBasementOptions.h"

@implementation DBBasementOptions

- (id)init {
    if (self = [super init]) {
        self.openCloseDuration = 0.3f;
        self.openCloseAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        self.openCloseBounceDuration = 0.2f;
        self.openCloseBounceDistance = 10.0f;
        
        self.navigationBounceDuration = 0.2f;
        self.navigationBounceAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
        
        self.closedMenuTransform = CGAffineTransformIdentity;
        self.openMenuContentTransform = CGAffineTransformIdentity;
        self.contentViewOverlapWidth = 40.0f;
        
        self.bounceWhenNavigating = YES;
        self.bounceOnOpenAndClose = YES;
        self.allowTapToDismiss = YES;
        self.disableContentViewInteractionWhenMenuIsOpen = YES;
        
        self.basementBackgroundColor = [UIColor blackColor];
        self.menuCornerRadius = 4.0f;
        self.contentCornerRadius = 4.0f;
        self.shadowColor = [UIColor blackColor];
        self.shadowOpacity = 1.0f;
        self.shadowRadius = 6.0f;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DBBasementOptions *options = [DBBasementOptions new];
    
    options.openCloseDuration = self.openCloseDuration;
    options.openCloseAnimationOptions = self.openCloseAnimationOptions;
    options.openCloseBounceDuration = self.openCloseBounceDuration;
    options.openCloseBounceDistance = self.openCloseBounceDistance;
    
    options.navigationBounceDuration = self.navigationBounceDuration;
    options.navigationBounceAnimationOptions = self.navigationBounceAnimationOptions;
    
    options.closedMenuTransform = self.closedMenuTransform;
    options.openMenuContentTransform = self.openMenuContentTransform;
    options.contentViewOverlapWidth = self.contentViewOverlapWidth;
    
    options.bounceWhenNavigating = self.bounceWhenNavigating;
    options.bounceOnOpenAndClose = self.bounceOnOpenAndClose;
    options.allowTapToDismiss = self.allowTapToDismiss;
    options.disableContentViewInteractionWhenMenuIsOpen = self.disableContentViewInteractionWhenMenuIsOpen;
    
    options.basementBackgroundColor = self.basementBackgroundColor;
    options.menuCornerRadius = self.menuCornerRadius;
    options.contentCornerRadius = self.contentCornerRadius;
    options.shadowColor = self.shadowColor;
    options.shadowOpacity = self.shadowOpacity;
    options.shadowRadius = self.shadowRadius;
    
    return options;
}

@end
