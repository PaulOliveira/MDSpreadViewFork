//
//  MDSpreadViewHeaderResizableColumn.m
//  OtusTeacher
//
//  Created by Murilo on 12/17/14.
//  Copyright (c) 2014 Synvata. All rights reserved.
//

#import "MDSpreadViewResizableHeaderCell.h"

@interface MDSpreadViewResizableHeaderCell()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *viewResize;
@property (strong, nonatomic) UIImageView *imgViewResize;
@property (strong, nonatomic) UIPanGestureRecognizer *resizeGesture;
@property (strong, nonatomic) UIView *viewIndicator;
@property (nonatomic) MDSpreadViewHeaderCellStyle headerCellStyle;

@end

@implementation MDSpreadViewResizableHeaderCell

@dynamic _rowPath, _columnPath;

static CGFloat const ViewResizeHeight = 36.0;
static CGFloat const ViewResizeWidth = 20.0;
static CGFloat const IndicatorViewWidth = 1.5;

- (id)initWithStyle:(MDSpreadViewHeaderCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headerCellStyle = style;
        
        _viewResize = [[UIView alloc] initWithFrame:[self getViewResizeFrame]];
        UIImage *imgResize = [[UIImage imageNamed:@"MDSpreadViewResize"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _imgViewResize = [[UIImageView alloc] initWithImage:imgResize];
        [_imgViewResize setBackgroundColor:[UIColor darkGrayColor]];
        if (style == MDSpreadViewHeaderCellStyleColumn) {
            [_imgViewResize setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90.0))];
        }
        [_imgViewResize setFrame:[self getImgViewResizeFrame]];
        [_viewResize addSubview:_imgViewResize];
        
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
    CGRect frame;
    if (self.headerCellStyle == MDSpreadViewHeaderCellStyleColumn) {
        CGFloat x = (CGRectGetWidth(self.frame) / 2) - (ViewResizeHeight / 2);
        CGFloat y = CGRectGetHeight(self.frame) - ViewResizeWidth;
        frame = CGRectMake(x, y, ViewResizeHeight, ViewResizeWidth);
    } else {
        CGFloat x = CGRectGetWidth(self.frame) - ViewResizeWidth;
        CGFloat y = (CGRectGetHeight(self.frame) / 2) - (ViewResizeHeight / 2);
        frame = CGRectMake(x, y, ViewResizeWidth, ViewResizeHeight);
    }
    return frame;
}

- (CGRect)getImgViewResizeFrame {
    CGRect frame;
    CGFloat imgViewHeight = CGRectGetHeight(self.imgViewResize.frame);
    CGFloat imgViewWidth = CGRectGetWidth(self.imgViewResize.frame);
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (self.headerCellStyle == MDSpreadViewHeaderCellStyleColumn) {
        x = (CGRectGetWidth(self.viewResize.frame) / 2) - (imgViewWidth / 2);
        y = CGRectGetHeight(self.viewResize.frame) - imgViewHeight - 2.0;
    } else {
        x = (CGRectGetWidth(self.viewResize.frame) / 2) - (imgViewWidth / 2);
        y = (CGRectGetHeight(self.viewResize.frame) / 2) - (imgViewHeight / 2);
    }
    frame = CGRectMake(x, y, imgViewWidth, imgViewHeight);
    
    return frame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.viewResize setFrame:[self getViewResizeFrame]];
}

#pragma mark - Resize

- (CGRect)getViewIndicatorFrame {
    UIView *superView = [self superview];
    CGRect frame;
    if (self.headerCellStyle == MDSpreadViewHeaderCellStyleColumn) {
        frame = CGRectMake(0, 0, superView.frame.size.width, IndicatorViewWidth);
    } else {
        frame = CGRectMake(0, 0, IndicatorViewWidth, superView.frame.size.height);
    }
    return frame;
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
    
    if (self.headerCellStyle == MDSpreadViewHeaderCellStyleColumn) {
        newFrame.origin.y = point.y;
        if (newFrame.origin.y <= (self.frame.origin.y + ViewResizeWidth)) {
            newFrame.origin.y = self.frame.origin.y + ViewResizeWidth;
        }
    } else {
        newFrame.origin.x = point.x;
        if (newFrame.origin.x <= (self.frame.origin.x + (ViewResizeWidth * 1.5))) {
            newFrame.origin.x = self.frame.origin.x + (ViewResizeWidth * 1.5);
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [[self superview] addSubview:self.viewIndicator];
        [self.viewIndicator setHidden:NO];
        [self.viewIndicator setFrame:newFrame];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.viewIndicator setHidden:NO];
        [self.viewIndicator setFrame:newFrame];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(spreadViewResizableHeaderCell:didResizeWithValue:andStyle:)]) {
            CGFloat value;
            if (self.headerCellStyle == MDSpreadViewHeaderCellStyleColumn) {
                value = self.viewIndicator.frame.origin.y - self.frame.origin.y;
            } else {
                value = self.viewIndicator.frame.origin.x - self.frame.origin.x;
            }
            [self.delegate spreadViewResizableHeaderCell:self didResizeWithValue:value andStyle:self.headerCellStyle];
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
