//
//  NPMetroContainerView.m
//  NPMetroUIDemo
//
//  Created by Jordan Zhou on 16/6/7.
//  Copyright © 2016年 kevin.liu. All rights reserved.
//

#import "NPMetroContainerView.h"
#import "NPMetroSubView.h"
#import "UIView+setFrame.h"

@interface NPMetroContainerView ()

@property (nonatomic, assign) CGFloat lagreMagrin;

@property (nonatomic, assign) CGFloat smallMagrin;

@property (nonatomic, assign) CGFloat topMagrin;

@property (nonatomic, assign) CGFloat unitWidth;

@property (nonatomic, assign) CGFloat unitHeight;

@property (nonatomic, assign) CGFloat unitHorWidth;

@property (nonatomic, assign) CGFloat unitVorWidth;

//所有子view
@property (nonatomic, strong) NSMutableArray *subViews;
//当前激活的view
@property (nonatomic, strong) NPMetroSubView *activeView;
//按子view位子大小排列的数组
@property (nonatomic, strong) NSMutableArray *asortPositons;

//监听子view的移动事件
@property (nonatomic, copy) void (^movingBlock)(NPMetroSubView *);
//监听子view的松手事件
@property (nonatomic, copy) void (^movingEndedBlock)(NPMetroSubView *);

@end

@implementation NPMetroContainerView

#pragma mark - 构造方法

- (instancetype)initWithLagreMagrin:(CGFloat)lagreMagrin andSmallMagrin:(CGFloat)smallMagrin andTopMagrin:(CGFloat)topMagrin{

    if (self = [super init]) {
        
        self.lagreMagrin = lagreMagrin;
        
        self.smallMagrin = smallMagrin;
        
        self.topMagrin = topMagrin;
        
        [self monitorSubViewsMovingEvent];
    }

    return self;
}

+ (instancetype)containerViewWithLagreMagrin:(CGFloat)lagreMagrin andSmallMagrin:(CGFloat)smallMagrin andTopMagrin:(CGFloat)topMargin{

    return [[self alloc] initWithLagreMagrin:lagreMagrin andSmallMagrin:smallMagrin andTopMagrin:topMargin];
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];

    self.unitWidth = (self.width - 7 * self.lagreMagrin) / 6;
    
    self.unitHeight = self.unitWidth;
    
    self.unitHorWidth = (self.width - 4 * self.lagreMagrin) / 6;
    
    self.unitVorWidth = self.unitHorWidth;
}

#pragma mark - 主要方法

- (void)containerViewIncludeSubView:(NPMetroSubView *)subView{

    [self addSubview:subView];
    
    [self.subViews addObject:subView];
    
    [self setUpContentSize];
    
}

- (void)containerViewIncludeSubViews:(NSArray *)subViews{

    for (NPMetroSubView *subView in subViews) {
        
        [self containerViewIncludeSubView:subView];
    }
}

- (void)setUpContentSize{
    
    self.asortPositons = [NSMutableArray arrayWithArray:self.subViews];

    for (int i = 0; i < self.asortPositons.count; ++i) {
        
        for (int j = i + 1; j < self.asortPositons.count; ++j) {
            
            NPMetroSubView *subView_0 = self.asortPositons[i];
            
            NPMetroSubView *subView_1 = self.asortPositons[j];
            
            if (subView_0.positions.lastObject > subView_1.positions.lastObject) {
                
                [self.asortPositons replaceObjectAtIndex:i withObject:subView_1];
                
                [self .asortPositons replaceObjectAtIndex:j withObject:subView_0];
            }
        }
    }
    
    NPMetroSubView *lastView = self.asortPositons.lastObject;
    
    CGFloat contentHeight = CGRectGetMaxY(lastView.frame) + self.topMagrin;
    
    self.contentSize = CGSizeMake(self.superview.frame.size.width, contentHeight);
    
    
}


