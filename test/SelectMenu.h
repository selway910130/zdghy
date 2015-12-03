//
//  SelectMenu.h
//  test
//
//  Created by selway on 2013-07-15.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectMenuDelegate;

@interface SelectMenu : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *selectMenuTable;
@property (nonatomic,assign) id<SelectMenuDelegate> SelectMenuDelegate;
- (id)initWithItems:(NSArray *)items :(NSString *)key :(NSString *)typeOfButton;
- (void)show;
- (void)dismiss;

@end

@protocol SelectMenuDelegate <NSObject>
- (void)dismissDarkenView;
- (void)selectedItem:(NSDictionary *)item :(NSString *)typeOfButton;
@end

