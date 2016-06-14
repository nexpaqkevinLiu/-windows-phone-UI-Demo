//
//  NPMetroContainerView.h
//  NPMetroUIDemo
//
//  Created by Jordan Zhou on 16/6/7.
//  Copyright © 2016年 kevin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NPMetroSubView;

@interface NPMetroContainerView : UIScrollView


+ (instancetype)containerViewWithLagreMagrin:(CGFloat)lagreMagrin andSmallMagrin:(CGFloat)smallMagrin andTopMagrin:(CGFloat)topMargin;

- (void)containerViewIncludeSubView:(NPMetroSubView *)subView;

- (void)containerViewIncludeSubViews:(NSArray *)subViews;

@end
