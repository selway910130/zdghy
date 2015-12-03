//
//  ImageViewController.m
//  test
//
//  Created by selway on 2013-07-22.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ImageViewController.h"
#import "SVProgressHUD.h"

@interface ImageViewController ()

@property NSInteger maxPage;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.sendImageLst);
    
    pageControl.numberOfPages = [self.sendImageLst count];
    
    self.maxPage = 0;
    [SVProgressHUD showWithStatus:@"图片载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingImage) toTarget:self withObject:nil];
    
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake([self.sendImageLst count] * self.view.frame.size.width, self.view.frame.size.height - 36);
    
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:singleTap];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

    //[self dismissModalViewControllerAnimated:YES];
}

- (void)updatePager
{
    pageControl.currentPage = floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (floorf(scrollView.contentOffset.x / scrollView.frame.size.width) <= self.maxPage) {
        return;
    }
    else{
        self.maxPage = floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
        [SVProgressHUD showWithStatus:@"图片载入中"];
        [NSThread detachNewThreadSelector:@selector(loadingImage) toTarget:self withObject:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

- (void)loadingImage{
    NSLog(@"image id = %d", [self.sendImageLst[self.maxPage] intValue]);
    NSString *tempURL = [[NSString alloc]initWithFormat:@"http://192.168.0.56:8088/zdghy/oa02/oa0202/downloadFile?fileId=%@&thumbImage=1", self.sendImageLst[self.maxPage]];
    UIImage *image;
    image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempURL]]];
    if (image == nil){
        [SVProgressHUD dismissWithError:@"图片加载失败"];
        [NSThread exit];
        return;
    }

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.maxPage * 320, (self.view.frame.size.height - (320 * image.size.height)/image.size.width)/2, 320, (320 * image.size.height)/image.size.width)];
    imageView.image = image;
    [scrollView addSubview:imageView];
    [SVProgressHUD dismiss];
    [NSThread exit];
}
- (void)viewDidUnload {
    pageControl = nil;
    [super viewDidUnload];
}
@end
