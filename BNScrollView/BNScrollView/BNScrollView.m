//
//  BNScrollViewController.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import "BNScrollView.h"
@interface BNScrollView (Private)<BNScrollViewDatasource>
- (void)swapForMoveUp;
- (void)swapForMoveDown;
- (void)swapForMoveLeft;
- (void)swapForMoveRight;

- (void)applyAllViewControllerDataForHorizontalPage:(int)hPage andVeticalPage:(int)vPage;
- (void)initObjects;
- (void)initViews;

- (void)setVisibilityAndFrame;
@end
@implementation BNScrollView
@synthesize enabledDirection = enabledDirection_;
@synthesize datasource       = datasource_;
@synthesize isHorizontalEndless;
@synthesize isVerticalEndless;
@synthesize scrollViewWidth  = scrollViewWidth_;
@synthesize scrollViewHeight = scrollViewHeight_;
@synthesize scrollViewDelegate = scrollViewDelegate_;

- (void)dealloc {
	[currentView_ release], currentView_ = nil;
	[rightView_ release], rightView_     = nil;
	[leftView_ release], leftView_       = nil;
	[topView_ release], topView_         = nil;
	[bottomView_ release], bottomView_   = nil;
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		enabledDirection_ = EnabledScrollDirectionHorizontal | EnabledScrollDirectionVertical;
		datasource_       = self;
	}
	return self;
}

- (void)buildBNScrollView {
	[self initViews];
	[self initObjects];
}

- (float)scrollViewWidth {
	return self.frame.size.width;
}

- (float)scrollViewHeight {
	return self.frame.size.height;
}

