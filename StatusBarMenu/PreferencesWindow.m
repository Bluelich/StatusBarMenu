//
//  PreferencesWindow.m
//  StatusBarMenu
//
//  Created by zhouqiang on 2018/5/3.
//  Copyright © 2018 Bluelich. All rights reserved.
//

#import "PreferencesWindow.h"

@interface PreferencesWindow ()
<
NSWindowDelegate,
NSTextFieldDelegate
>
@property (nonatomic,copy,readonly,class)NSString *cityKey;
@property (nonatomic,copy,readonly,class)NSString *thermometricScaleKey;
@property (weak) IBOutlet NSTextField *cityTextField;
@property (nonatomic,  copy) NSString *city;
@property (nonatomic,assign) ThermometricScale thermometricScale;
@property (weak) IBOutlet NSButton *celsiusRadioButton;
@property (weak) IBOutlet NSButton *fahrenheitRadioButton;
@end

@implementation PreferencesWindow
- (NSNibName)windowNibName
{
    return @"PreferencesWindow";
}
+ (NSString *)cityKey
{
    return @"city";
}
+ (NSString *)thermometricScaleKey
{
    return @"thermometric scale";
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *city = [NSUserDefaults.standardUserDefaults stringForKey:self.class.cityKey];
        if (!city) {
            city = @"Beijing";
        }
        _city = city;
        _thermometricScale = [NSUserDefaults.standardUserDefaults integerForKey:self.class.thermometricScaleKey];
    }
    return self;
}
- (void)setThermometricScale:(ThermometricScale)thermometricScale
{
    if (_thermometricScale == thermometricScale) {
        return;
    }
    _thermometricScale = thermometricScale;
    !self.didUpdateThermometricScale ?: self.didUpdateThermometricScale(_thermometricScale);
}
- (IBAction)tempButtonClicked:(NSButton *)sender
{
    if (sender == self.celsiusRadioButton) {
        self.thermometricScale = ThermometricScale_Celsius;
    }else if (sender == self.fahrenheitRadioButton){
        self.thermometricScale = ThermometricScale_Fahrenheit;
    }
}
- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window center];
    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    self.cityTextField.stringValue = _city;
    self.celsiusRadioButton.state = _thermometricScale == ThermometricScale_Celsius;
    self.fahrenheitRadioButton.state = _thermometricScale == ThermometricScale_Fahrenheit;
}
- (void)setCity:(NSString *)city
{
    NSLog(@"%s _city: %@ \tnew city:%@",__PRETTY_FUNCTION__,_city,city);
    if (!city) {
        return;
    }
    if ([ city isKindOfClass:NSString.class] &&  city.length > 0 &&
        [_city isKindOfClass:NSString.class] && _city.length > 0 &&
        [city isEqualToString:_city]) {
        return;
    }
    _city = city;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cityTextField.stringValue = self.city;
    });
    [NSUserDefaults.standardUserDefaults setObject:self.city forKey:self.class.cityKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    !self.didUpdateCity ?: self.didUpdateCity(self.city);
}
#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(insertNewline:) ||
        commandSelector == @selector(insertLineBreak:)||
        commandSelector == @selector(insertNewlineIgnoringFieldEditor:)) {
        if (NSApplication.sharedApplication.currentEvent.modifierFlags == NSEventModifierFlagShift) {
            printf("Shift-Enter detected.\n");
        }else{
            printf("Enter detected.\n");
        }
        NSLog(@"%s _city: %@ \tnew city:%@",__PRETTY_FUNCTION__,_city,textView.string);
        /*
         使用textView.string 就有问题啦...
         */
        self.city = self.cityTextField.stringValue;
        [self close];
        return YES;
    }
    return NO;
}
@end
