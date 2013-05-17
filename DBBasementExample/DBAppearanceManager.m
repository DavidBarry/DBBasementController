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
//
//  Created by David Barry on 4/30/13.
//  Copyright (c) 2013 David Barry. All rights reserved.
//

#import "DBAppearanceManager.h"

@interface DBAppearanceManager ()
+ (void)applySliderAppearance;
+ (void)applySegmentedControlAppearance;
+ (void)applyNavigationAppearance;

@end

@implementation DBAppearanceManager

+ (void)applyAppearance {
    [self applySliderAppearance];
    [self applySegmentedControlAppearance];
    [self applyNavigationAppearance];
}

+ (void)applySliderAppearance {
    UIEdgeInsets trackInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    
    UIImage *minimumTrackImage = [UIImage imageNamed:@"slider-track-blue"];
    minimumTrackImage = [minimumTrackImage resizableImageWithCapInsets:trackInsets];
    [[UISlider appearance] setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
    
    UIImage *maximumTrackImage = [UIImage imageNamed:@"slider-track-white"];
    maximumTrackImage = [maximumTrackImage resizableImageWithCapInsets:trackInsets];
    [[UISlider appearance] setMaximumTrackImage:maximumTrackImage forState:UIControlStateNormal];
    
    UIImage *thumbImage = [UIImage imageNamed:@"slider-thumb"];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];
    
}

+ (void)applySegmentedControlAppearance {
    UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(15.0f, 12.0, 15.0f, 12.0f);
    
    UIImage *unselectedBackground = [UIImage imageNamed:@"segment-unselected-bg"];
    unselectedBackground = [unselectedBackground resizableImageWithCapInsets:backgroundInsets];
    [[UISegmentedControl appearance] setBackgroundImage:unselectedBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *selectedBackground = [UIImage imageNamed:@"segment-selected-bg"];
    selectedBackground = [selectedBackground resizableImageWithCapInsets:backgroundInsets];
    [[UISegmentedControl appearance] setBackgroundImage:selectedBackground forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    UIImage *separatorBlueToWhite = [UIImage imageNamed:@"separator-blue-to-white"];
    [[UISegmentedControl appearance] setDividerImage:separatorBlueToWhite forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *separatorWhiteToWhite = [UIImage imageNamed:@"separator-white-to-white"];
    [[UISegmentedControl appearance] setDividerImage:separatorWhiteToWhite forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *separatorWhiteToBlue = [UIImage imageNamed:@"separator-white-to-blue"];
    [[UISegmentedControl appearance] setDividerImage:separatorWhiteToBlue forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[self textAttributesForFontSize:12.0f] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:[self selectedTextAttributesForFontSize:12.0f] forState:UIControlStateSelected];
    
}

+ (void)applyNavigationAppearance {
    UIImage *navigationBarImage = [UIImage imageNamed:@"navigation-bar"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[self selectedTextAttributesForFontSize:20.0f]];
    
    
    UIEdgeInsets barButtonInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    UIImage *barButton = [UIImage imageNamed:@"bar-button"];
    barButton = [barButton resizableImageWithCapInsets:barButtonInsets];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *barButtonHighlighted = [UIImage imageNamed:@"bar-button-highlighted"];
    barButtonHighlighted = [barButtonHighlighted resizableImageWithCapInsets:barButtonInsets];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonHighlighted forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[self selectedTextAttributesForFontSize:12.0f] forState:UIControlStateNormal];
}

+ (NSDictionary *)textAttributesForFontSize:(CGFloat)size {
    NSDictionary *textAttribute = @{
                                    UITextAttributeFont : [self avenirHeavyOfSize:size],
                                    UITextAttributeTextColor : [UIColor darkGrayColor],
                                    UITextAttributeTextShadowColor : [UIColor whiteColor],
                                    UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]
                                    };
    return textAttribute;
}

+ (NSDictionary *)selectedTextAttributesForFontSize:(CGFloat)size {
    NSDictionary *textAttribute = @{
                                    UITextAttributeFont : [self avenirHeavyOfSize:size],
                                    UITextAttributeTextColor : [UIColor whiteColor],
                                    UITextAttributeTextShadowColor : [UIColor darkGrayColor],
                                    UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, -1.0f)]
                                    };
    return textAttribute;
}

+ (UIFont *)avenirHeavyOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Heavy" size:size];
}

+ (UIColor *)contentBackgroundColor {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"content-bg"]];
}
@end
