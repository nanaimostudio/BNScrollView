//
//  BNScrollViewDatasource.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNScrollView.h"
@interface BNScrollViewDatasource : NSObject<BNScrollViewDatasource> {
    int numberOfHorizontalPages;
    int numberOfVerticalPages;
}
@property (nonatomic, assign) int numberOfHorizontalPages;
@property (nonatomic, assign) int numberOfVerticalPages;
+(id)sharedInstance;
+(int)numberOfHorizontalPages;
+(int)numberOfVerticalPages;
@end
