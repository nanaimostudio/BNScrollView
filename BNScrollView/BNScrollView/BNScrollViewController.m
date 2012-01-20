//
//  BNScrollViewController.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
    [currentViewController_ release], currentViewController_ = nil;
    [nextViewController_ release], nextViewController_ = nil;
    [prevViewController_ release], prevViewController_ = nil;
    [topViewController_ release], topViewController_ = nil;
    [bottomViewController_ release], bottomViewController_ = nil;
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
    scrollView_.contentSize = CGSizeMake(scrollViewWidth_ * [BNScrollViewDatasource numberOfHorizontalPages], scrollViewHeight_ * [BNScrollViewDatasource numberOfVerticalPages]);
    scrollView_.directionalLockEnabled = YES;
    scrollView_.backgroundColor = [UIColor clearColor];
    scrollView_.scrollEnabled = YES;
    
    if (isHorizontalEndless && isVerticalEndless) {
        currentViewController_.frame = CGRectMake(scrollViewWidth_, scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    }
    else if (isHorizontalEndless) {
        currentViewController_.frame = CGRectMake(scrollViewWidth_, 0, scrollViewWidth_, scrollViewHeight_);
    }
    else if (isVerticalEndless) {
        currentViewController_.frame = CGRectMake(0, scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    }
    else {
        currentViewController_.frame = CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_);
    }
    scrollView_.contentOffset = CGPointMake(currentViewController_.frame.origin.x, currentViewController_.frame.origin.y);

    [scrollView_ addSubview:currentViewController_];
    [scrollView_ addSubview:prevViewController_];
    [scrollView_ addSubview:nextViewController_];
    [scrollView_ addSubview:topViewController_];
    [scrollView_ addSubview:bottomViewController_];

//    [self applyAllViewControllerDataForHorizontalPage:0 andVeticalPage:0];
    currentViewController_.verticalPageNumber = 0;
    currentViewController_.horizontalPageNumber = 0;
    [self setVisibilityAndFrame];
    
    [self.view addSubview:scrollView_];
    
    
}