//监听子view移动事件
- (void)monitorSubViewsMovingEvent{
    
    __weak typeof(self) weakSelf = self;

    self.movingBlock = ^(NPMetroSubView *view){
        
        NSInteger hor = (view.x - self.lagreMagrin + (self.lagreMagrin + self.unitWidth) * 0.5) / (self.lagreMagrin + self.unitWidth);
        
        NSInteger ver = (view.y - self.topMagrin + (self.lagreMagrin + self.unitHeight) * 0.5) / (self.lagreMagrin + self.unitHeight);
        
        NSInteger position = hor + ver * 6;
    
        NSInteger oldHor = view.oldPosition % 6;
        
        NSInteger oldVer = view.oldPosition / 6;
            
        view.position = position;
      
        if (oldHor != hor && ver == oldVer) {//view变成activeView
            
            view.oldPosition = position;
            
            [weakSelf subViewPushLeftOrRight:view];
            
            [weakSelf actionGravityWithActiveView:view];
        
        }else if(oldHor == hor && ver < oldVer){
        
            view.oldPosition = position;
            
            [weakSelf subViewPushUp:view];
        
        }else if(oldHor == hor && ver > oldVer){
        
           view.oldPosition = position;
        
            [weakSelf subViewPushDown:view];
            
            [weakSelf actionGravityWithActiveView:view];
        }
    };
    
    self.movingEndedBlock = ^(NPMetroSubView *view){
        
        NSInteger unitDistance = [weakSelf actionGravityDistaceWithGravityView:view];
        
        view.position -= unitDistance * 6;
    
        [weakSelf makeSubViewGoToItLocation:view];
        
        [weakSelf actionGravityWithActiveView:view];
        
        [weakSelf setUpContentSize];
    };
}

//左右运动
- (void)subViewPushLeftOrRight:(NPMetroSubView *)view{
    
    self.activeView = view;
    
    NSMutableArray *pushViews = [NSMutableArray array];

    for (NPMetroSubView *subView in self.subViews) {
        
        for (NSNumber *position in view.positions) {
            
            for (NSNumber *subPosition in subView.positions) {
                
                if (position.integerValue == subPosition.integerValue && subView != view) {//获得passtiveView
                    
                    if (![self subViewisExistInPushViews:pushViews andSubView:subView]) {
                        
                        [pushViews addObject:subView];
                    }
                  
                }
            }
        }
    }
    
    if (pushViews.count > 1) {
        
        NPMetroSubView *fri = pushViews.firstObject;
        
        NPMetroSubView *las = pushViews.lastObject;
        
        if (fri.position < las.position) {
            
            NSInteger unitDistance =  (view.type == 0? 1 : 2 ) + view.position / 6 - fri.position / 6;
            
            [self passtiveViewMoveDownWithUnitDistance:unitDistance andPasstiveView:fri];
            
            return;
        
        }else{
            
            
            NSInteger unitDistance =  (view.type == 0? 1 : 2 ) + view.position / 6 - las.position / 6;
            
            [self passtiveViewMoveDownWithUnitDistance:unitDistance andPasstiveView:las];
            
            return;
        
        }
    
    }else if(pushViews.count == 1){
        
        NPMetroSubView *fri = pushViews.firstObject;
    
        NSInteger unitDistance =  (view.type == 0? 1 : 2 ) + view.position / 6 - fri.position / 6;
        
        [self passtiveViewMoveDownWithUnitDistance:unitDistance andPasstiveView:fri];
        
        return;
    }
}

//向上运动

- (void)subViewPushUp:(NPMetroSubView *)view{
  
    self.activeView = view;
    
    NSMutableArray *pushViews = [NSMutableArray array];
    
    for (NPMetroSubView *subView in self.subViews) {
        
        for (NSNumber *position in view.positions) {
            
            for (NSNumber *subPosition in subView.positions) {
                
                if (position.integerValue == subPosition.integerValue && subView != view) {//获得passtiveView
                    
                    if (![self subViewisExistInPushViews:pushViews andSubView:subView]) {
                        
                        [pushViews addObject:subView];
                    }
                }
            }
        }
    }
    
    for (NPMetroSubView *pushView in pushViews) {
        
        NSInteger unitDistance = view.type == 0 ? 2 : 3;
        
        [self passtiveViewMoveDownWithUnitDistance:unitDistance andPasstiveView:pushView];
        
    }
}

