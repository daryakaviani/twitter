//
//  User.h
//  twitter
//
//  Created by dkaviani on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImage+AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileLink;
@property (nonatomic) int followers;
@property (nonatomic) int following;
@property (nonatomic, strong) NSString *bio;
// Dictionary that will be used for tweets, movies, users, etc.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)usersWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
