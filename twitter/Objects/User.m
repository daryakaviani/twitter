//
//  User.m
//  twitter
//
//  Created by dkaviani on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// Initializing a dictionary that will be used for users, tweets, movies, etc.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = [@"@" stringByAppendingString:dictionary[@"screen_name"]];
        self.profileLink = dictionary[@"profile_image_url_https"];
        self.followers = [dictionary[@"followers_count"] intValue];
        self.following = [dictionary[@"friends_count"] intValue];
        self.bio = dictionary[@"description"];
    }
    return self;
}

@end
