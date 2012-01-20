//
//  BNScrollViewController.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import "BNScrollView.h"
@interface BNScrollView (Private)<BNScrollViewDatasource>
-(void) swapForMoveUp;
-(void) swapForMoveDown;
-(void) swapForMoveLeft;
-(void) swapForMoveRight;

- (void)applyAllViewControllerDataForHorizontalPage:(int) hPage andVeticalPage:(int)vPage;
- (void)initObjects;
-(void)initViews;

- (void)setVisibilityAndFrame;
@end
@implementation BNScrollView 
@synthesize enabledDirection = enabledDirection_;
@synthesize datasource = datasource_;
@synthesize isHorizontalEndless;
@synthesize isVerticalEndless;


- (void)dealloc {
    [currentView_ release], currentView_ = nil;
    [rightView_ release], rightView_ = nil;
    [leftView_ release], leftView_ = nil;
    [topView_ release], topView_ = nil;
    [bottomView_ release], bottomView_ = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        scrollViewWidth_ = frame.size.width;
        scrollViewHeight_ = frame.size.height;
        enabledDirection_ = EnabledScrollDirectionHorizontal | EnabledScrollDirectionVertical;
        datasource_ = self;
    }
    return self;
}

- (void)buildBNScrollView {
    [self initViews];
    [self initObjects];
}

