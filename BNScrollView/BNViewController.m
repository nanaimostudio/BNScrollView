//
//  BNViewController.m
//  BNScrollView
//
//  Created by zitao xiong on 1/19/12.
//  Copyright (c) 2012 nanaimostudio.com. All rights reserved.
//

#import "BNViewController.h"
#import "BNScrollView.h"
#import "BNPageView.h"
#import "BNScrollViewDatasource.h"
@implementation BNViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (id)init {
    self = [super init];
    if (self) {
        self.tableView = [[[UITableView alloc] init] autorelease];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (CGSize)screenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        CGFloat screenTmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = screenTmp;
    }
    return CGSizeMake(screenWidth, screenHeight);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"BNID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"Test %d", indexPath.row + 1];
    NSString *contentString = nil;
    switch (indexPath.row) {
        case 0:
            contentString = @"Both Endless";
            break;
        case 1:
            contentString = @"Horizontal Endless";
            break;
        case 2:
            contentString = @"Vertical Endless";
            break;
        case 3:
            contentString = @"Both non-Endless";
            break;
        case 4:
            contentString = @"Test";
            break;
        default:
            break;
    }
    cell.textLabel.text = contentString;
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [self screenSize];
    switch (indexPath.row) {
        case 0: {
            UIViewController *viewController = [[UIViewController alloc] init];
            CGSize viewSize = CGSizeMake(200, 200);
            BNScrollView *scrollView = [[BNScrollView alloc] initWithFrame:CGRectMake(screenSize.width/2-viewSize.width/2., screenSize.height/2-viewSize.height/2, viewSize.width, viewSize.height)];
            scrollView.datasource = [BNScrollViewDatasource sharedInstance];
            scrollView.isVerticalEndless = YES;
            scrollView.isHorizontalEndless = YES;
            [scrollView buildBNScrollView];
            [viewController.view addSubview:scrollView];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            break;
        }
        
        case 1: {
            UIViewController *viewController = [[UIViewController alloc] init];
            CGSize viewSize = CGSizeMake(200, 200);
            BNScrollView *scrollView = [[BNScrollView alloc] initWithFrame:CGRectMake(screenSize.width/2-viewSize.width/2., screenSize.height/2-viewSize.height/2, viewSize.width, viewSize.height)];
            scrollView.datasource = [BNScrollViewDatasource sharedInstance];
            scrollView.isVerticalEndless = NO;
            scrollView.isHorizontalEndless = YES;
            [scrollView buildBNScrollView];
            [viewController.view addSubview:scrollView];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            break;
        }
            
        case 2: {
            UIViewController *viewController = [[UIViewController alloc] init];
            CGSize viewSize = CGSizeMake(200, 200);
            BNScrollView *scrollView = [[BNScrollView alloc] initWithFrame:CGRectMake(screenSize.width/2-viewSize.width/2., screenSize.height/2-viewSize.height/2, viewSize.width, viewSize.height)];
            scrollView.datasource = [BNScrollViewDatasource sharedInstance];
            scrollView.isVerticalEndless = YES;
            scrollView.isHorizontalEndless = NO;
            [scrollView buildBNScrollView];
            [viewController.view addSubview:scrollView];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            break;
        }
            
        case 3: {
            UIViewController *viewController = [[UIViewController alloc] init];
            CGSize viewSize = CGSizeMake(200, 200);
            BNScrollView *scrollView = [[BNScrollView alloc] initWithFrame:CGRectMake(screenSize.width/2-viewSize.width/2., screenSize.height/2-viewSize.height/2, viewSize.width, viewSize.height)];
            scrollView.datasource = [BNScrollViewDatasource sharedInstance];
            scrollView.isVerticalEndless = NO;
            scrollView.isHorizontalEndless = NO;
            [scrollView buildBNScrollView];
            [viewController.view addSubview:scrollView];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            break;
        }
        case 4: {
            UIViewController *viewController = [[UIViewController alloc] init];
            CGSize viewSize = CGSizeMake(200, 200);
            BNScrollView *scrollView = [[BNScrollView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
            scrollView.datasource = [BNScrollViewDatasource sharedInstance];
            scrollView.isVerticalEndless = NO;
            scrollView.isHorizontalEndless = NO;
            [scrollView buildBNScrollView];
            scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
            [viewController.view addSubview:scrollView];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
            break;
        }
        default:
            break;
    }
}
@end