- (void)subViewPushDown:(NPMetroSubView *)view{

    self.activeView = view;
    
    NSMutableArray *pushViews = [NSMutableArray array];
    
    for (NPMetroSubView *subView in self.subViews) {
        
        for (NSNumber *position in view.positions) {
            
            for (NSNumber *subPosition in subView.positions) {
                
                if (position.integerValue == subPosition.integerValue && subView != view) {//获得passtiveView
                    
                    if (![self subViewisExistInPushViews:pushViews andSubView:subView]) {
                        
                        [pushViews addObject:subView];
                    }
                }
            }
        }
    }
    
    [self makeSubViewGoToItLocation:view];
    
    for (NPMetroSubView *subView in pushViews) {
        
        if (subView.type == 0) {
            
            subView.position -= view.type == 0 ? 6 : 12;
            
            [self makeSubViewGoToItLocation:subView];
        
        }else {
        
            if ([self ifSubViewCanMoveUp:subView andActiveView:view]) {
                
                subView.position -= view.type == 0 ? 12 : 18;
                
                [self makeSubViewGoToItLocation:subView];
           
            }else{
            
                [self passtiveViewMoveDownWithUnitDistance:1 andPasstiveView:subView];
            
            }
        
        }
        
        
    }

}

- (void)passtiveViewMoveDownWithUnitDistance:(NSInteger)UnitDistance andPasstiveView:(NPMetroSubView *)passtiveView{

    if (passtiveView.type == 0) {
        
        for (int i = 1; i <= UnitDistance; ++i) {
            
            for (NPMetroSubView *subView in self.subViews) {
                
                for (NSNumber *position in subView.Fpositions) {
                    
                    if (position.integerValue == passtiveView.position + 6 * i && subView != passtiveView && subView != self.activeView) {
                        
                        [self passtiveViewMoveDownWithUnitDistance:UnitDistance - (subView.position / 6 - passtiveView.position / 6) + 1 andPasstiveView:subView];
                        
                        passtiveView.position += 6 * UnitDistance;
                        
                        [self makeSubViewGoToItLocation:passtiveView];
                        
                        return;
                        
                    }
                    
                }
            }
            
        
        }
        
        passtiveView.position += 6 * UnitDistance;
        
        [self makeSubViewGoToItLocation:passtiveView];
    
    }else{
        
        NSMutableArray *newPositions = [NSMutableArray array];
        
        NSMutableArray *pushViews = [NSMutableArray array];
        
        BOOL startPush = NO;
        
        for (int i = 1; i <= UnitDistance; ++i) {
            
            for (int j = 0; j < passtiveView.type * 2; ++j) {
                
                [newPositions addObject:@(passtiveView.position + 6 * (i + 1) + j)];
            }
            
            for (NPMetroSubView *subView in self.subViews) {
                
                for (NSNumber *position in subView.positions) {
                    
                    for (NSNumber *newPosition in newPositions) {
                        
                        if (newPosition.integerValue == position.integerValue && subView != passtiveView && subView != self.activeView) {
                            
                            startPush = YES;
                            
                            if (![self subViewisExistInPushViews:pushViews andSubView:subView]) {
                                
                                [pushViews addObject:subView];
                            }
                        }
                    }
                }
            }
            
            if (startPush) {
                
                for (NPMetroSubView *pushView in pushViews) {
                    
                    [self passtiveViewMoveDownWithUnitDistance:UnitDistance - ((pushView.position / 6 - passtiveView.position / 6)) + 2 andPasstiveView:pushView];
                }
                
                passtiveView.position +=  6 * UnitDistance;
                
                [self makeSubViewGoToItLocation:passtiveView];
                
                return;
                
            }
        }
        
        passtiveView.position +=  6 * UnitDistance;
        
        [self makeSubViewGoToItLocation:passtiveView];
    }
}

- (void)actionGravityWithActiveView:(NPMetroSubView *)view{

    NSMutableArray *gravityViews = [NSMutableArray array];
    
    for (NPMetroSubView *subView in self.subViews) {
        
        if (subView.position / 6 > view.position / 6) {
            
            if (![self subViewisExistInPushViews:gravityViews andSubView:subView]) {
                
                [gravityViews addObject:subView];
            }
        }
    }

    if (gravityViews.count != 0) {
        
        for (NPMetroSubView *gravityView in gravityViews) {
            
            NSInteger unitDistance = [self actionGravityDistaceWithGravityView:gravityView];
            
            gravityView.position -= unitDistance * 6;
            
            [self makeSubViewGoToItLocation:gravityView];
            
            [self actionGravityWithActiveView:gravityView];
        }
    }
}

