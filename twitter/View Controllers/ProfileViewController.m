//
//  ProfileViewController.m
//  twitter
//
//  Created by dkaviani on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>

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
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = self.user.screenName;
    self.bioLabel.text = self.user.bio;
    self.usernameLabel.text = self.user.screenName;
    self.followingLabel.text = [NSString stringWithFormat:@"%i", self.user.following];
    self.followerLabel.text = [NSString stringWithFormat:@"%i", self.user.followers];
    NSString *url = self.user.profileLink;
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
