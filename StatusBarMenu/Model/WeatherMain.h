#import <AppKit/AppKit.h>

@interface WeatherMain : NSObject

@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger pressure;
@property (nonatomic, assign) CGFloat temp;
@property (nonatomic, assign) NSInteger tempMax;
@property (nonatomic, assign) CGFloat tempMin;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end