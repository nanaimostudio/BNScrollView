//
//  BNScrollViewController.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNPageView.h"
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
    BNPageView *currentView_;
    BNPageView *rightView_;
    BNPageView *leftView_;
    BNPageView *topView_;
    BNPageView *bottomView_;

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

@protocol BNScrollPageView <NSObject>
-(void)applyViewDataWithHorizontalPage:(int)hPage andVerticalPage:(int)vPage;
@end

@protocol BNScrollViewDatasource <NSObject>
@required
-(int)numberOfHorizontalPages;
-(int)numberOfVerticalPages;
-(UIView<BNScrollPageView>*) resuableScrollPageView;
@end

