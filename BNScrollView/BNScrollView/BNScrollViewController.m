//
//  BNScrollViewController.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import "BNScrollViewController.h"
#import "BNScrollViewDatasource.h"
@interface BNScrollViewController (Private)
-(void) swapForMoveUp;
-(void) swapForMoveDown;
-(void) swapForMoveLeft;
-(void) swapForMoveRight;

- (void)applyAllViewControllerDataForHorizontalPage:(int) hPage andVeticalPage:(int)vPage;
- (void)initObjects;
-(void)initViewControllers;

- (void)setVisibilityAndFrame;
@end
@implementation BNScrollViewController 
@synthesize scrollView = scrollView_;
@synthesize enabledDirection = enabledDirection_;


- (void)dealloc {
    [currentView_ release], currentView_ = nil;
    [rightView_ release], rightView_ = nil;
    [leftView_ release], leftView_ = nil;
    [topView_ release], topView_ = nil;
    [bottomView_ release], bottomView_ = nil;
    [scrollView_ release], scrollView_ = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;

}

- (id)initWithScrollViewWidth:(int)aScrollViewWidth scrollViewHeight:(int)aScrollViewHeight isHorizontalEndless:(BOOL)hEndless isVerticalEndLess:(BOOL)vEndless enabledScrollDirection:(EnabledScrollDirection) enabledDirection
{
    self = [super init];
    if (self) {
        enabledDirection_ = enabledDirection;
        scrollViewWidth_ = aScrollViewWidth;
        scrollViewHeight_ = aScrollViewHeight;
        isHorizontalEndless = hEndless;
        isVerticalEndless = vEndless;
        [self initViewControllers];
        [self initObjects];

    }
    return self;
}

