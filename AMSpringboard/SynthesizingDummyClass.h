
#define SYNTHESIZE_DUMMY_CLASS(C) \
@interface Dummy_##C : NSObject \
@end \
@implementation Dummy_##C : NSObject \
@end
