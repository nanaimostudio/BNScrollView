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
    cell.textLabel.text = [NSString stringWithFormat:@"Test %d", indexPath.row + 1];
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int pageWidth = 0;
    int pageHeight = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        pageWidth = 320;
        pageHeight = 480-44;
    }
    else {
        pageWidth = 768;
        pageHeight = 200-44;
    }
    switch (indexPath.row) {
        case 0: {
            UIViewController *viewController = [[UIViewController alloc] init];
            BNScrollView *scrollView = [[BNScrollView alloc] initWithFrame:CGRectMake(0, 700, 400, 100)];
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

            break;
        }
            
        case 2: {

            break;
        }
            
        case 3: {

            break;
        }
        default:
            break;
    }
}
@end