- (void)initObjects {    

    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.delegate = self;
//    Below is comment. Situation is controlled by Datasource
//    if (enabledDirection_ & (EnabledScrollDirectionHorizontal & EnabledScrollDirectionVertical)) {
//        self.contentSize = CGSizeMake(scrollViewWidth_ * [datasource_ numberOfHorizontalPages], scrollViewHeight_ * [datasource_ numberOfVerticalPages]);
//    }
//    else if(enabledDirection_ & EnabledScrollDirectionHorizontal) {
//        self.contentSize = CGSizeMake(scrollViewWidth_ * [datasource_ numberOfHorizontalPages], scrollViewHeight_);
//    }
//    else if(enabledDirection_ & EnabledScrollDirectionVertical) {
//        self.contentSize = CGSizeMake(scrollViewWidth_, scrollViewHeight_ * [datasource_ numberOfVerticalPages]);
//    }
    self.contentSize = CGSizeMake(scrollViewWidth_ * [datasource_ numberOfHorizontalPages], scrollViewHeight_ * [datasource_ numberOfVerticalPages]);
    self.directionalLockEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.scrollEnabled = YES;
    
    if (isHorizontalEndless && isVerticalEndless) {
        currentView_.frame = CGRectMake(scrollViewWidth_, scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    }
    else if (isHorizontalEndless) {
        currentView_.frame = CGRectMake(scrollViewWidth_, 0, scrollViewWidth_, scrollViewHeight_);
    }
    else if (isVerticalEndless) {
        currentView_.frame = CGRectMake(0, scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    }
    else {
        currentView_.frame = CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_);
    }
    self.contentOffset = CGPointMake(currentView_.frame.origin.x, currentView_.frame.origin.y);

    [self addSubview:currentView_];
    [self addSubview:leftView_];
    [self addSubview:rightView_];
    [self addSubview:topView_];
    [self addSubview:bottomView_];

    currentView_.verticalPageNumber = 0;
    currentView_.horizontalPageNumber = 0;
    [self setVisibilityAndFrame];
    [currentView_ applyViewDataWithHorizontalPage:currentView_.horizontalPageNumber andVerticalPage:currentView_.verticalPageNumber];

    
}

-(void)initViews {
    currentView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
    if (enabledDirection_ & EnabledScrollDirectionHorizontal) {
        rightView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
        leftView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
    }
    
    if (enabledDirection_ & EnabledScrollDirectionVertical) {
        topView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
        bottomView_ = [[datasource_ resuableScrollPageViewInScrollView:self] retain];
    }
}

#pragma mark - ScrollView Helper
//Only Load If necessary
- (void)applyAllViewControllerDataForHorizontalPage:(int) hPage andVeticalPage:(int)vPage{
    if (currentView_.horizontalPageNumber != hPage || currentView_.verticalPageNumber != vPage) {
        [currentView_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage];
    }
    
    if (enabledDirection_ & EnabledScrollDirectionHorizontal) {
        if (leftView_.horizontalPageNumber != hPage -1 || leftView_.verticalPageNumber != vPage) {
            leftView_.horizontalPageNumber = hPage -1;
            leftView_.verticalPageNumber = vPage;
            [leftView_ applyViewDataWithHorizontalPage:hPage-1 andVerticalPage:vPage];
        }
        
        if (rightView_.horizontalPageNumber != hPage + 1 || rightView_.verticalPageNumber != vPage) {
            rightView_.horizontalPageNumber = hPage + 1;
            rightView_.verticalPageNumber = vPage;
            [rightView_ applyViewDataWithHorizontalPage:hPage+1 andVerticalPage:vPage];
        }
    }
    
    if (enabledDirection_ & EnabledScrollDirectionVertical) {
        if (topView_.horizontalPageNumber != hPage || topView_.verticalPageNumber != vPage -1) {
            topView_.horizontalPageNumber = hPage;
            topView_.verticalPageNumber = vPage -1;
            [topView_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage-1];
        }
        
        if (bottomView_.horizontalPageNumber != hPage || bottomView_.verticalPageNumber != vPage+1) {
            bottomView_.verticalPageNumber = vPage + 1;
            bottomView_.horizontalPageNumber = hPage;
            [bottomView_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage+1];
        }
    }
}


- (CGPoint)centerPointForScrollView {
    CGPoint point = CGPointMake(self.contentOffset.x + scrollViewWidth_/2, self.contentOffset.y + scrollViewHeight_/2);
    return point;
}

- (BOOL) isViewControllerInsideHorizontalViewRect:(UIView*) viewController {
    CGPoint centerPoint = [self centerPointForScrollView];
    
    BOOL isInside = YES;
    if (viewController.frame.origin.x > centerPoint.x + scrollViewWidth_) {
        isInside = NO;
    }
    
    if (viewController.frame.origin.x + scrollViewWidth_ < centerPoint.x - scrollViewWidth_) {
        isInside = NO;
    }
    return isInside;
}

- (BOOL) isViewControllerInsideVerticalViewRect:(UIView*) viewController {
    CGPoint centerPoint = [self centerPointForScrollView];
    
    BOOL isInside = YES;
    if (viewController.frame.origin.y > centerPoint.y + scrollViewHeight_) {
        isInside = NO;
    }
    
    if (viewController.frame.origin.y + scrollViewHeight_ < centerPoint.y - scrollViewHeight_) {
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
                                 scrollViewWidth_, scrollViewHeight_);
    rightView_.frame = CGRectMake(currentView_.frame.origin.x + currentView_.frame.size.width,
                                  currentView_.frame.origin.y, 
                                  scrollViewWidth_, 
                                  scrollViewHeight_);
    topView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                currentView_.frame.origin.y-currentView_.frame.size.height,
                                scrollViewWidth_,
                                scrollViewHeight_);
    
    bottomView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                   currentView_.frame.origin.y+currentView_.frame.size.height,
                                   scrollViewWidth_, 
                                   scrollViewHeight_);
    
    if (leftView_.frame.origin.x < 0) {
        leftView_.hidden = YES;
    }
    else {
        leftView_.hidden = NO;
    }
    
    if (rightView_.frame.origin.x >= scrollViewWidth_ * [datasource_ numberOfHorizontalPages]) {
        rightView_.hidden = YES;
    }
    else {
        rightView_.hidden = NO;
    }
    
    if (topView_.frame.origin.y < 0) { 
        topView_.hidden = YES;
    }
    else {
        topView_.hidden = NO;
    }
    
    if (bottomView_.frame.origin.y >= scrollViewHeight_ * [datasource_ numberOfVerticalPages]) { 
        bottomView_.hidden = YES;
    }
    else {
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
        
        else if (isHorizontalEndless && self.contentOffset.x > scrollViewWidth_ * 1.5) {
            self.contentOffset = CGPointMake(self.contentOffset.x - scrollViewWidth_, self.contentOffset.y);
            [self swapForMoveRight]; 
            currentView_.frame = CGRectMake(currentView_.frame.origin.x - scrollViewWidth_, 
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
        
        else if (isHorizontalEndless && self.contentOffset.x < scrollViewWidth_ * 0.5) {
            self.contentOffset = CGPointMake(self.contentOffset.x + scrollViewWidth_, self.contentOffset.y);
            [self swapForMoveLeft]; 
            currentView_.frame = CGRectMake(currentView_.frame.origin.x + scrollViewWidth_, 
                                                           currentView_.frame.origin.y, 
                                                           currentView_.frame.size.width, 
                                                           currentView_.frame.size.height);
            [self setVisibilityAndFrame];
        }
    }
    
    else if (direction == UP || direction == DOWN ) {
        if (!isVerticalEndless&&![self isViewControllerInsideVerticalViewRect:topView_] && !bottomView_.hidden) {
            [self swapForMoveDown];
            [self setVisibilityAndFrame];
        }
        else if (isVerticalEndless && self.contentOffset.y > scrollViewHeight_ * 1.5) {
            
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - scrollViewHeight_ );
            [self swapForMoveDown]; 
            currentView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                                           currentView_.frame.origin.y - scrollViewHeight_, 
                                                           currentView_.frame.size.width, 
                                                           currentView_.frame.size.height);
            
            [self setVisibilityAndFrame];
        }
        
        if (!isVerticalEndless && ![self isViewControllerInsideVerticalViewRect:bottomView_] && !topView_.hidden) {
            [self swapForMoveUp];
            [self setVisibilityAndFrame];
        }
        
        else if (isVerticalEndless && self.contentOffset.y < scrollViewHeight_ * 0.5) {
            
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + scrollViewHeight_ );
            [self swapForMoveUp];
            currentView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                                           currentView_.frame.origin.y + scrollViewHeight_, 
                                                           currentView_.frame.size.width, 
                                                           currentView_.frame.size.height);
            
            
            
            [self setVisibilityAndFrame];
        }
    }
    
}

