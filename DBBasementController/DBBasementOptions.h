//
//  DBBasementOptions.h
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

#import <Foundation/Foundation.h>

@interface DBBasementOptions : NSObject <NSCopying>
#pragma mark - Animation Details
@property (assign, nonatomic) NSTimeInterval openCloseDuration;
@property (assign, nonatomic) UIViewAnimationOptions openCloseAnimationOptions;
@property (assign, nonatomic) NSTimeInterval openCloseBounceDuration;
@property (assign, nonatomic) CGFloat openCloseBounceDistance;

@property (assign, nonatomic) NSTimeInterval navigationBounceDuration;
@property (assign, nonatomic) UIViewAnimationOptions navigationBounceAnimationOptions;

@property (assign, nonatomic) CGAffineTransform closedMenuTransform;
@property (assign, nonatomic) CGAffineTransform openMenuContentTransform;
@property (assign, nonatomic) CGFloat contentViewOverlapWidth;

#pragma mark - Enable/Disable Behaviors
@property (assign, nonatomic) BOOL bounceWhenNavigating;
@property (assign, nonatomic) BOOL bounceOnOpenAndClose;
@property (assign, nonatomic) BOOL allowTapToDismiss;
@property (assign, nonatomic) BOOL disableContentViewInteractionWhenMenuIsOpen;

#pragma mark - Appearance
@property (strong, nonatomic) UIColor *basementBackgroundColor;
@property (assign, nonatomic) CGFloat menuCornerRadius;
@property (assign, nonatomic) CGFloat contentCornerRadius;
@property (strong, nonatomic) UIColor *shadowColor;
@property (assign, nonatomic) CGFloat shadowOpacity;
@property (assign, nonatomic) CGFloat shadowRadius;
@end
