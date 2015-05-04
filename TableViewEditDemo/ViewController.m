//
//  ViewController.m
//  TableViewEditDemo
//
//  Created by iwind on 15/5/4.
//  Copyright (c) 2015年 HanYang. All rights reserved.
//

#import "ViewController.h"
#import "SWTableViewCell.h"
#import "Cell_test.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic, strong) UITableView * tv;
@property (nonatomic, strong) NSMutableArray * arr;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) Cell_test * prototypeCell;

@end

static NSString * cellIdentifier = @"swTableViewCell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr = [NSMutableArray arrayWithObjects:@"1",@"2",@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",@"4",@"5", nil];
    [self createUI];
    
}

- (void)createUI
{
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.view addSubview:self.tv];
    [self.tv registerNib:[UINib nibWithNibName:@"Cell_test" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.flag = YES;
}


- (void)editAction:(UIBarButtonItem * )item
{
    self.flag = !self.flag;
    if (self.flag == YES) {
        item.title = @"编辑";
    }else{
        item.title = @"完成";
    }
//    NSLog(@"进入编辑模式");
//    if (self.tv.editing == NO) {
//        [self.tv setEditing:YES animated:YES];
//    }else if (self.tv.editing == YES){
//        [self.tv setEditing:NO animated:YES];
//    }
    [self.tv reloadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell_test * cell = [self.tv dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtons];
    cell.content.backgroundColor = [UIColor lightGrayColor];
    cell.contentView.backgroundColor = [UIColor redColor];
    cell.content.text = self.arr[indexPath.row];
    
    return cell;
    
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (self.flag == YES) {
        [rightUtilityButtons removeAllObjects];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"设为默认"];
    }else{
        [rightUtilityButtons removeAllObjects];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"编辑"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"删除"];

    }
    
    
    return rightUtilityButtons;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"编辑");
            break;
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tv indexPathForCell:cell];
            
            [self.arr removeObjectAtIndex:cellIndexPath.row];
            [self.tv deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

@end
