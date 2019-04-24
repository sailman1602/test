//
//  HXDropDownView.h
//  newHfax
//
//  Created by lly on 2018/2/5.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXDropDownView;




@protocol HXDropDownViewDelegate <NSObject>

@optional

- (void)dropdownMenuWillShow:(HXDropDownView *)menu;    // 当下拉菜单将要显示时调用
- (void)dropdownMenuDidShow:(HXDropDownView *)menu;     // 当下拉菜单已经显示时调用
- (void)dropdownMenuWillHidden:(HXDropDownView *)menu;  // 当下拉菜单将要收起时调用
- (void)dropdownMenuDidHidden:(HXDropDownView *)menu;   // 当下拉菜单已经收起时调用

- (void)dropdownMenu:(HXDropDownView *)menu selectedCellNumber:(NSInteger)number; // 当选择某个选项时调用

@end




@interface HXDropDownView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton * mainBtn;  // 主按钮 可以自定义样式 可在.m文件中修改默认的一些属性

@property (nonatomic, assign) id <HXDropDownViewDelegate>delegate;

@property (nonatomic,copy,readonly) NSArray  *titleArr;    // 选项数组

@property (nonatomic, assign) BOOL isShowDropDown;

- (void)setMenuTitles:(NSArray *)titlesArr seletedIcon:(NSString *)seletedIcon rowHeight:(CGFloat)rowHeight;  // 设置下拉菜单控件样式

- (void)showDropDown; // 显示下拉菜单
- (void)hideDropDown; // 隐藏下拉菜单

@end
