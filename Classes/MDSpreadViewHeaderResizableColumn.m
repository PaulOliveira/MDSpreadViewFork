//
//  MDSpreadViewHeaderResizableColumn.m
//  OtusTeacher
//
//  Created by Murilo on 12/17/14.
//  Copyright (c) 2014 Synvata. All rights reserved.
//

#import "MDSpreadViewHeaderResizableColumn.h"

@interface MDSpreadViewHeaderResizableColumn()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *viewResize;
@property (strong, nonatomic) UIPanGestureRecognizer *resizeGesture;
@property (strong, nonatomic) UIView *viewIndicator;

@end

@implementation MDSpreadViewHeaderResizableColumn

@dynamic _rowPath, _columnPath;

static CGFloat const ViewResizeHeight = 24.0;
static CGFloat const ViewResizeWidth = 9.5;
static CGFloat const ViewResizeRightMargin = 5.0;
static CGFloat const IndicatorViewWidth = 1.5;

- (id)initWithStyle:(MDSpreadViewHeaderCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewResize = [[UIView alloc] initWithFrame:[self getViewResizeFrame]];
        UIImage *imgResize = [[UIImage imageNamed:@"MDSpreadViewResize"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imgViewResize = [[UIImageView alloc] initWithImage:imgResize];
        [imgViewResize setBackgroundColor:[UIColor darkGrayColor]];
        [_viewResize addSubview:imgViewResize];
        [_viewResize setTintColor:[UIColor lightGrayColor]];
        [_viewResize setHidden:YES];
        [self addSubview:_viewResize];
        
        _resizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onResizeGesture:)];
        _resizeGesture.cancelsTouchesInView = YES;
        [_resizeGesture setDelegate:self];
        [_viewResize addGestureRecognizer:_resizeGesture];
    }
    return self;
}

#pragma mark - Layout

- (CGRect)getViewResizeFrame {
    CGFloat x = CGRectGetWidth(self.frame) - ViewResizeWidth - ViewResizeRightMargin;
    CGFloat y = (CGRectGetHeight(self.frame) / 2) - (ViewResizeHeight / 2);
    return CGRectMake(x, y, ViewResizeWidth, ViewResizeHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.viewResize setFrame:[self getViewResizeFrame]];
}

#pragma mark - Resize

- (CGRect)getViewIndicatorFrame {
    UIView *superView = [self superview];
    return CGRectMake(0, 0, IndicatorViewWidth, superView.frame.size.height);
}

- (UIView *)viewIndicator {
    if (_viewIndicator) {
        return _viewIndicator;
    }
    
    _viewIndicator = [[UIView alloc] initWithFrame:[self getViewIndicatorFrame]];
    [_viewIndicator setBackgroundColor:[UIColor colorWithRed:94.0/255 green:88.0/255 blue:200.0/255 alpha:1.0]];
    [_viewIndicator setHidden:YES];
    
    return _viewIndicator;
}

- (void)onResizeGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.superview];
    
    CGRect newFrame = self.viewIndicator.frame;
    newFrame.origin.x = point.x;
    
    if (newFrame.origin.x <= self.frame.origin.x + ((ViewResizeWidth + ViewResizeRightMargin) * 1.5)) {
        newFrame.origin.x = self.frame.origin.x + ((ViewResizeWidth + ViewResizeRightMargin) * 1.5);
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [[self superview] addSubview:self.viewIndicator];
        [self.viewIndicator setHidden:NO];
        [self.viewIndicator setFrame:newFrame];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.viewIndicator setHidden:NO];
        [self.viewIndicator setFrame:newFrame];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(spreadViewHeaderResizableColumn:didResizeWithWidth:)]) {
            CGFloat width = self.viewIndicator.frame.origin.x - self.frame.origin.x;
            [self.delegate spreadViewHeaderResizableColumn:self didResizeWithWidth:width];
        }
        [self.viewIndicator setHidden:YES];
        [self.viewIndicator removeFromSuperview];
    } else if (gesture.state == UIGestureRecognizerStateFailed) {
        [self.viewIndicator setHidden:YES];
        [self.viewIndicator removeFromSuperview];
    }
}

#pragma mark - Override methods

- (void)setSelected:(BOOL)isSelected animated:(BOOL)animated {
    [super setSelected:isSelected animated:animated];
    [self.viewResize setHidden:!self.selected];
}

@end
