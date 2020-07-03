//
//  MentionsViewController.m
//  twitter
//
//  Created by dkaviani on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "MentionsViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>

@interface MentionsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchTimeline];
    // Do any additional setup after loading the view.
}

- (void) fetchTimeline {
    // Get timeline
    [[APIManager shared] getMentionsTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = (NSMutableArray *) tweets;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
}

// Tells us how many rows we need.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Creating and configured a cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Reuses old objects to preserve memory. Uses TweetCell Template.
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    cell.dateLabel.text = tweet.timeAgo;
    cell.likesLabel.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.repliesLabel.text = [NSString stringWithFormat:@"%i", tweet.replyCount];
    cell.bodyLabel.text = tweet.mediaText;
    NSLog(@"%@", tweet.text);
    cell.bodyLabel.userInteractionEnabled = YES;
    PatternTapResponder urlTapAction = ^(NSString *tappedString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tappedString]];
    };
    [cell.bodyLabel enableURLDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor cyanColor],NSUnderlineStyleAttributeName:[NSNumber
    numberWithInt:1],RLTapResponderAttributeName:urlTapAction}];
    cell.retweetsLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    if (tweet.favorited) {
        cell.favorButton.selected = YES;
    } else {
        cell.favorButton.selected = NO;
    }
    if (tweet.retweeted) {
        cell.retweetButton.selected = YES;
    } else {
        cell.retweetButton.selected = NO;
    }
    NSString *url = tweet.user.profileLink;
    NSURL *profileURL = [NSURL URLWithString:url];
    [cell.profileView setImageWithURL:profileURL];
    return cell;
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
