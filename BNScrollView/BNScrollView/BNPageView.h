//
//  SBPageViewController.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNScrollView.h"

@interface BNPageView : UIView<BNScrollPageView> {
    int verticalPageNumber_;
    int horizontalPageNumber_;
    
    UILabel *pageLabel_;
}
@property (nonatomic, assign) int verticalPageNumber;
@property (nonatomic, assign) int horizontalPageNumber;
@property (nonatomic, retain) UILabel *pageLabel;
@end
