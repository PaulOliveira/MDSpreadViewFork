//
//  MDSpreadViewHeaderResizableColumn.h
//  OtusTeacher
//
//  Created by Murilo on 12/17/14.
//  Copyright (c) 2014 Synvata. All rights reserved.
//

#import "MDSpreadViewHeaderCell.h"

@class MDSpreadViewHeaderResizableColumn;

@protocol MDSpreadViewHeaderResizableColumnDelegate <NSObject>

- (void)spreadViewHeaderResizableColumn:(MDSpreadViewHeaderResizableColumn *)spreadViewHeaderResizableColumn didResizeWithWidth:(CGFloat)width;

@end

@interface MDSpreadViewHeaderResizableColumn : MDSpreadViewHeaderCell

@property (strong, nonatomic, readonly) MDIndexPath *_rowPath;
@property (strong, nonatomic, readonly) MDIndexPath *_columnPath;

@property (weak, nonatomic) id<MDSpreadViewHeaderResizableColumnDelegate> delegate;

@end
