//
//  BNScrollViewDatasource.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import "BNScrollViewDatasource.h"

@implementation BNScrollViewDatasource
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

+(int)numberOfHorizontalPages {
    return 4;
}

+(int)numberOfVerticalPages {
    return 4;
}
@end
