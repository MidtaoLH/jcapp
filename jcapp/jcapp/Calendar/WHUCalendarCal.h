

#import <Foundation/Foundation.h>

@interface WHUCalendarCal : NSObject
-(NSDictionary*)calendarMapWith:(NSDate*)date;
-(NSDictionary*)getPreCalendarMap:(NSString*)dateStr;
-(NSDictionary*)getNextCalendarMap:(NSString*)dateStr;
-(NSDictionary*)getCalendarMapWith:(NSString*)dateStr;
-(NSDate*)dateFromString:(NSString*)dateString;
-(NSString*)currentDateStr;
-(void)preMonthCalendar:(NSString*)dateStr complete:(void(^)(NSDictionary*))completionBlk;
-(void)nextMonthCalendar:(NSString*)dateStr complete:(void(^)(NSDictionary*))completionBlk;
-(void)getCalendarMapWith:(NSString*)dateStr completion:(void(^)(NSDictionary* dic))completeBlk;
-(NSString*)stringFromDate:(NSDate*)date;
-(NSDictionary*)loadDataWith:(NSString*)dateStr;
-(NSString*)stringFromTimeStamp:(NSInteger)timeStamp;
-(NSDateComponents*)componentOfDate:(NSDate*)date;
-(NSDate*)dateFromMonthString:(NSString*)dateStr;
@property(nonatomic,strong) dispatch_queue_t workQueue;
@end
