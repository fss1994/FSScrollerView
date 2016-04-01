# FSScrollerView


##1 一步生成
    FSScrollView *scroll = [[FSScrollView alloc] initWithFrameRect:_fscrollView.bounds ImageArray:array];
    scroll.delegate = self;
    
##2 图片使用异步库下载

    [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:XXX.png]];
    
##3 点击图片使用代理方法

    - (void)FSScrollviewDidClicked:(NSUInteger)index
