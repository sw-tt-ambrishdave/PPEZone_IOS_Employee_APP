

#import <Foundation/Foundation.h>

@class User;

@interface Post : NSObject

@property (nonatomic, assign) NSUInteger postID;
@property (nonatomic, strong) NSString *text;

//@property (nonatomic, strong) User *user;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
