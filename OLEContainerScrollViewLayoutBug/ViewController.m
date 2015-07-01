//
//  ViewController.m
//  OLEContainerScrollViewLayoutBug
//
//  Created by Максим Павлов on 01.07.15.
//  Copyright (c) 2015 Maxim Pavlov. All rights reserved.
//

#import "ViewController.h"
#import "OLEContainerScrollView.h"

@interface TextCell : UITableViewCell

@end

@implementation TextCell

@end

static NSString *const TopTableViewCellIdentifier = @"TopTableViewCellIdentifier";
static NSString *const BottomTableViewCellIdentifier = @"BottomTableViewCellIdentifier";

static NSInteger const kNumberOfRows = 20;

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) OLEContainerScrollView *containerScrollView;
@property (nonatomic) UITableView *topTableView;
@property (nonatomic) UITableView *bottomTableView;
@property (nonatomic) BOOL didDeleteRows;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.topTableView.delegate = self;
    self.topTableView.dataSource = self;
    self.bottomTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.bottomTableView.dataSource = self;
    self.bottomTableView.delegate = self;
    
    [self.topTableView registerClass:[TextCell class] forCellReuseIdentifier:TopTableViewCellIdentifier];
    [self.bottomTableView registerClass:[TextCell class] forCellReuseIdentifier:BottomTableViewCellIdentifier];
    
    self.containerScrollView = [[OLEContainerScrollView alloc] init];
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView.contentView addSubview:self.topTableView];
    [self.containerScrollView.contentView addSubview:self.bottomTableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.containerScrollView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bottomTableView) {
        return self.didDeleteRows ? kNumberOfRows - 1 : kNumberOfRows;
    }
    
    return kNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:TopTableViewCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"TopTableView";
        return cell;
    }

    TextCell *cell = [tableView dequeueReusableCellWithIdentifier:BottomTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = (indexPath.row == kNumberOfRows - 1) ? @"Tap me to demonstrate issue" : @"BottomTableView";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return tableView == self.topTableView ? @"TopTableView" : @"BottomTableView";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.bottomTableView && indexPath.row == kNumberOfRows - 1) {
        self.didDeleteRows = YES;
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:kNumberOfRows - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
