//
//  ProfileViewController.m
//  twitter
//
//  Created by dkaviani on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>
#import "APIManager.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.user == nil) {
        [[APIManager shared] userData:self.user completion:^(User *user, NSError *error){
            if(user) {
                [self setToMyProfile:user];
            } else {
                NSLog(@"Error!");
            }
        }];
    } else {
        [self setToMyProfile:self.user];
    }
}

- (void)setToMyProfile:(User *)user {
    self.nameLabel.text = user.name;
    self.usernameLabel.text = user.screenName;
    self.bioLabel.text = user.bio;
    self.usernameLabel.text = user.screenName;
    self.followingLabel.text = [NSString stringWithFormat:@"%i", user.following];
    self.followerLabel.text = [NSString stringWithFormat:@"%i", user.followers];
    NSString *url = user.profileLink;
    NSURL *profileURL = [NSURL URLWithString:url];
    [self.profileView setImageWithURL:profileURL];
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
