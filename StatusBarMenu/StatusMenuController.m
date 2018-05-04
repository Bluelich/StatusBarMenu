//
//  StatusMenuController.m
//  StatusBarMenu
//
//  Created by zhouqiang on 2018/5/2.
//  Copyright © 2018 Bluelich. All rights reserved.
//

#import "StatusMenuController.h"
#import <Cocoa/Cocoa.h>
#import "WeatherAPI.h"
#import "WeatherView.h"
#import "PreferencesWindow.h"

@interface StatusMenuController ()
@property (weak) IBOutlet NSMenu *statusMenu;
@property (nonatomic,strong) NSStatusItem  *statusItem;
@property (weak) IBOutlet WeatherView *weatherView;
@property (weak) IBOutlet NSMenuItem *weatherItem;
@property (weak) IBOutlet NSMenuItem *agentItem;
@property (nonatomic,strong) PreferencesWindow *preferencesWindow;
@property (nonatomic,assign) BOOL isAgent;
@property (nonatomic,strong) WeatherRootClass *weatherInfo;
@end

@implementation StatusMenuController
- (void)awakeFromNib
{
    NSImage *icon = [NSImage imageNamed:@"Image"];
    icon.template = YES;
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.title = @"WeatherBar";
    self.statusItem.title = nil;
    self.statusItem.image = icon;
    self.statusItem.menu = self.statusMenu;
    self.weatherItem.view = self.weatherView;
    self.preferencesWindow = [PreferencesWindow new];
    __weak typeof(self) weakSelf = self;
    [self.preferencesWindow setDidUpdateCity:^(NSString *city) {
        [weakSelf updateWeather];
    }];
    [self.preferencesWindow setDidUpdateThermometricScale:^(ThermometricScale thermometricScale) {
        weakSelf.weatherInfo.thermometricScale = thermometricScale;
        [weakSelf.weatherView updateWithWeather:weakSelf.weatherInfo completion:^(NSString *temperature, NSImage *icon) {
            weakSelf.statusItem.title = temperature;
            weakSelf.statusItem.image = icon;
        }];;
    }];
    NSDictionary<NSString *, id> *infoDictionary = NSBundle.mainBundle.infoDictionary;
    NSNumber *number = [infoDictionary objectForKey:@"LSUIElement"];
    self.isAgent = number.boolValue;
    [self updateWeather];
}
- (void)setIsAgent:(BOOL)isAgent
{
    _isAgent = isAgent;
    NSColor *titleColor = _isAgent ? NSColor.blackColor : NSColor.lightGrayColor;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Agent" attributes:@{NSForegroundColorAttributeName:titleColor}];
    self.agentItem.attributedTitle = attributedString;
}
- (void)updateWeather
{
    __weak typeof(self) weakSelf = self;
    [WeatherAPI fetchWeather:self.preferencesWindow.city
                  completion:^(WeatherRootClass *weather, NSError *error) {
        weather.thermometricScale = weakSelf.preferencesWindow.thermometricScale;
        weakSelf.weatherInfo = weather;
        [weakSelf.weatherView updateWithWeather:weather completion:^(NSString *temperature, NSImage *icon) {
            weakSelf.statusItem.title = temperature;
            weakSelf.statusItem.image = icon;
        }];;
    }];
}
- (IBAction)agentClicked:(NSMenuItem *)sender
{
    NSLog(@"");
    ProcessSerialNumber psn = {
        .highLongOfPSN = 0,
        .lowLongOfPSN = kCurrentProcess
    };
    self.isAgent = !self.isAgent;
    ProcessApplicationTransformState agentState = kProcessTransformToUIElementApplication;
//    agentState = kProcessTransformToBackgroundApplication;
    ProcessApplicationTransformState state = self.isAgent ? agentState : kProcessTransformToForegroundApplication;
    /*
     Foreground -> Background
     如果当前程序处于最前,则程序会先隐藏,然后把另一个程序置于最前,可调用SetFrontProcess()前置窗口
     (UIElement | Background) -> Foreground
     如果当前程序处于(任何方式导致的)隐藏状态,将不会被置于最前或显示出来,可调用ShowHideProcess() 显隐窗口
     */
    OSStatus status = TransformProcessType(&psn, state);
    return;
    if (status == noErr) {
        NSLog(@"");
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    OSErr err = SetFrontProcess(&psn);
    if (err == noErr) {
        if (!self.isAgent) {
            err = ShowHideProcess(&psn, true);
#pragma clang diagnostic pop
            if (err == noErr) {
                NSLog(@"");
            }
        }
    }
}
- (IBAction)preferencesClicked:(NSMenuItem *)sender
{
    [self.preferencesWindow showWindow:nil];
}
- (IBAction)update:(NSMenuItem *)sender
{
    [self updateWeather];
}
- (IBAction)quit:(NSMenuItem *)sender
{
    [NSApplication.sharedApplication terminate:self];
}
@end