-(void)initViewControllers {
    currentViewController_ = [[BNPageViewController alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    prevViewController_ = [[BNPageViewController alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    nextViewController_ = [[BNPageViewController alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    topViewController_ = [[BNPageViewController alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
    bottomViewController_ = [[BNPageViewController alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth_, scrollViewHeight_)];
}

#pragma mark - ScrollView Helper
- (void)applyAllViewControllerDataForHorizontalPage:(int) hPage andVeticalPage:(int)vPage{
    [currentViewController_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage];
    
    if (enabledDirection_ & EnabledScrollDirectionHorizontal) {
        [prevViewController_ applyViewDataWithHorizontalPage:hPage-1 andVerticalPage:vPage];
        [nextViewController_ applyViewDataWithHorizontalPage:hPage+1 andVerticalPage:vPage];
    }
    
    if (enabledDirection_ & EnabledScrollDirectionVertical) {
        [topViewController_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage-1];
        [nextViewController_ applyViewDataWithHorizontalPage:hPage andVerticalPage:vPage+1];
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
    int hPage = currentViewController_.horizontalPageNumber;
    int vPage = currentViewController_.verticalPageNumber;
    
    [self applyAllViewControllerDataForHorizontalPage:hPage andVeticalPage:vPage];
}

- (void)setVisibilityAndFrame {
    prevViewController_.frame = CGRectMake(currentViewController_.frame.origin.x - scrollViewWidth_, currentViewController_.frame.origin.y, scrollViewWidth_, scrollViewHeight_);
    nextViewController_.frame = CGRectMake(currentViewController_.frame.origin.x + scrollViewWidth_, currentViewController_.frame.origin.y, scrollViewWidth_, scrollViewHeight_);
    topViewController_.frame = CGRectMake(currentViewController_.frame.origin.x, 
                                               currentViewController_.frame.origin.y-scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    
    bottomViewController_.frame = CGRectMake(currentViewController_.frame.origin.x, 
                                                  currentViewController_.frame.origin.y+scrollViewHeight_, scrollViewWidth_, scrollViewHeight_);
    
    if (prevViewController_.frame.origin.x < 0) {
        prevViewController_.hidden = YES;
    }
    else {
        prevViewController_.hidden = NO;
    }
    
    if (nextViewController_.frame.origin.x >= scrollViewWidth_ * [BNScrollViewDatasource numberOfHorizontalPages]) {
        nextViewController_.hidden = YES;
    }
    else {
        nextViewController_.hidden = NO;
    }
    
    if (topViewController_.frame.origin.y < 0) { 
        topViewController_.hidden = YES;
    }
    else {
        topViewController_.hidden = NO;
    }
    
    if (bottomViewController_.frame.origin.y >= scrollViewHeight_ * [BNScrollViewDatasource numberOfVerticalPages]) { 
        bottomViewController_.hidden = YES;
    }
    else {
        bottomViewController_.hidden = NO;
    }
    
    [self applyViewDataByCurrentViewController];
    
}

- (void)setViewcontrollerPosition {
    
    if (direction == LEFT || direction == RIGHT) {
        if (!isHorizontalEndless && ![self isViewControllerInsideHorizontalViewRect:prevViewController_]) {
            //go to next, move prev to next
            
            [self swapForMoveRight];
            [self setVisibilityAndFrame];
        }
        
        else if (isHorizontalEndless && scrollView_.contentOffset.x > scrollViewWidth_ * 1.5) {
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x - scrollViewWidth_, scrollView_.contentOffset.y);
            [self swapForMoveRight]; 
            currentViewController_.frame = CGRectMake(currentViewController_.frame.origin.x - scrollViewWidth_, 
                                                           currentViewController_.frame.origin.y, 
                                                           currentViewController_.frame.size.width, 
                                                           currentViewController_.frame.size.height);
            [self setVisibilityAndFrame];
        }
        
        if (!isHorizontalEndless && ![self isViewControllerInsideHorizontalViewRect:nextViewController_]) {
            //go to prev, move next to pre
            
            [self swapForMoveLeft];
            [self setVisibilityAndFrame];
        }
        
        else if (isHorizontalEndless && scrollView_.contentOffset.x < scrollViewWidth_ * 0.5) {
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x + scrollViewWidth_, scrollView_.contentOffset.y);
            [self swapForMoveLeft]; 
            currentViewController_.frame = CGRectMake(currentViewController_.frame.origin.x + scrollViewWidth_, 
                                                           currentViewController_.frame.origin.y, 
                                                           currentViewController_.frame.size.width, 
                                                           currentViewController_.frame.size.height);
            [self setVisibilityAndFrame];
        }
    }
    
    else if (direction == UP || direction == DOWN) {
        if (!isVerticalEndless&&![self isViewControllerInsideVerticalViewRect:topViewController_]) {
            [self swapForMoveDown];
            [self setVisibilityAndFrame];
        }
        else if (isVerticalEndless && scrollView_.contentOffset.y > scrollViewHeight_ * 1.5) {
            
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x, scrollView_.contentOffset.y - scrollViewHeight_ );
            [self swapForMoveDown]; 
            currentViewController_.frame = CGRectMake(currentViewController_.frame.origin.x, 
                                                           currentViewController_.frame.origin.y - scrollViewHeight_, 
                                                           currentViewController_.frame.size.width, 
                                                           currentViewController_.frame.size.height);
            
            [self setVisibilityAndFrame];
        }
        
        if (!isVerticalEndless && ![self isViewControllerInsideVerticalViewRect:bottomViewController_]) {
            [self swapForMoveUp];
            [self setVisibilityAndFrame];
        }
        
        else if (isVerticalEndless && scrollView_.contentOffset.y < scrollViewHeight_ * 0.5) {
            
            scrollView_.contentOffset = CGPointMake(scrollView_.contentOffset.x, scrollView_.contentOffset.y + scrollViewHeight_ );
            [self swapForMoveUp];
            currentViewController_.frame = CGRectMake(currentViewController_.frame.origin.x, 
                                                           currentViewController_.frame.origin.y + scrollViewHeight_, 
                                                           currentViewController_.frame.size.width, 
                                                           currentViewController_.frame.size.height);
            
            
            
            [self setVisibilityAndFrame];
        }
    }
    
}

-(void) swapForMoveUp {
    int verticalPage = currentViewController_.verticalPageNumber;
    int horizontalPage = currentViewController_.horizontalPageNumber;
    
    //go to top, move bottom to top
    BNPageViewController *top = topViewController_;
    BNPageViewController *bottom = bottomViewController_;
    BNPageViewController *current = currentViewController_;
    
    currentViewController_ = top;
    topViewController_ = bottom;
    bottomViewController_ = current;
    
    if ((verticalPage = verticalPage -1) < 0) {
        verticalPage = [BNScrollViewDatasource numberOfVerticalPages] -1;
    }
    currentViewController_.verticalPageNumber = verticalPage;
    currentViewController_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveDown {
    int verticalPage = currentViewController_.verticalPageNumber;
    int horizontalPage = currentViewController_.horizontalPageNumber;
    
    //go to bottom, move top to bottom
    BNPageViewController *top = topViewController_;
    BNPageViewController *bottom = bottomViewController_;
    BNPageViewController *current = currentViewController_;
    
    currentViewController_ = bottom;
    topViewController_ = current;
    bottomViewController_ = top;
    
    if ((verticalPage = verticalPage +1) >= [BNScrollViewDatasource numberOfVerticalPages]) {
        verticalPage = 0;
    }
    
    currentViewController_.verticalPageNumber = verticalPage;
    currentViewController_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveLeft {
    int verticalPage = currentViewController_.verticalPageNumber;
    int horizontalPage = currentViewController_.horizontalPageNumber;
    
    BNPageViewController *prev = prevViewController_;
    BNPageViewController *next = nextViewController_;
    BNPageViewController *current = currentViewController_;
    
    currentViewController_ = prev;
    prevViewController_ = next;
    nextViewController_ = current;
    
    if ((horizontalPage = horizontalPage -1) < 0) {
        horizontalPage = [BNScrollViewDatasource numberOfHorizontalPages] -1;
    }
    currentViewController_.verticalPageNumber = verticalPage;
    currentViewController_.horizontalPageNumber = horizontalPage;
}

-(void) swapForMoveRight {
    int verticalPage = currentViewController_.verticalPageNumber;
    int horizontalPage = currentViewController_.horizontalPageNumber;
    
    BNPageViewController *prev = prevViewController_;
    BNPageViewController *next = nextViewController_;
    BNPageViewController *current = currentViewController_;
    
    nextViewController_ = prev;
    currentViewController_ = next;
    prevViewController_ = current;
    
    if ((horizontalPage = horizontalPage +1) >= [BNScrollViewDatasource numberOfHorizontalPages]) {
        horizontalPage = 0;
    }
    currentViewController_.verticalPageNumber = verticalPage;
    currentViewController_.horizontalPageNumber = horizontalPage;
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
    if ((int)scrollView_.contentOffset.x % (int) scrollViewWidth_ ==0) {
        canScrollViewBeginVerticalDragging_ = YES;
    }
    
    if ((int)scrollView_.contentOffset.y % (int) scrollViewHeight_ ==0) {
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
