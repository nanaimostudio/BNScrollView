//
//  BNScrollViewDatasource.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import "BNScrollViewDatasource.h"
#import "BNPageView.h"
@implementation BNScrollViewDatasource
@synthesize numberOfHorizontalPages;
@synthesize numberOfVerticalPages;

+ (id)sharedInstance
{
	static id manager = nil;
	
	@synchronized(self)
	{
    if (manager == nil)
        manager = [[self alloc] init];
	}
	
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        numberOfHorizontalPages = 2;
        numberOfVerticalPages = 2;
    }
    return self;
}
+(int)numberOfHorizontalPages {
    return [[BNScrollViewDatasource sharedInstance] numberOfHorizontalPages];
}

+(int)numberOfVerticalPages {
    return [[BNScrollViewDatasource sharedInstance] numberOfVerticalPages];
}

-(UIView<BNScrollPageView> *)resuableScrollPageViewInScrollView:(BNScrollView *)scrollView {
    return [[[BNPageView alloc] initWithFrame:scrollView.frame] autorelease];
}

-(void)scrollView:(BNScrollView *)scrollView applyDataOn:(UIView<BNScrollPageView> *)view withHorizontalPage:(int)hPage withVerticalPage:(int)vPage {
    ((BNPageView*)view).pageLabel.text = [NSString stringWithFormat:@"%d:Horizontal, Vertical:%d",hPage,vPage];
}
@end
