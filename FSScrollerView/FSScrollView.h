//
//  FSScrollView.h
//  FSScrollerView
//
//  Created by 云无心 on 16/4/1.
//  Copyright © 2016年 云无心. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSScrollViewDelegate <NSObject>

@optional
- (void)FSScrollviewDidClicked:(NSUInteger)index;

@end


@interface FSScrollView : UIView <UIScrollViewDelegate> {

    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    UIPageControl *pageControl;
    int currentPageIndex;

}

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic,retain) id<FSScrollViewDelegate> delegate;
@property (nonatomic,assign) NSInteger page;

-(instancetype)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr;

@end

