//
//  DYFloatingHeaderView.h
//  DYFloatingHeaderView
//
//  Created by Derek Yang on 09/11/12.
//  Copyright (c) 2012 iappexperience.com. All rights reserved.
//
@interface DYFloatingHeaderView : UIView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView;

+ (float)height;

@end