-(void) swapForMoveUp {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    //go to top, move bottom to top
    UIView<BNScrollPageView> *top = topView_;
    UIView<BNScrollPageView> *bottom = bottomView_;
    UIView<BNScrollPageView> *current = currentView_;
    
    currentView_ = top;
    topView_ = bottom;
    bottomView_ = current;
    
    if ((verticalPage = verticalPage -1) < 0) {
        verticalPage = [datasource_ numberOfVerticalPages] -1;
    }
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveDown {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    //go to bottom, move top to bottom
    UIView<BNScrollPageView> *top = topView_;
    UIView<BNScrollPageView> *bottom = bottomView_;
    UIView<BNScrollPageView> *current = currentView_;
    
    currentView_ = bottom;
    topView_ = current;
    bottomView_ = top;
    
    if ((verticalPage = verticalPage +1) >= [datasource_ numberOfVerticalPages]) {
        verticalPage = 0;
    }
    
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveLeft {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    UIView<BNScrollPageView> *prev = leftView_;
    UIView<BNScrollPageView> *next = rightView_;
    UIView<BNScrollPageView> *current = currentView_;
    
    currentView_ = prev;
    leftView_ = next;
    rightView_ = current;
    
    if ((horizontalPage = horizontalPage -1) < 0) {
        horizontalPage = [datasource_ numberOfHorizontalPages] -1;
    }
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveRight {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    UIView<BNScrollPageView> *prev = leftView_;
    UIView<BNScrollPageView> *next = rightView_;
    UIView<BNScrollPageView> *current = currentView_;
    
    rightView_ = prev;
    currentView_ = next;
    leftView_ = current;
    
    if ((horizontalPage = horizontalPage +1) >= [datasource_ numberOfHorizontalPages]) {
        horizontalPage = 0;
    }
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{    
    CGFloat horizotalDiff = abs(self.contentOffset.x - lastContentOffset_.x);
    CGFloat verticalDiff = abs(self.contentOffset.y - lastContentOffset_.y);
    
    if (horizotalDiff < verticalDiff && canScrollViewBeginVerticalDragging_) {
        if (self.contentOffset.y - lastContentOffset_.y >=0) {
            direction = DOWN;
        }
        else {
            direction = UP;
        }
    }
    else if (horizotalDiff >= verticalDiff && canScrollViewBeginHorizontalDragging_) {
        if (self.contentOffset.x - lastContentOffset_.x >=0) {
            direction = RIGHT;
        }
        else {
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
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    lastContentOffset_ = self.contentOffset;
    if ((int)self.contentOffset.x % (int) scrollViewWidth_ == 0) {
        canScrollViewBeginVerticalDragging_ = YES;
    }
    
    if ((int)self.contentOffset.y % (int) scrollViewHeight_ == 0) {
        canScrollViewBeginHorizontalDragging_ = YES;
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setViewcontrollerPosition];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setViewcontrollerPosition];
    canScrollViewBeginVerticalDragging_ = NO;
    canScrollViewBeginHorizontalDragging_ = NO;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setViewcontrollerPosition];
}

#pragma mark - BNScrollViewDataSource
-(int)numberOfVerticalPages {
    return 0;
}

-(int)numberOfHorizontalPages {
    return 0;
}
-(UIView<BNScrollPageView> *)resuableScrollPageViewInScrollView:(BNScrollView *)scrollView {
    return nil;
}
@end
