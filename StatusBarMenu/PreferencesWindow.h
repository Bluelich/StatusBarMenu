//
//  PreferencesWindow.h
//  StatusBarMenu
//
//  Created by zhouqiang on 2018/5/3.
//  Copyright © 2018 Bluelich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WeatherRootClass.h"

@interface PreferencesWindow : NSWindowController
@property (nonatomic,  copy) void(^didUpdateCity)(NSString *city);
@property (nonatomic,  copy) void(^didUpdateThermometricScale)(ThermometricScale thermometricScale);
@property (nonatomic,  copy,readonly) NSString *city;
@property (nonatomic,assign,readonly) ThermometricScale thermometricScale;
@end
