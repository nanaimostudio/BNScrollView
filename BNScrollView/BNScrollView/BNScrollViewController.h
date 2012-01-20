//
//  BNScrollViewController.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNPageViewController.h"
typedef enum ScrollDirection {
    NONE = 0,
    RIGHT,
    LEFT,
    UP,
    DOWN,
}ScrollDirection;

typedef enum EnabledScrollDirection {
    EnabledScrollDirectionHorizontal = 1,
    EnabledScrollDirectionVertical = 2
}EnabledScrollDirection;

@interface BNScrollViewController : UIViewController <UIScrollViewDelegate, UINavigationControllerDelegate> {
    BNPageViewController *currentViewController_;
    BNPageViewController *nextViewController_;
    BNPageViewController *prevViewController_;
    BNPageViewController *topViewController_;
    BNPageViewController *bottomViewController_;

    CGPoint lastContentOffset_;

    int scrollViewWidth_;
    int scrollViewHeight_;
    
    ScrollDirection direction; 

    UIScrollView *scrollView_;
    
    BOOL canScrollViewBeginVerticalDragging_;
    BOOL canScrollViewBeginHorizontalDragging_;
    
    EnabledScrollDirection enabledDirection_;
    
    BOOL isHorizontalEndless;
    BOOL isVerticalEndless;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) EnabledScrollDirection enabledDirection;

- (id)initWithScrollViewWidth:(int)aScrollViewWidth scrollViewHeight:(int)aScrollViewHeight isHorizontalEndless:(BOOL)hEndless isVerticalEndLess:(BOOL)vEndless enabledScrollDirection:(EnabledScrollDirection) enabledDirection;
@end

@protocol BNScrollViewDatasource <NSObject>
@required
-(int)numberOfHorizontalPages;
-(int)numberOfVerticalPages;
@end



