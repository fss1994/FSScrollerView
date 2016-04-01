//
//  FSScrollView.m
//  FSScrollerView
//
//  Created by 云无心 on 16/4/1.
//  Copyright © 2016年 云无心. All rights reserved.
//

#import "FSScrollView.h"
#import "UIImageView+AFNetworking.h"


@implementation FSScrollView

- (instancetype)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr{
    
    if ((self=[super initWithFrame:rect])) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count] - 1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
        imageArray = [NSArray arrayWithArray:tempArray];
        viewSize = rect;
        NSUInteger pageCount = [imageArray count]; // 图片张数
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        
        for (int i = 0; i < pageCount; i++) {
            NSString *imgURL = [imageArray objectAtIndex:i];
            UIImageView *imgView = [[UIImageView alloc] init];
            if ([imgURL hasPrefix:@"http://"]) {
                //网络图片 请使用afn异步图片库,或者sd_image
                [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[self ImageFromColor:[UIColor whiteColor]]];
                
                imgView.contentMode =  UIViewContentModeScaleAspectFill;
            }
            else
            {
                UIImage *img = [UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            [imgView setFrame:CGRectMake(viewSize.size.width * i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag = i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];
        
        //pageControl层
        float pagecontrolHeight = 20.0f;
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.origin.x,self.frame.size.height - pagecontrolHeight, viewSize.size.width, pagecontrolHeight)];
        pageControl.currentPage = 0;
        pageControl.numberOfPages = (pageCount - 2);
        [pageControl setPageIndicatorTintColor:[UIColor colorWithRed:256.f green:256.f blue:256.f alpha:0.6]]; // 设置颜色
        [self addSubview:pageControl];
        self.page = 1;
    }
    return self;
}

// 用颜色做一张占位图片,防止出现网址读取不到图
- (UIImage *)ImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 325, 150);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    pageControl.currentPage=(page - 1);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
    if (currentPageIndex==0) {
        [_scrollView setContentOffset:CGPointMake(([imageArray count] - 2) * viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count] -1)) {
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }
}
- (void)imagePressed:(UITapGestureRecognizer *)sender{
    if ([_delegate respondsToSelector:@selector(FSScrollviewDidClicked:)]) {
        [_delegate FSScrollviewDidClicked:sender.view.tag];
    }
}
- (void)runTimePage{
    if (self.page == imageArray.count - 2) {
        self.page = 0;
        [scrollView setContentOffset:CGPointMake((self.page + 1) * viewSize.size.width, 0) animated:NO];
    }
    [self performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    [scrollView setContentOffset:CGPointMake((self.page + 1) * viewSize.size.width, 0) animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:scrollView];
    self.page++;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self restartTimer];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pausedTimer];
}
- (void)restartTimer{
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        if (scrollView.contentOffset.x / viewSize.size.width < self.page) {
            self.page--;
        }
    }
}
- (void)pausedTimer{
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}


@end
