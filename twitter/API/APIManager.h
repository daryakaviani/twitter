//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

// Note to self: You don’t need to make any changes to this, but as you want to support other API requests to get a users timeline, favorite a tweet, retweet, add a function for each API request.
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

@end
