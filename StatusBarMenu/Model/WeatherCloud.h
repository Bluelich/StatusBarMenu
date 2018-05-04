#import <AppKit/AppKit.h>

@interface WeatherCloud : NSObject

@property (nonatomic, assign) NSInteger all;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end