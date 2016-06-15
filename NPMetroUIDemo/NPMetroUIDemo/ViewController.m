//
//  ViewController.m
//  NPMetroUIDemo
//
//  Created by Jordan Zhou on 16/6/7.
//  Copyright © 2016年 kevin.liu. All rights reserved.
//

#import "ViewController.h"
#import "NPMetroContainerView.h"
#import "NPMetroSubView.h"

@interface ViewController ()

@property (nonatomic, strong) NPMetroContainerView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.containerView.frame = self.view.bounds;
    
    self.containerView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.containerView];
    
    NPMetroSubView *subView_0 = [NPMetroSubView metroSubViewWithType:1 andPosition:0];
    
    subView_0.ID = 0;
    subView_0.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
    NPMetroSubView *subView_1 = [NPMetroSubView metroSubViewWithType:1 andPosition:2];
    
    subView_1.ID = 1;
    subView_1.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
    NPMetroSubView *subView_2 = [NPMetroSubView metroSubViewWithType:0 andPosition:4];
    
    subView_2.ID = 2;
    subView_2.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
    NPMetroSubView *subView_3 = [NPMetroSubView metroSubViewWithType:0 andPosition:5];
    
    subView_3.ID = 3;
    subView_3.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
    NPMetroSubView *subView_4 = [NPMetroSubView metroSubViewWithType:0 andPosition:11];
    
    subView_4.ID = 4;
    subView_4.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
    NPMetroSubView *subView_5 = [NPMetroSubView metroSubViewWithType:2 andPosition:12];
    
    subView_5.ID = 5;
    subView_5.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
    NPMetroSubView *subView_6 = [NPMetroSubView metroSubViewWithType:3 andPosition:24];
    subView_6.ID = 6;
    subView_6.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue: arc4random_uniform(255) / 255.0 alpha:1];
    
   
    [self.containerView  containerViewIncludeSubViews:@[subView_0,subView_1,subView_2,subView_3,subView_4,subView_5,subView_6]];
    
}





- (NPMetroContainerView *)containerView{

    if (_containerView == nil) {
        
        _containerView = [NPMetroContainerView containerViewWithLagreMagrin:6 andSmallMagrin:6 andTopMagrin:20];
    }

    return _containerView;
}

@end
