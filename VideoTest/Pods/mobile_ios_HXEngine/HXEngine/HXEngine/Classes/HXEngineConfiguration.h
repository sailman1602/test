//
//  HXEngineConfiguration.h
//  AFNetworking
//
//  Created by sh on 2018/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXEngineConfiguration : NSObject
+ (instancetype)sharedInstance ;

//UIView+HXShow.h 为单个项目设置loading的size backgroundColor cornerRadius等
@property (nonatomic, assign) BOOL toastSetting; //默认为NO,必须为YES才能生效
@property (nonatomic, strong) UIColor *contentColor; //菊花颜色
@property (nonatomic, strong) UIColor *bgColor; //
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, strong) UIColor *textColor; //
@property (nonatomic, strong) UIFont  *textFont;



- (void)ucardConfiguration;

@end

NS_ASSUME_NONNULL_END
