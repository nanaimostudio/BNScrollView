//
//  SBPageViewController.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNPageViewController.h"

@implementation BNPageViewController
@synthesize verticalPageNumber = verticalPageNumber_;
@synthesize horizontalPageNumber = horizontalPageNumber_;
@synthesize pageLabel = pageLabel_;

- (void)dealloc {
    [pageLabel_ release], pageLabel_ = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        pageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                               0, 
                                                               self.frame.size.width, 
                                                               self.frame.size.height)];
        pageLabel_.textAlignment = UITextAlignmentCenter;
        pageLabel_.text = @"Hello Boon";
        [self addSubview:pageLabel_];
    }
    return self;
}

-(void)applyViewDataWithHorizontalPage:(int)hPage andVerticalPage:(int)vPage {
    pageLabel_.text = [NSString stringWithFormat:@"Horizontal:%d, Vertical:%d",hPage,vPage];
}

@end
