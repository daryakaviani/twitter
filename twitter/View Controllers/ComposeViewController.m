//
//  ComposeViewController.m
//  twitter
//
//  Created by dkaviani on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *characterCount;
@property (weak, nonatomic) IBOutlet UITextView *tweetBody;
@end

@implementation ComposeViewController
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)postTweet:(id)sender {
    [[APIManager shared]postStatusWithText:self.tweetBody.text completion:^(Tweet *tweet, NSError *error) {
    if(error){
        NSLog(@"Error composing Tweet: %@", error.localizedDescription);
    }
    else{
        [self.delegate didTweet:tweet];
        [self dismissViewControllerAnimated:true completion:nil];
        NSLog(@"Compose Tweet Success!");
    }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetBody.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.characterCount.text = [NSString stringWithFormat:@"%lu", 280 - self.tweetBody.text.length];
    return self.tweetBody.text.length + (text.length - range.length) <= 280;
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
