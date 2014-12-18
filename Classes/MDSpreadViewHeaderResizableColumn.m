//
//  MDSpreadViewHeaderResizableColumn.m
//  OtusTeacher
//
//  Created by Murilo on 12/17/14.
//  Copyright (c) 2014 Synvata. All rights reserved.
//

#import "MDSpreadViewHeaderResizableColumn.h"

@interface MDSpreadViewHeaderResizableColumn()

@property (strong, nonatomic) UIView *viewResize;
@property (strong, nonatomic) UIGestureRecognizer *resizeGesture;

@end

@implementation MDSpreadViewHeaderResizableColumn

- (id)initWithStyle:(MDSpreadViewHeaderCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewResize = [[UIView alloc] initWithFrame:[self getViewResizeFrame]];
        UIImage *imgResize = [[UIImage imageNamed:@"MDSpreadViewResize"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imgViewResize = [[UIImageView alloc] initWithImage:imgResize];
        [_viewResize addSubview:imgViewResize];
        [_viewResize setTintColor:[UIColor lightGrayColor]];
        [_viewResize setHidden:YES];
        [self addSubview:_viewResize];
        
        _resizeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onResizeGesture:)];
        [_viewResize addGestureRecognizer:_resizeGesture];
    }
    return self;
}

- (CGRect)getViewResizeFrame {
    CGFloat width = 24.0;
    CGFloat height = 24.0;
    CGFloat x = CGRectGetWidth(self.frame) - width;
    CGFloat y = (CGRectGetHeight(self.frame) / 2) - (height / 2);
    return CGRectMake(x, y, width, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.viewResize setFrame:[self getViewResizeFrame]];
}

- (void)onResizeGesture:(UITapGestureRecognizer *)gesture {
    
}

@end
