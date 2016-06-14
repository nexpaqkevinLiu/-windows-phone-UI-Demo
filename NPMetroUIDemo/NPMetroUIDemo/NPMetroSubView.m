//
//  NPMetroSubView.m
//  NPMetroUIDemo
//
//  Created by Jordan Zhou on 16/6/7.
//  Copyright © 2016年 kevin.liu. All rights reserved.
//

#import "NPMetroSubView.h"
#import "UIView+setFrame.h"

@interface NPMetroSubView ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL allowMove;

@end

@implementation NPMetroSubView

- (instancetype)initWithType:(NSInteger)type andPosition:(NSInteger)position{

    if (self = [super init]) {
        
        self.label = [[UILabel alloc] init];
        
        [self addSubview:self.label];
        
        self.type = type;
        
        self.position = position;
        
        self.label.text = [NSString stringWithFormat:@"%zd",self.position];
        
        [self setUpGestureRecognizer];
    }
  
    return self;
}

+ (instancetype)metroSubViewWithType:(NSInteger)type andPosition:(NSInteger)position{

    return [[self alloc] initWithType:type andPosition:position];
}


- (void)setUpGestureRecognizer{

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self addGestureRecognizer:longPressGestureRecognizer];

}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.label.frame = self.bounds;
    
    self.label.textAlignment = NSTextAlignmentCenter;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        self.allowMove = YES;
        
        NSLog(@"can move");
    
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.oldPosition = self.position;
    
    [self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    if (!self.allowMove) return;

    UITouch *touch = [touches anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:self.superview];
    
    CGPoint currentLocation = [touch locationInView:self.superview];
    
    CGFloat offsetXC = currentLocation.x - previousLocation.x;
    
    CGFloat offsetYC = currentLocation.y - previousLocation.y;
    
    self.x += offsetXC;
    
    self.y += offsetYC;
    
    if (self.x < 0 ) {
        
        self.x = 0;
   
    }else if(self.x > self.superview.width - self.width){
    
        self.x = self.superview.width - self.width;
    
    }else if(self.y < 0){
    
        self.y = 0;
    
    }
    
    self.movingBlock(self);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.allowMove = NO;
    
    self.movingEndedBlock(self);
}



#pragma mark - setter && getter

- (void)setPosition:(NSInteger)position{

    _position = position;
    
    self.label.text = [NSString stringWithFormat:@"%zd",position];
    
    [self.positions removeAllObjects];
    
    [self.Fpositions removeAllObjects];
    
    [self.Spositions removeAllObjects];
    
    if (self.type == 0) {
        
        [self.positions addObject:@(position)];
        
        [self.Fpositions addObject:@(position)];
        
        [self.Spositions addObject:@(position)];
        
    }else{
    
        for (int i = 0; i < self.type * 2; ++i) {
            
            [self.positions addObject:@(position + i)];
            
            [self.Fpositions addObject:@(position + i)];
            
            [self.positions addObject:@(position + i + 6)];
            
            [self.Spositions addObject:@(position + i + 6)];
        }
    }
}

- (NSMutableArray *)positions{

    if (_positions == nil) {
        
        _positions = [NSMutableArray array];
    }
    
    return _positions;
}

- (NSMutableArray *)Fpositions{

    if (_Fpositions == nil) {
        
        _Fpositions = [NSMutableArray array];
    }
  
    return _Fpositions;
}

- (NSMutableArray *)Spositions{

    if (_Spositions == nil) {
        
        _Spositions = [NSMutableArray array];
    }

    return _Spositions;
}



@end
