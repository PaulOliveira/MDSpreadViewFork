//
//  MDSpreadViewHeaderResizableColumn.h
//  OtusTeacher
//
//  Created by Murilo on 12/17/14.
//  Copyright (c) 2014 Synvata. All rights reserved.
//

#import "MDSpreadViewHeaderCell.h"

@class MDSpreadViewResizableHeaderCell;

@protocol MDSpreadViewResizableHeaderDelegate <NSObject>

- (void)spreadViewResizableHeaderCell:(MDSpreadViewResizableHeaderCell *)spreadViewResizableHeaderCell didResizeWithValue:(CGFloat)value andStyle:(MDSpreadViewHeaderCellStyle)headerCellStyle;

@end

@interface MDSpreadViewResizableHeaderCell : MDSpreadViewHeaderCell

@property (strong, nonatomic, readonly) MDIndexPath *_rowPath;
@property (strong, nonatomic, readonly) MDIndexPath *_columnPath;

@property (weak, nonatomic) id<MDSpreadViewResizableHeaderDelegate> delegate;

@end
