

#import "WHUCalendarItem.h"

@implementation WHUCalendarItem
-(BOOL)isEqual:(WHUCalendarItem*)object{
    return [object.dateStr isEqualToString:self.dateStr];
}

-(NSUInteger) hash{
    return [_dateStr hash];
}
@end