- (void)initObjects {

	self.pagingEnabled                  = YES;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator   = NO;
	self.scrollsToTop                   = NO;
	self.delegate                       = self;
	self.directionalLockEnabled         = YES;
	self.backgroundColor                = [UIColor clearColor];
	self.scrollEnabled                  = YES;

	[self resetAllViews];

	[self addSubview:currentView_];
	[self addSubview:leftView_];
	[self addSubview:rightView_];
	[self addSubview:topView_];
	[self addSubview:bottomView_];

	currentView_.verticalPageNumber   = 0;
	currentView_.horizontalPageNumber = 0;
	[self setVisibilityAndFrame];
    if ([datasource_ respondsToSelector:@selector(scrollView:willApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
        [datasource_ scrollView:self willApplyDataOn:currentView_ withHorizontalPage:currentView_.horizontalPageNumber withVerticalPage:currentView_.verticalPageNumber];
    }
    [datasource_ scrollView:self applyDataOn:currentView_ withHorizontalPage:currentView_.horizontalPageNumber withVerticalPage:currentView_.verticalPageNumber];
    if ([datasource_ respondsToSelector:@selector(scrollView:didApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
        [datasource_ scrollView:self didApplyDataOn:currentView_ withHorizontalPage:currentView_.horizontalPageNumber withVerticalPage:currentView_.verticalPageNumber];
    }
}

- (void)resetAllViews {
	if (!isVerticalEndless && !isHorizontalEndless) {
		self.contentSize = CGSizeMake(self.scrollViewWidth * [datasource_ numberOfHorizontalPages], self.scrollViewHeight * [datasource_ numberOfVerticalPages]);
	}
	else if (isHorizontalEndless && isVerticalEndless) {
		if ([datasource_ numberOfHorizontalPages] < 3 && [datasource_ numberOfVerticalPages] < 3) {
			self.contentSize = CGSizeMake(self.scrollViewWidth * 3, self.scrollViewHeight * 3);
		}
		else if ([datasource_ numberOfVerticalPages] < 3) {
			self.contentSize = CGSizeMake(self.scrollViewWidth * [datasource_ numberOfHorizontalPages], self.scrollViewHeight * 3);
		}
		else if ([datasource_ numberOfHorizontalPages] < 3) {
			self.contentSize = CGSizeMake(self.scrollViewWidth * 3, self.scrollViewHeight * [datasource_ numberOfVerticalPages]);
		}
		else  {
			self.contentSize = CGSizeMake(self.scrollViewWidth * [datasource_ numberOfHorizontalPages], self.scrollViewHeight * [datasource_ numberOfVerticalPages]);
		}

	}
	else if (isHorizontalEndless) {
		if ([datasource_ numberOfHorizontalPages] < 3) {
			self.contentSize = CGSizeMake(self.scrollViewWidth * 3, self.scrollViewHeight * [datasource_ numberOfVerticalPages]);
		}
		else  {
			self.contentSize = CGSizeMake(self.scrollViewWidth * [datasource_ numberOfHorizontalPages], self.scrollViewHeight * [datasource_ numberOfVerticalPages]);
		}
	}
	else if (isVerticalEndless) {
		if ([datasource_ numberOfVerticalPages] < 3) {
			self.contentSize = CGSizeMake(self.scrollViewWidth * [datasource_ numberOfHorizontalPages], self.scrollViewHeight * 3);
		}
		else  {
			self.contentSize = CGSizeMake(self.scrollViewWidth * [datasource_ numberOfHorizontalPages], self.scrollViewHeight * [datasource_ numberOfVerticalPages]);
		}
	}
	else  {
		NSAssert(false, @"ERROR, should not reach here");
	}
//-----------------------------
	if (!isVerticalEndless && !isHorizontalEndless) {
		currentView_.frame = CGRectMake(0, 0, self.scrollViewWidth, self.scrollViewHeight);
	}
	else if (isHorizontalEndless && isVerticalEndless) {
		currentView_.frame = CGRectMake(self.scrollViewWidth, self.scrollViewHeight, self.scrollViewWidth, self.scrollViewHeight);
	}
	else if (isHorizontalEndless) {
		currentView_.frame = CGRectMake(self.scrollViewWidth, 0, self.scrollViewWidth, self.scrollViewHeight);
	}
	else if (isVerticalEndless) {
		currentView_.frame = CGRectMake(0, self.scrollViewHeight, self.scrollViewWidth, self.scrollViewHeight);
	}
	else  {
		NSAssert(false, @"ERROR, should not reach here");
	}
	self.contentOffset = CGPointMake(currentView_.frame.origin.x, currentView_.frame.origin.y);

	[self setVisibilityAndFrame];
}

- (void)initViews {
	currentView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
	if (enabledDirection_ & EnabledScrollDirectionHorizontal) {
		rightView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
		leftView_  = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
	}

	if (enabledDirection_ & EnabledScrollDirectionVertical) {
		topView_    = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
		bottomView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
	}
}

#pragma mark - ScrollView Helper
//Only Load If necessary
- (void)applyAllViewControllerDataForHorizontalPage:(int)hPage andVeticalPage:(int)vPage {
	int leftPage   = hPage - 1;
	int rightPage  = hPage + 1;
	int topPage    = vPage - 1;
	int bottomPage = vPage + 1;

	if (leftPage < 0) {
		leftPage = [datasource_ numberOfHorizontalPages] - 1;
	}

	if (rightPage >= [datasource_ numberOfHorizontalPages]) {
		rightPage = 0;
	}

	if (topPage < 0) {
		topPage = [datasource_ numberOfVerticalPages] - 1;
	}

	if (bottomPage >= [datasource_ numberOfVerticalPages]) {
		bottomPage = 0;
	}

    if ([datasource_ respondsToSelector:@selector(scrollView:willApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
        [datasource_ scrollView:self willApplyDataOn:currentView_ withHorizontalPage:hPage withVerticalPage:vPage];
    }
    [datasource_ scrollView:self applyDataOn:currentView_ withHorizontalPage:hPage withVerticalPage:vPage];
    if ([datasource_ respondsToSelector:@selector(scrollView:didApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
        [datasource_ scrollView:self didApplyDataOn:currentView_ withHorizontalPage:hPage withVerticalPage:vPage];
    }

	if (enabledDirection_ & EnabledScrollDirectionHorizontal) {
		leftView_.horizontalPageNumber = leftPage;
		leftView_.verticalPageNumber   = vPage;
        
        if ([datasource_ respondsToSelector:@selector(scrollView:willApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self willApplyDataOn:leftView_ withHorizontalPage:leftPage withVerticalPage:vPage];
        }
        [datasource_ scrollView:self applyDataOn:leftView_ withHorizontalPage:leftPage withVerticalPage:vPage];
        if ([datasource_ respondsToSelector:@selector(scrollView:didApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self didApplyDataOn:leftView_ withHorizontalPage:leftPage withVerticalPage:vPage];
        }
        
        rightView_.horizontalPageNumber = rightPage;
		rightView_.verticalPageNumber   = vPage;
        
        if ([datasource_ respondsToSelector:@selector(scrollView:willApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self willApplyDataOn:rightView_ withHorizontalPage:rightPage withVerticalPage:vPage];
        }
        [datasource_ scrollView:self applyDataOn:rightView_ withHorizontalPage:rightPage withVerticalPage:vPage];
        if ([datasource_ respondsToSelector:@selector(scrollView:didApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self didApplyDataOn:rightView_ withHorizontalPage:rightPage withVerticalPage:vPage];
        }
	}

	if (enabledDirection_ & EnabledScrollDirectionVertical) {
		topView_.horizontalPageNumber = hPage;
		topView_.verticalPageNumber   = topPage;
        
        if ([datasource_ respondsToSelector:@selector(scrollView:willApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self willApplyDataOn:topView_ withHorizontalPage:hPage withVerticalPage:topPage];
        }
        [datasource_ scrollView:self applyDataOn:topView_ withHorizontalPage:hPage withVerticalPage:topPage];
        if ([datasource_ respondsToSelector:@selector(scrollView:didApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self didApplyDataOn:topView_ withHorizontalPage:hPage withVerticalPage:topPage];
        }
        
		bottomView_.verticalPageNumber   = bottomPage;
		bottomView_.horizontalPageNumber = hPage;

        if ([datasource_ respondsToSelector:@selector(scrollView:willApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self willApplyDataOn:bottomView_ withHorizontalPage:hPage withVerticalPage:bottomPage];
        }
        [datasource_ scrollView:self applyDataOn:bottomView_ withHorizontalPage:hPage withVerticalPage:bottomPage];
        if ([datasource_ respondsToSelector:@selector(scrollView:didApplyDataOn:withHorizontalPage:withVerticalPage:)]) {
            [datasource_ scrollView:self didApplyDataOn:bottomView_ withHorizontalPage:hPage withVerticalPage:bottomPage];
        }
	}
}

- (CGPoint)centerPointForScrollView {
	CGPoint point = CGPointMake(self.contentOffset.x + self.scrollViewWidth / 2, self.contentOffset.y + self.scrollViewHeight / 2);
	return point;
}

- (BOOL)isViewControllerInsideHorizontalViewRect:(UIView *)viewController {
	CGPoint centerPoint = [self centerPointForScrollView];

	BOOL isInside       = YES;
	if (viewController.frame.origin.x > centerPoint.x + self.scrollViewWidth) {
		isInside = NO;
	}

	if (viewController.frame.origin.x + self.scrollViewWidth < centerPoint.x - self.scrollViewWidth) {
		isInside = NO;
	}
	return isInside;
}

- (BOOL)isViewControllerInsideVerticalViewRect:(UIView *)viewController {
	CGPoint centerPoint = [self centerPointForScrollView];

	BOOL isInside       = YES;
	if (viewController.frame.origin.y > centerPoint.y + self.scrollViewHeight) {
		isInside = NO;
	}

	if (viewController.frame.origin.y + self.scrollViewHeight < centerPoint.y - self.scrollViewHeight) {
		isInside = NO;
	}
	return isInside;
}

- (void)applyViewDataByCurrentView {
	int hPage = currentView_.horizontalPageNumber;
	int vPage = currentView_.verticalPageNumber;

	[self applyAllViewControllerDataForHorizontalPage:hPage andVeticalPage:vPage];
}

- (void)setVisibilityAndFrame {
	leftView_.frame = CGRectMake(currentView_.frame.origin.x - currentView_.frame.size.width,
	                             currentView_.frame.origin.y,
	                             self.scrollViewWidth, self.scrollViewHeight);
	rightView_.frame = CGRectMake(currentView_.frame.origin.x + currentView_.frame.size.width,
	                              currentView_.frame.origin.y,
	                              self.scrollViewWidth,
	                              self.scrollViewHeight);
	topView_.frame = CGRectMake(currentView_.frame.origin.x,
	                            currentView_.frame.origin.y - currentView_.frame.size.height,
	                            self.scrollViewWidth,
	                            self.scrollViewHeight);

	bottomView_.frame = CGRectMake(currentView_.frame.origin.x,
	                               currentView_.frame.origin.y + currentView_.frame.size.height,
	                               self.scrollViewWidth,
	                               self.scrollViewHeight);

	if (leftView_.frame.origin.x < 0 && !isHorizontalEndless) {
		leftView_.hidden = YES;
	}
	else  {
		leftView_.hidden = NO;
	}

	if (rightView_.frame.origin.x >= self.scrollViewWidth * [datasource_ numberOfHorizontalPages] && !isHorizontalEndless) {
		rightView_.hidden = YES;
	}
	else  {
		rightView_.hidden = NO;
	}

	if (topView_.frame.origin.y < 0 && !isVerticalEndless) {
		topView_.hidden = YES;
	}
	else  {
		topView_.hidden = NO;
	}

	if (bottomView_.frame.origin.y >= self.scrollViewHeight * [datasource_ numberOfVerticalPages] && !isVerticalEndless) {
		bottomView_.hidden = YES;
	}
	else  {
		bottomView_.hidden = NO;
	}

	[self applyViewDataByCurrentView];

}

- (void)setViewcontrollerPosition {

	if (direction == LEFT || direction == RIGHT) {
		if (!isHorizontalEndless && ![self isViewControllerInsideHorizontalViewRect:leftView_] && !rightView_.hidden) {
			//go to next, move prev to next

			[self swapForMoveRight];
			[self setVisibilityAndFrame];
		}
		else if (isHorizontalEndless && self.contentOffset.x > self.scrollViewWidth * 1.5) {
			self.contentOffset = CGPointMake(self.contentOffset.x - self.scrollViewWidth, self.contentOffset.y);
			[self swapForMoveRight];
			currentView_.frame = CGRectMake(currentView_.frame.origin.x - self.scrollViewWidth,
			                                currentView_.frame.origin.y,
			                                currentView_.frame.size.width,
			                                currentView_.frame.size.height);
			[self setVisibilityAndFrame];
		}

		if (!isHorizontalEndless && ![self isViewControllerInsideHorizontalViewRect:rightView_] && !leftView_.hidden) {
			//go to prev, move next to pre

			[self swapForMoveLeft];
			[self setVisibilityAndFrame];
		}
		else if (isHorizontalEndless && self.contentOffset.x < self.scrollViewWidth * 0.5) {
			self.contentOffset = CGPointMake(self.contentOffset.x + self.scrollViewWidth, self.contentOffset.y);
			[self swapForMoveLeft];
			currentView_.frame = CGRectMake(currentView_.frame.origin.x + self.scrollViewWidth,
			                                currentView_.frame.origin.y,
			                                currentView_.frame.size.width,
			                                currentView_.frame.size.height);
			[self setVisibilityAndFrame];
		}
	}
	else if (direction == UP || direction == DOWN) {
		if (!isVerticalEndless && ![self isViewControllerInsideVerticalViewRect:topView_] && !bottomView_.hidden) {
			[self swapForMoveDown];
			[self setVisibilityAndFrame];
		}
		else if (isVerticalEndless && self.contentOffset.y > self.scrollViewHeight * 1.5) {

			self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - self.scrollViewHeight);
			[self swapForMoveDown];
			currentView_.frame = CGRectMake(currentView_.frame.origin.x,
			                                currentView_.frame.origin.y - self.scrollViewHeight,
			                                currentView_.frame.size.width,
			                                currentView_.frame.size.height);

			[self setVisibilityAndFrame];
		}

		if (!isVerticalEndless && ![self isViewControllerInsideVerticalViewRect:bottomView_] && !topView_.hidden) {
			[self swapForMoveUp];
			[self setVisibilityAndFrame];
		}
		else if (isVerticalEndless && self.contentOffset.y < self.scrollViewHeight * 0.5) {

			self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + self.scrollViewHeight);
			[self swapForMoveUp];
			currentView_.frame = CGRectMake(currentView_.frame.origin.x,
			                                currentView_.frame.origin.y + self.scrollViewHeight,
			                                currentView_.frame.size.width,
			                                currentView_.frame.size.height);

			[self setVisibilityAndFrame];
		}
	}

}

- (void)swapForMoveUp {
	int verticalPage   = currentView_.verticalPageNumber;
	int horizontalPage = currentView_.horizontalPageNumber;

	//go to top, move bottom to top
	UIView<BNScrollPageView> *top     = topView_;
	UIView<BNScrollPageView> *bottom  = bottomView_;
	UIView<BNScrollPageView> *current = currentView_;

	currentView_ = top;
	topView_     = bottom;
	bottomView_  = current;

	if ((verticalPage = verticalPage - 1) < 0) {
		verticalPage = [datasource_ numberOfVerticalPages] - 1;
	}
	currentView_.verticalPageNumber   = verticalPage;
	currentView_.horizontalPageNumber = horizontalPage;
}

- (void)swapForMoveDown {
	int verticalPage   = currentView_.verticalPageNumber;
	int horizontalPage = currentView_.horizontalPageNumber;

	//go to bottom, move top to bottom
	UIView<BNScrollPageView> *top     = topView_;
	UIView<BNScrollPageView> *bottom  = bottomView_;
	UIView<BNScrollPageView> *current = currentView_;

	currentView_ = bottom;
	topView_     = current;
	bottomView_  = top;

	if ((verticalPage = verticalPage + 1) >= [datasource_ numberOfVerticalPages]) {
		verticalPage = 0;
	}

	currentView_.verticalPageNumber   = verticalPage;
	currentView_.horizontalPageNumber = horizontalPage;
}

- (void)swapForMoveLeft {
	int verticalPage                  = currentView_.verticalPageNumber;
	int horizontalPage                = currentView_.horizontalPageNumber;

	UIView<BNScrollPageView> *prev    = leftView_;
	UIView<BNScrollPageView> *next    = rightView_;
	UIView<BNScrollPageView> *current = currentView_;

	currentView_ = prev;
	leftView_    = next;
	rightView_   = current;

	if ((horizontalPage = horizontalPage - 1) < 0) {
		horizontalPage = [datasource_ numberOfHorizontalPages] - 1;
	}
	currentView_.verticalPageNumber   = verticalPage;
	currentView_.horizontalPageNumber = horizontalPage;
}

- (void)swapForMoveRight {
	int verticalPage                  = currentView_.verticalPageNumber;
	int horizontalPage                = currentView_.horizontalPageNumber;

	UIView<BNScrollPageView> *prev    = leftView_;
	UIView<BNScrollPageView> *next    = rightView_;
	UIView<BNScrollPageView> *current = currentView_;

	rightView_   = prev;
	currentView_ = next;
	leftView_    = current;

	if ((horizontalPage = horizontalPage + 1) >= [datasource_ numberOfHorizontalPages]) {
		horizontalPage = 0;
	}
	currentView_.verticalPageNumber   = verticalPage;
	currentView_.horizontalPageNumber = horizontalPage;
}

-(void)eachPage:(void (^)(id object))block {
    block(currentView_);
    block(leftView_);
    block(rightView_);
    block(topView_);
    block(bottomView_);
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	CGFloat horizotalDiff = abs(self.contentOffset.x - lastContentOffset_.x);
	CGFloat verticalDiff  = abs(self.contentOffset.y - lastContentOffset_.y);

	if (horizotalDiff < verticalDiff && canScrollViewBeginVerticalDragging_) {
		if (self.contentOffset.y - lastContentOffset_.y >= 0) {
			direction = DOWN;
		}
		else  {
			direction = UP;
		}
	}
	else if (horizotalDiff >= verticalDiff && canScrollViewBeginHorizontalDragging_) {
		if (self.contentOffset.x - lastContentOffset_.x >= 0) {
			direction = RIGHT;
		}
		else  {
			direction = LEFT;
		}
	}

	if (direction == RIGHT || direction == LEFT) {
		self.contentOffset = CGPointMake(self.contentOffset.x, lastContentOffset_.y);
	}
	else if (direction == UP || direction == DOWN) {
		self.contentOffset = CGPointMake(lastContentOffset_.x, self.contentOffset.y);

	}
	[self setViewcontrollerPosition];
    
    //forward scroll event
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:sender];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	lastContentOffset_ = self.contentOffset;
	if ((int)self.contentOffset.x % (int) self.scrollViewWidth == 0) {
		canScrollViewBeginVerticalDragging_ = YES;
	}

	if ((int)self.contentOffset.y % (int) self.scrollViewHeight == 0) {
		canScrollViewBeginHorizontalDragging_ = YES;
	}

    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self setViewcontrollerPosition];
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self setViewcontrollerPosition];
	canScrollViewBeginVerticalDragging_   = NO;
	canScrollViewBeginHorizontalDragging_ = NO;
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self setViewcontrollerPosition];
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

#pragma mark - BNScrollViewDataSource
- (int)numberOfVerticalPages {
	return 0;
}

- (int)numberOfHorizontalPages {
	return 0;
}

- (UIView<BNScrollPageView> *)resuableScrollPageViewInScrollView:(BNScrollView *)scrollView {
	return nil;
}

@end
