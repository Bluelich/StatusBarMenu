#import <AppKit/AppKit.h>

@interface WeatherWind : NSObject

@property (nonatomic, assign) NSInteger deg;
@property (nonatomic, assign) CGFloat speed;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end