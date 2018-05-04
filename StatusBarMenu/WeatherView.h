//
//  WeatherView.h
//  StatusBarMenu
//
//  Created by zhouqiang on 2018/5/2.
//  Copyright © 2018 Bluelich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WeatherRootClass;
@interface WeatherView : NSView
- (void)updateWithWeather:(WeatherRootClass *)weather completion:(void(^)(NSString *temperature,NSImage *icon))completion;
@end
