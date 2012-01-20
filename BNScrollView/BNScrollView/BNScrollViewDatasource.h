//
//  BNScrollViewDatasource.h
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNScrollViewDatasource : NSObject {
    
}
+(id)sharedInstance;
+(int)numberOfHorizontalPages;
+(int)numberOfVerticalPages;
@end
