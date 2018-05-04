//
//  WeatherView.m
//  StatusBarMenu
//
//  Created by zhouqiang on 2018/5/2.
//  Copyright © 2018 Bluelich. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherRootClass.h"

@interface WeatherView ()
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *cityTextField;
@property (weak) IBOutlet NSTextField *descTextField;
@property (nonatomic,  copy) NSString *temperature;
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
@end

@implementation WeatherView

- (void)updateWithWeather:(WeatherRootClass *)weather completion:(void(^)(NSString *temperature,NSImage *icon))completion
{
    if (!weather) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *url = weather.weather.firstObject.icon;
        [self configImageViewWithURL:url completion:completion];
        self.cityTextField.stringValue = weather.name;
        switch (weather.thermometricScale) {
            case ThermometricScale_Celsius:
                self.temperature = [NSString stringWithFormat:@"%.1f℃",(weather.main.temp - 32.) / 1.8f];
                break;
            case ThermometricScale_Fahrenheit:
                self.temperature = [NSString stringWithFormat:@"%.1f℉",weather.main.temp];
                break;
        }
        self.descTextField.stringValue = [NSString stringWithFormat:@"Temp:%@\n\nWeather:%@",self.temperature,weather.weather.firstObject.descriptionField];
    });
}
- (void)configImageViewWithURL:(NSString *)url  completion:(void(^)(NSString *temperature,NSImage *icon))completion
{
    [self.dataTask cancel];
    self.dataTask = nil;
    __weak typeof(self) weakSelf = self;
    self.dataTask = [NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = self;
        if (error) {
            NSLog(@"error:%@",error);
            !completion ?: completion(strongSelf.temperature,[NSImage imageNamed:@"Image"]);
            return;
        }
        NSImage *image = [[NSImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.imageView.image = image;
            !completion ?: completion(strongSelf.temperature,image);
        });
    }];
    [self.dataTask resume];
}
@end
