//
//  TweetViewController.m
//  twitter
//
//  Created by dkaviani on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateLabel.text = self.tweet.dateCreated;
    self.timeLabel.text = self.tweet.timeCreated;
    self.likesLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.bodyLabel.userInteractionEnabled = YES;
    PatternTapResponder urlTapAction = ^(NSString *tappedString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tappedString]];
    };
    [self.bodyLabel enableURLDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor cyanColor],NSUnderlineStyleAttributeName:[NSNumber
    numberWithInt:1],RLTapResponderAttributeName:urlTapAction}];
    self.bodyLabel.text = self.tweet.text;
    self.retweetsLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    if (self.tweet.favorited) {
        self.favorButton.selected = YES;
    } else {
        self.favorButton.selected = NO;
    }
    if (self.tweet.retweeted) {
        self.retweetButton.selected = YES;
    } else {
        self.retweetButton.selected = NO;
    }
    NSString *url = self.tweet.user.profileLink;
    NSURL *profileURL = [NSURL URLWithString:url];
    [self.profileView setImageWithURL:profileURL];
}

- (IBAction)didTapReply:(id)sender {
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
    }
    [self refreshRetweetData];
}
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    [self refreshFavoriteData];
}

- (void)refreshFavoriteData {
    self.likesLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    if (self.tweet.favorited) {
        self.favorButton.selected = YES;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        self.favorButton.selected = NO;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void)refreshRetweetData {
    self.retweetsLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    if (self.tweet.retweeted) {
        self.retweetButton.selected = YES;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        self.retweetButton.selected = NO;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
