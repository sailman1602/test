//
//  HXBaseTableViewCell.h
//  newHfax
//
//  Created by lly on 2017/10/12.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HXTableViewCell : UITableViewCell

/**** super property***
@property (nonatomic) UITableViewCellAccessoryType    accessoryType;
 *****/

@property (nonatomic,strong) UIFont *defaultTextFont;//默认 HXFont(13);
@property (nonatomic, strong) UIFont *defaultDetailtextFont; //默认 HXFont(12);
//SeparatorLine
@property (nonatomic,strong) UIView *separatorLine;

@property (nonatomic,assign) BOOL showSeparator;//默认显示YES
@property (nonatomic,assign) CGFloat separatorLeft;//默认15
@property (nonatomic,assign) CGFloat separatorRight;//默认0
@property (nonatomic,assign) CGFloat separatorHeight;//默认1
@property (nonatomic,strong) UIColor *separatorColor;//默认 [UIColor phc_lightGray];;


/*life cycle*/
- (void)initDefault;
- (void)setupUI;//初始化UI控件
- (void)configureConstraints;//UI约束布局
- (void)bindModel:(id)model;//更新数据

@end

/*静态cell，没有数据请求的可以用这个*/
@interface HXTableViewStaticCell : HXTableViewCell

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UIImageView *rightImageView;

@end
