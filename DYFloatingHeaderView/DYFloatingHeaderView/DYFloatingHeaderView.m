//
//  DYFloatingHeaderView.m
//  DYFloatingHeaderView
//
//  Created by Derek Yang on 09/11/12.
//  Copyright (c) 2012 iappexperience.com. All rights reserved.
//

#import "DYFloatingHeaderView.h"

@interface DYFloatingHeaderView ()

@property(nonatomic) CGFloat height;
@property(nonatomic) BOOL showingHeader;
@property(nonatomic) float lastScrollPosition;

- (void)showHeaderWithAnimation;

@end

@implementation DYFloatingHeaderView

@synthesize height = _height;
@synthesize showingHeader = _showingHeader;
@synthesize lastScrollPosition = _lastScrollPosition;

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.height = frame.size.height;
        self.lastScrollPosition = -self.height;

        // Update display so that the header view appears to be floating above the scrollView
        UIEdgeInsets originalInset = scrollView.contentInset;
        UIEdgeInsets updatedInset = UIEdgeInsetsMake([DYFloatingHeaderView height] + originalInset.top,
                        originalInset.left, originalInset.bottom, originalInset.right);
        scrollView.contentInset = updatedInset;
        scrollView.scrollIndicatorInsets = updatedInset;
        scrollView.delegate = self;
    }
    return self;
}

// Customize height of this header here
+ (float)height {
    return 40;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Move header along with its associated scrollView until header goes off screen
    CGFloat scrollViewOffset = scrollView.contentOffset.y - self.lastScrollPosition;
    if (scrollViewOffset > 0 && self.frame.origin.y > -self.height) {
        self.frame = CGRectMake(0, -scrollViewOffset, self.frame.size.width, self.frame.size.height);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Keep a note of the last y position. This will be used as a basis for showing/hiding/moving the header
    self.lastScrollPosition = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // If user releases finger after dragging and the scrollView starts to decelerate
    if (scrollView.contentOffset.y < self.lastScrollPosition &&
            self.frame.origin.y <= -self.height && !self.showingHeader) {
        // Detect if the scrollView is moving up (finger moves down), if yes, then show the header
        [self showHeaderWithAnimation];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.lastScrollPosition = scrollView.contentOffset.y;

    if (self.frame.origin.y > -self.height && !self.showingHeader) {
        // Scrolling has ended, but the header is not complete off from the top.
        // We should display the whole header again with an animation
        [self showHeaderWithAnimation];
    }
}

#pragma mark - Private

- (void)showHeaderWithAnimation {
    self.showingHeader = YES;
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
        if (finished) {
            self.showingHeader = NO;
        }
    }];
}

@end
