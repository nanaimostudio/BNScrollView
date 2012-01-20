//
//  SBPageViewController.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNPageViewController : UIView {
    int verticalPageNumber_;
    int horizontalPageNumber_;
    
    UILabel *pageLabel_;
}
@property (nonatomic, assign) int verticalPageNumber;
@property (nonatomic, assign) int horizontalPageNumber;
@property (nonatomic, retain) UILabel *pageLabel;

-(void) applyViewDataWithHorizontalPage:(int)hPage andVerticalPage:(int)vPage;
@end
