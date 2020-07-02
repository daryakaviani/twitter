//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) User* user;
@end

@implementation TimelineViewController

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    self.user = user;
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchTimeline];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = (NSMutableArray *) tweets;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
    [self.refreshControl endRefreshing];
}


- (void)didTweet:(Tweet *)tweet {
    [self.tweets addObject:tweet];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.delegate = self;
    cell.tweet = tweet;
    cell.dateLabel.text = tweet.timeAgo;
    cell.likesLabel.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.repliesLabel.text = [NSString stringWithFormat:@"%i", tweet.replyCount];
    cell.bodyLabel.userInteractionEnabled = YES;
    PatternTapResponder urlTapAction = ^(NSString *tappedString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tappedString]];
    };
    [cell.bodyLabel enableURLDetectionWithAttributes:
    @{NSForegroundColorAttributeName:[UIColor cyanColor],NSUnderlineStyleAttributeName:[NSNumber
    numberWithInt:1],RLTapResponderAttributeName:urlTapAction}];
    cell.bodyLabel.text = tweet.text;
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Tweet *tweet = self.tweets[indexPath.row];
    NSLog(@"%@", tweet.user.name);
    if ([segue.identifier isEqualToString:@"toCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"toTweet"]) {
        TweetViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.tweet = tweet;
    } else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = self.user;
    }
}

@end
