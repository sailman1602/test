//
//  downloadVideoVC.m
//  VideoTest
//
//  Created by YNZMK on 2019/4/13.
//  Copyright © 2019 YNZMK. All rights reserved.
//

#import "downloadVideoVC.h"
#import "ZZCircleProgress.h"
#import "PPNetworkHelper.h"
#import "memoryStoreManage.h"
#import "NELivePlayerVC.h"

@interface downloadVideoVC ()
@property (nonatomic,strong)ZZCircleProgress *progressView;
@property (nonatomic,strong)UIButton *downloadBtn;
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,assign)BOOL isDownloading;

@property (nonatomic, strong)NSString *path;
@end

@implementation downloadVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.downloadBtn = [UIButton newWithFont:HXFont(17) title:@"下载视频" textColor:UIColorFromRGB(0x3D3D3D) selectedTextColor:UIColorFromRGB(0x3D3D3D)];
    self.downloadBtn.layer.borderColor = HXThemeColor.CGColor;
    self.downloadBtn.layer.borderWidth = 2;
    [self.downloadBtn addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downloadBtn];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.centerX.centerY.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.playBtn = [UIButton newWithFont:HXFont(17) title:@"播放视频" textColor:UIColorFromRGB(0x3D3D3D) selectedTextColor:UIColorFromRGB(0x3D3D3D)];
    self.playBtn.layer.borderColor = HXThemeColor.CGColor;
    self.playBtn.layer.borderWidth = 2;
    [self.playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.downloadBtn.mas_bottom).offset(20);
    }];
    
    self.progressView = [[ZZCircleProgress alloc]initWithFrame:CGRectMake((kScreenWidth - 200)/2.0, 50, 200, 200) pathBackColor:[UIColor orangeColor] pathFillColor:[UIColor greenColor] startAngle:0.0 strokeWidth:3];
     self.progressView.increaseFromLast = YES;
    [self.view addSubview:self.progressView];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(200);
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(downloadBtn.mas_top).offset(-50);
//    }];
//    self.progressView.progress = arc4random()%101/100.0;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)download{
    static NSURLSessionTask *task = nil;
    //开始下载
    if(!self.isDownloading)
    {
        self.isDownloading = YES;
        [self.downloadBtn setTitle:@"取消下载" forState:UIControlStateNormal];

        NSString *downloadString = @"http://jdvodgasctbte.vod.126.net/jdvodgasctbte/dJYW8yDw_2449434264_sd.mp4?wsSecret=d17efd59c7b776fd6fa367f6b6a14ddf&wsTime=1555682106";

        task = [PPNetworkHelper downloadWithURL:downloadString fileDir:@"Download" progress:^(NSProgress *progress) {

            CGFloat stauts = 100.f * progress.completedUnitCount/progress.totalUnitCount;
            self.progressView.progress = stauts/100.f;
        } success:^(NSString *filePath) {

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载完成!"
                                                                message:[NSString stringWithFormat:@"文件路径:%@",filePath]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.downloadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
            [memoryStoreManage storeVideoPath:filePath url:downloadString];

        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.downloadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
        }];

    }
    //暂停下载
    else
    {
        self.isDownloading = NO;
        [task suspend];
        self.progressView.progress = 0;
        [self.downloadBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    }
    
}


- (void)play{

    NSArray *urlList = [memoryStoreManage getStoreVideoList];
    if (urlList.count) {
        NSString *firstPath = [memoryStoreManage getVideoPathFromUrl:urlList.lastObject];
        NSLog(@"%@",firstPath);
        NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
        [decodeParm addObject:@"software"]; //@"hardware";
        [decodeParm addObject:@"videoOnDemand"];
//        http://jdvodgasctbte.vod.126.net/jdvodgasctbte/a2884607-c250-4d47-b079-cedc2b079f71.mp4?wsSecret=954a12c6299e7d7dff1ea62622d6870c&wsTime=1555680302
        NELivePlayerVC *player = [[NELivePlayerVC alloc] initWithURL:[NSURL URLWithString:firstPath] andDecodeParm:decodeParm];
//        NELivePlayerVC *player = [[NELivePlayerVC alloc] initWithURL:[NSURL URLWithString:@"http://jdvodgasctbte.vod.126.net/jdvodgasctbte/a2884607-c250-4d47-b079-cedc2b079f71.mp4?wsSecret=954a12c6299e7d7dff1ea62622d6870c&wsTime=1555680302"] andDecodeParm:decodeParm];
        [self presentViewController:player animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
