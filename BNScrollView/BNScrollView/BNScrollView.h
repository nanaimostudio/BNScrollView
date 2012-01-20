//
//  BNScrollViewController.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@protocol BNScrollPageView;
@protocol BNScrollViewDatasource;

@interface BNScrollView : UIScrollView <UIScrollViewDelegate> {

    UIView<BNScrollPageView> *currentView_;
    UIView<BNScrollPageView> *rightView_;
    UIView<BNScrollPageView> *leftView_;
    UIView<BNScrollPageView> *topView_;
    UIView<BNScrollPageView> *bottomView_;
    
    CGPoint lastContentOffset_;

    int scrollViewWidth_;
    int scrollViewHeight_;
    
    ScrollDirection direction; 
    
    BOOL canScrollViewBeginVerticalDragging_;
    BOOL canScrollViewBeginHorizontalDragging_;
    
    EnabledScrollDirection enabledDirection_; //only used for minimized memory usage, behavier is controlled by datasource
    
    BOOL isHorizontalEndless;
    BOOL isVerticalEndless;
    
    NSObject<BNScrollViewDatasource> *datasource_;
}

@property (nonatomic, assign) EnabledScrollDirection enabledDirection;
@property (nonatomic, assign) NSObject<BNScrollViewDatasource> *datasource;
@property (nonatomic, assign, getter=isHorizontalEndless) BOOL isHorizontalEndless;
@property (nonatomic, assign, getter=isVerticalEndless) BOOL isVerticalEndless;

- (void)buildBNScrollView;
@end

@protocol BNScrollPageView <NSObject>
@required
-(void)applyViewDataWithHorizontalPage:(int)hPage andVerticalPage:(int)vPage;
@property (nonatomic, assign) int verticalPageNumber;
@property (nonatomic, assign) int horizontalPageNumber;
@end

@protocol BNScrollViewDatasource <NSObject>
@required
-(int)numberOfHorizontalPages;
-(int)numberOfVerticalPages;
-(UIView<BNScrollPageView>*) resuableScrollPageViewInScrollView:(BNScrollView*) scrollView ;
@end