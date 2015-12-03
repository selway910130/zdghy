
#import "ScrollTabBar.h"
#import "AppDelegate.h"

@implementation ScrollTabBar

@synthesize scrollTabBarDelegate;
@synthesize tabBars;
@synthesize old_tag;

// creat a scrollable tab bar
- (id)initWithItems:(NSArray *)items {
    old_tag = 0;
    // tab bar
    if (IS_IPHONE5) self = [super initWithFrame:CGRectMake(0.0, 499.0, 320.0, 49.0)];
	else self = [super initWithFrame:CGRectMake(0.0, 411.0, 320.0, 49.0)];
    
    tabBars = [[NSMutableArray alloc]init];
    if (self) {
		self.pagingEnabled = NO;
        self.delegate = self;
		float x = 0.0;
        float y = 0.0;
        
        // creat a scrollable tab bar which is put together by mulit tab bar
        for (double d = 0; d < ceil(items.count / 5.0); d ++) {
            if (items.count >= 5 * (d + 1)){
                y = 320.0;
            }
            else
            {
                y = (items.count - (5 * d)) * (320 / 5);
            }
			UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(x, 0.0, y, 49.0)];
			tabBar.delegate = self;
			
			int len = 0;
			
			for (int i = d * 5; i < d * 5 + 5; i ++)
				if (i < items.count)
					len ++;
			
			tabBar.items = [items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(d * 5, len)]];
            
            //Custom tab bar color and indicator image
			tabBar.selectedImageTintColor = [UIColor lightGrayColor];
            UIImage *imageTabBar = [UIImage imageNamed:@"menu_move_bg.gif"];
            [tabBar setSelectionIndicatorImage:imageTabBar];
            
            
			[self addSubview:tabBar];
			[tabBars addObject:tabBar];
			x += 320.0;
            y += 320.0;
		}
		self.contentSize = CGSizeMake(y, 49.0);
        
        // make the default view to be the first one
        UITabBar *defaultTabBar = [tabBars objectAtIndex:0];
        [defaultTabBar setSelectedItem:[items objectAtIndex:0]];
	}
    return self;
}

// make all the tabbars in array to act like one tabbar
- (void)tabBar:(UITabBar *)cTabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == old_tag) {
        return;
    }
	for (UITabBar *tabBar in self.tabBars){
		if (tabBar != cTabBar){
            tabBar.selectedItem = nil;
        }
    }
    old_tag = item.tag;
    // select view
    [scrollTabBarDelegate scrollTabBar:self didSelectItemWithTag:item.tag];
}

// show arrow
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int position = self.contentOffset.x;
    NSLog(@"position %d", position);

    if (position < 64 && position > 0) {
        NSLog(@"show arrow");
        [scrollTabBarDelegate showLeftArrow];
        [scrollTabBarDelegate showRightArrow];
    }
    else if (position == 64){
        NSLog(@"dismiss");
        [scrollTabBarDelegate showLeftArrow];
        [scrollTabBarDelegate dismissRightArrow];
    }
    else{
        [scrollTabBarDelegate showRightArrow];
        [scrollTabBarDelegate dismissLeftArrow];
    }
}
@end