- (void)initObjects {
    scrollView_ = [[UIScrollView  alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    scrollView_.pagingEnabled = YES;
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.scrollsToTop = NO;
    scrollView_.delegate = self;
//    Below is comment. Situation is controlled by Datasource
//    if (enabledDirection_ & (EnabledScrollDirectionHorizontal & EnabledScrollDirectionVertical)) {
//        scrollView_.contentSize = CGSizeMake(scrollViewWidth_ * [BNScrollViewDatasource numberOfHorizontalPages], scrollViewHeight_ * [BNScrollViewDatasource numberOfVerticalPages]);
//    }
//    else if(enabledDirection_ & EnabledScrollDirectionHorizontal) {
//        scrollView_.contentSize = CGSizeMake(scrollViewWidth_ * [BNScrollViewDatasource numberOfHorizontalPages], scrollViewHeight_);
//    }
//    else if(enabledDirection_ & EnabledScrollDirectionVertical) {
//        scrollView_.contentSize = CGSizeMake(scrollViewWidth_, scrollViewHeight_ * [BNScrollViewDatasource numberOfVerticalPages]);
//    }
    scrollView_.contentSize = CGSizeMake(scrollViewWidth_ * [BNScrollViewDatasource numberOfHorizontalPages], scrollViewHeight_ * [BNScrollViewDatasource numberOfVerticalPages]);
    scrollView_.directionalLockEnabled = YES;
    scrollView_.backgroundColor = [UIColor clearColor];
    scrollView_.scrollEnabled = YES;
    
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
    scrollView_.contentOffset = CGPointMake(currentView_.frame.origin.x, currentView_.frame.origin.y);

    [scrollView_ addSubview:currentView_];
    [scrollView_ addSubview:leftView_];
    [scrollView_ addSubview:rightView_];
    [scrollView_ addSubview:topView_];
    [scrollView_ addSubview:bottomView_];

//    [self applyAllViewControllerDataForHorizontalPage:0 andVeticalPage:0];
    currentView_.verticalPageNumber = 0;
    currentView_.horizontalPageNumber = 0;
    [self setVisibilityAndFrame];
    
    [self.view addSubview:scrollView_];
    
    
}

-(void)initViewControllers {
    currentView_ = [[BNPageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    leftView_ = [[BNPageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    rightView_ = [[BNPageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    topView_ = [[BNPageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    bottomView_ = [[BNPageView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
}

#pragma mark - ScrollView Helper
- (void)applyAllViewControllerDataForHorizontalPage:(int) hPage andVeticalPage:(int)vPage{
    [currentView_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage];
    
    if (enabledDirection_ & EnabledScrollDirectionHorizontal) {
        [leftView_ applyViewDataWithHorizontalPage:hPage-1 andVerticalPage:vPage];
        [rightView_ applyViewDataWithHorizontalPage:hPage+1 andVerticalPage:vPage];
    }
    
    if (enabledDirection_ & EnabledScrollDirectionVertical) {
        [topView_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage-1];
        [rightView_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage+1];
    }
}


- (CGPoint)centerPointForScrollView {
    CGPoint point = CGPointMake(scrollView_.contentOffset.x + scrollViewWidth_/2, scrollView_.contentOffset.y + scrollViewHeight_/2);
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

- (void)applyViewDataByCurrentViewController {
    int hPage = currentView_.horizontalPageNumber;
    int vPage = currentView_.verticalPageNumber;
    
    [self applyAllViewControllerDataForHorizontalPage:hPage andVeticalPage:vPage];
}

- (void)setVisibilityAndFrame {
    leftView_.frame = CGRectMake(currentView_.frame.origin.x - scrollViewWidth_, currentView_.frame.origin.y, scrollViewWidth_, scrollViewHeight_);
    rightView_.frame = CGRectMake(currentView_.frame.origin.x + scrollViewWidth_, currentView_.frame.origin.y, scrollViewWidth_, scrollViewHeight_);
    topView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                               currentView_.frame.origin.y-scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    
    bottomView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                                  currentView_.frame.origin.y+scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    
    if (leftView_.frame.origin.x < 0) {
        leftView_.hidden = YES;
    }
    else {
        leftView_.hidden = NO;
    }
    
    if (rightView_.frame.origin.x >= scrollViewWidth_ * [BNScrollViewDatasource numberOfHorizontalPages]) {
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
    
    if (bottomView_.frame.origin.y >= scrollViewHeight_ * [BNScrollViewDatasource numberOfVerticalPages]) { 
        bottomView_.hidden = YES;
    }
    else {
        bottomView_.hidden = NO;
    }
    
    [self applyViewDataByCurrentViewController];
    
}

- (void)setViewcontrollerPosition {
    
    if (direction == LEFT || direction == RIGHT) {
        if (!isHorizontalEndless && ![self isViewControllerInsideHorizontalViewRect:leftView_]) {
            //go to next, move prev to next
            
            [self swapForMoveRight];
            [self setVisibilityAndFrame];
        }
        
        else if (isHorizontalEndless && scrollView_.contentOffset.x > scrollViewWidth_ * 1.5) {
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x - scrollViewWidth_, scrollView_.contentOffset.y);
            [self swapForMoveRight]; 
            currentView_.frame = CGRectMake(currentView_.frame.origin.x - scrollViewWidth_, 
                                                           currentView_.frame.origin.y, 
                                                           currentView_.frame.size.width, 
                                                           currentView_.frame.size.height);
            [self setVisibilityAndFrame];
        }
        
        if (!isHorizontalEndless && ![self isViewControllerInsideHorizontalViewRect:rightView_]) {
            //go to prev, move next to pre
            
            [self swapForMoveLeft];
            [self setVisibilityAndFrame];
        }
        
        else if (isHorizontalEndless && scrollView_.contentOffset.x < scrollViewWidth_ * 0.5) {
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x + scrollViewWidth_, scrollView_.contentOffset.y);
            [self swapForMoveLeft]; 
            currentView_.frame = CGRectMake(currentView_.frame.origin.x + scrollViewWidth_, 
                                                           currentView_.frame.origin.y, 
                                                           currentView_.frame.size.width, 
                                                           currentView_.frame.size.height);
            [self setVisibilityAndFrame];
        }
    }
    
    else if (direction == UP || direction == DOWN ) {
        if (!isVerticalEndless&&![self isViewControllerInsideVerticalViewRect:topView_]) {
            [self swapForMoveDown];
            [self setVisibilityAndFrame];
        }
        else if (isVerticalEndless && scrollView_.contentOffset.y > scrollViewHeight_ * 1.5) {
            
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x, scrollView_.contentOffset.y - scrollViewHeight_ );
            [self swapForMoveDown]; 
            currentView_.frame = CGRectMake(currentView_.frame.origin.x, 
                                                           currentView_.frame.origin.y - scrollViewHeight_, 
                                                           currentView_.frame.size.width, 
                                                           currentView_.frame.size.height);
            
            [self setVisibilityAndFrame];
        }
        
        if (!isVerticalEndless && ![self isViewControllerInsideVerticalViewRect:bottomView_]) {
            [self swapForMoveUp];
            [self setVisibilityAndFrame];
        }
        
        else if (isVerticalEndless && scrollView_.contentOffset.y < scrollViewHeight_ * 0.5) {
            
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x, scrollView_.contentOffset.y + scrollViewHeight_ );
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
    BNPageView *top = topView_;
    BNPageView *bottom = bottomView_;
    BNPageView *current = currentView_;
    
    currentView_ = top;
    topView_ = bottom;
    bottomView_ = current;
    
    if ((verticalPage = verticalPage -1) < 0) {
        verticalPage = [BNScrollViewDatasource numberOfVerticalPages] -1;
    }
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveDown {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    //go to bottom, move top to bottom
    BNPageView *top = topView_;
    BNPageView *bottom = bottomView_;
    BNPageView *current = currentView_;
    
    currentView_ = bottom;
    topView_ = current;
    bottomView_ = top;
    
    if ((verticalPage = verticalPage +1) >= [BNScrollViewDatasource numberOfVerticalPages]) {
        verticalPage = 0;
    }
    
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveLeft {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    BNPageView *prev = leftView_;
    BNPageView *next = rightView_;
    BNPageView *current = currentView_;
    
    currentView_ = prev;
    leftView_ = next;
    rightView_ = current;
    
    if ((horizontalPage = horizontalPage -1) < 0) {
        horizontalPage = [BNScrollViewDatasource numberOfHorizontalPages] -1;
    }
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveRight {
    int verticalPage = currentView_.verticalPageNumber;
    int horizontalPage = currentView_.horizontalPageNumber;
    
    BNPageView *prev = leftView_;
    BNPageView *next = rightView_;
    BNPageView *current = currentView_;
    
    rightView_ = prev;
    currentView_ = next;
    leftView_ = current;
    
    if ((horizontalPage = horizontalPage +1) >= [BNScrollViewDatasource numberOfHorizontalPages]) {
        horizontalPage = 0;
    }
    currentView_.verticalPageNumber = verticalPage;
    currentView_.horizontalPageNumber = horizontalPage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{    
    CGFloat horizotalDiff = abs(scrollView_.contentOffset.x - lastContentOffset_.x);
    CGFloat verticalDiff = abs(scrollView_.contentOffset.y - lastContentOffset_.y);
    
    if (horizotalDiff < verticalDiff && canScrollViewBeginVerticalDragging_) {
        //NSLog(@"horizotalOffset < verticalOffset");
        if (scrollView_.contentOffset.y - lastContentOffset_.y >=0) {
            direction = DOWN;
        }
        else {
            direction = UP;
        }
    }
    else if (horizotalDiff >= verticalDiff && canScrollViewBeginHorizontalDragging_) {
        if (scrollView_.contentOffset.x - lastContentOffset_.x >=0) {
            direction = RIGHT;
        }
        else {
            direction = LEFT;
        }
    }
    
    if (direction == RIGHT || direction == LEFT) {
        scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x, lastContentOffset_.y);
    }
    else if (direction == UP || direction == DOWN) {
        scrollView_.contentOffset = CGPointMake(lastContentOffset_.x, scrollView_.contentOffset.y);
        
    }
    [self setViewcontrollerPosition];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    lastContentOffset_ = scrollView_.contentOffset;
    if ((int)scrollView_.contentOffset.x % (int) scrollViewWidth_ == 0) {
        canScrollViewBeginVerticalDragging_ = YES;
    }
    
    if ((int)scrollView_.contentOffset.y % (int) scrollViewHeight_ == 0) {
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

@end
