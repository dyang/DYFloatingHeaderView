//
//  DYFloatingHeaderView.m
//  DYFloatingHeaderView
//
//  Created by Derek Yang on 09/11/12.
//  Copyright (c) 2012 iappexperience.com. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
* Neither the name of the author nor the names of its contributors may be used
to endorse or promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DYFloatingHeaderView.h"

@interface DYFloatingHeaderView ()

@property(nonatomic) CGFloat height;
@property(nonatomic) BOOL showingHeader;
@property(nonatomic) float lastScrollPosition;

- (void)showHeaderWithAnimation;

@end

@implementation DYFloatingHeaderView {
    BOOL _isBeingDragged;
}

@synthesize height = _height;
@synthesize showingHeader = _showingHeader;
@synthesize lastScrollPosition = _lastScrollPosition;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:245.0/255.0 alpha:0.9];
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    self.height = self.frame.size.height;
    self.lastScrollPosition = -self.height;
}

#pragma mark - Public interface

// Customize height of this header here
+ (float)height {
    return 40;
}

// Update display so that the header view appears to be floating above the scrollView.
- (void)updateScrollViewInsets:(UIScrollView *)scrollView {
    UIEdgeInsets originalInset = scrollView.contentInset;
    UIEdgeInsets updatedInset = UIEdgeInsetsMake([DYFloatingHeaderView height] + originalInset.top,
            originalInset.left, originalInset.bottom, originalInset.right);
    scrollView.contentInset = updatedInset;
    scrollView.scrollIndicatorInsets = updatedInset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Move header along with its associated scrollView until header goes off screen
    CGFloat scrollViewOffset = scrollView.contentOffset.y - self.lastScrollPosition;
    if (scrollView.contentOffset.y <= 0.0 && CGRectGetMaxY(self.frame) != self.frame.size.height && !_isBeingDragged) {
        //Or if we are at the very top (header should always be visible)
        CGFloat yOffset = (scrollView.contentOffset.y > -self.frame.size.height)?-(scrollView.contentOffset.y + self.frame.size.height):0.0;
        self.frame = CGRectMake(0, yOffset, self.frame.size.width, self.frame.size.height);
    } else if (scrollViewOffset > 0 && self.frame.origin.y > -self.height) {
        _isBeingDragged = YES;
        self.frame = CGRectMake(0, -scrollViewOffset, self.frame.size.width, self.frame.size.height);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Keep a note of the last y position. This will be used as a basis for showing/hiding/moving the header
    self.lastScrollPosition = scrollView.contentOffset.y;
    _isBeingDragged = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isBeingDragged = NO;
    //We want to animate the header to full visibility if the user pulled it and stopped half way and it is not decelerating
    // Detect if the scrollView is moving down (finger moves up) and if the header is still visible
    if (!decelerate && scrollView.contentOffset.y > self.lastScrollPosition && CGRectGetMaxY(self.frame) > 0.0 && !self.showingHeader) {
        [self showHeaderWithAnimation];
    }
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
