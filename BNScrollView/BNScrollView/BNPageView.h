//
//  SBPageViewController.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNPageView : UIView {
    int verticalPageNumber_;
    int horizontalPageNumber_;
    
    UILabel *pageLabel_;
}
@property (nonatomic, assign) int verticalPageNumber;
@property (nonatomic, assign) int horizontalPageNumber;
@property (nonatomic, retain) UILabel *pageLabel;

-(void) applyViewDataWithHorizontalPage:(int)hPage andVerticalPage:(int)vPage;
@end
