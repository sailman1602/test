//
//  HXRefreshHeader.h
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

#define StoreRefreshContentKey @"StoreRefreshContentKey"

@interface HXRefreshHeader : MJRefreshHeader

@property(nonatomic,assign)BOOL isNewRefreshHeaderType;
@property(nonatomic,assign)BOOL isShowTextLabel;
@property(nonatomic,assign)CGFloat extraAddHeight;//额外需要增加的高度，适配iphoneX

- (void)endHeaderRefresh;

@end
