#import <AppKit/AppKit.h>

@interface WeatherCoord : NSObject

@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lon;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end