- (NSInteger)actionGravityDistaceWithGravityView:(NPMetroSubView *)view{

    NSInteger index = view.type == 0 ? 1 : view.type * 2;
    
    for (NSInteger i = (view.position / 6) - 1;i >= 0;--i) {
        
        for (int j = 0; j < index; ++j) {
            
            NSInteger Hor = (view.position % 6) + j;
            
            for (NPMetroSubView *subView in self.subViews) {
                
                for (NSNumber *position in subView.positions) {
                    
                    if ((position.integerValue / 6 == i) && (position.integerValue % 6 == Hor) && subView != view) {
                        
                        return (view.position / 6) - i  - 1;
                    }
                }
            }
        }
        
    }
    
    return (view.position / 6) ;
}



#pragma mark - Other Method

- (void)makeSubViewGoToItLocation:(NPMetroSubView *)view{

    NSInteger hor = view.position % 6;
   
    NSInteger ver = view.position / 6;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        view.x = self.lagreMagrin + (self.lagreMagrin + self.unitWidth) * hor;
       
        view.y = self.topMagrin + (self.lagreMagrin + self.unitHeight) * ver;
    }];
}

- (BOOL)subViewisExistInPushViews:(NSMutableArray *)pushViews andSubView:(NPMetroSubView *)subView{

    BOOL isExist = NO;
    
    for (NPMetroSubView *view in pushViews) {
        
        if (view == subView) {
            
            isExist = YES;
            
            return isExist;
        }
    }

    return isExist;
}

- (BOOL)ifSubViewCanMoveUp:(NPMetroSubView *)view andActiveView:(NPMetroSubView *)activeView{

    NSMutableArray *newPositions = [NSMutableArray array];
    
    NSInteger index = activeView.type == 0 ? 12 : 18;
    
    if (view.position - index >= 0) {
        
        for (int i = 0; i < view.type * 2; ++i) {
            
            [newPositions addObject:@(view.position + i - index)];
            
            [newPositions addObject:@(view.position + 6 + i - index)];
        }
        
        for (NPMetroSubView *subView in self.subViews) {
            
            for (NSNumber *position in subView.positions) {
                
                for (NSNumber *newPosition in newPositions) {
                    
                    if (position.integerValue == newPosition.integerValue) {
                        
                        return NO;
                    }
                }
            }
       
        }
        
    }else{
    
        return NO;
    
    }
    
    return YES;
}

#pragma mark - override Method

- (void)addSubview:(UIView *)view{

    [super addSubview:view];
    
    if ([view isKindOfClass:[NPMetroSubView class]]) {
        
        NPMetroSubView *metroView = (NPMetroSubView *)view;
        
        if (metroView.position == -1) {
            
            NPMetroSubView *lastView = self.asortPositons.lastObject;
            
            NSInteger lastPosition = [lastView.positions.lastObject integerValue];
            
            if ((5 - lastPosition % 6) >= metroView.type * 2 ) {
                
                metroView.position = lastPosition + 1;
            
            }else{
            
                metroView.position = (lastPosition / 6 + 1) * 6;
            }
        }
        
        NSInteger unitDistance = [self actionGravityDistaceWithGravityView:metroView];
        
        metroView.position -= 6 * unitDistance;
        
        [self subViewFrameWithView:metroView];
        
        metroView.movingEndedBlock = self.movingEndedBlock;
        
        metroView.movingBlock = self.movingBlock;
    }
}

#pragma mark - other Method

- (void)subViewFrameWithView:(NPMetroSubView *)view{
    
    NSInteger hor = view.position % 6;
    NSInteger ver = view.position / 6;

    switch (view.type) {
        case 0:
            view.x = self.lagreMagrin + (self.lagreMagrin + self.unitWidth) * hor;
            view.y = self.topMagrin + (self.lagreMagrin + self.unitHeight) * ver;
            view.width = self.unitWidth;
            view.height = self.unitHeight;
            break;
        default:
            view.x = self.lagreMagrin + (self.lagreMagrin + self.unitWidth) * hor;
            view.y = self.topMagrin + (self.lagreMagrin + self.unitHeight) * ver;
            view.width = self.unitHorWidth * view.type * 2 + self.lagreMagrin * (view.type - 1);
            view.height = self.unitVorWidth* 2;
            break;
    }
}

#pragma  mark - setter && getter

- (NSMutableArray *)subViews{

    if (_subViews == nil) {
        
        _subViews = [NSMutableArray array];
    }

    return _subViews;
}


@end
