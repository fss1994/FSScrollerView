//
//  ViewController.m
//  FSScrollerView
//
//  Created by 云无心 on 16/4/1.
//  Copyright © 2016年 云无心. All rights reserved.
//

#import "ViewController.h"
#import "FSScrollView.h"

@interface ViewController () <FSScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *fscrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *array = @[@"http://hs.tgbus.com/db/images/z_t_js/z_t_jk_js/common_217.png",
                       @"http://img40.nipic.com/20121018/11166539_093602295184_1.jpg",
                       @"http://pic24.nipic.com/20121018/11166539_094027415125_2.jpg",
                       
                       ];

    FSScrollView *scroll = [[FSScrollView alloc] initWithFrameRect:_fscrollView.bounds ImageArray:array];
    scroll.delegate = self;
    [_fscrollView addSubview:scroll];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)FSScrollviewDidClicked:(NSUInteger)index{
    
    NSLog(@"%lu",(unsigned long)index);
}

@end
