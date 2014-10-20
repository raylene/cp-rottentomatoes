//
//  MovieDetailViewController.m
//  rottenTomatoesDemo
//
//  Created by Raylene Yung on 10/13/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisText;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.movieData[@"title"];
    self.titleLabel.text = self.movieData[@"title"];
    self.synopsisText.text = self.movieData[@"synopsis"];

    self.scrollView.contentSize = CGSizeMake(320, 1000);

    // Low-res url
    NSString *thumbnailPosterString = [self.movieData valueForKeyPath:@"posters.thumbnail"];
    NSURL *thumbnailPosterURL = [NSURL URLWithString:thumbnailPosterString];
    // Get high-res image url hack
    NSURL *highResPosterURL = [NSURL URLWithString:[thumbnailPosterString stringByReplacingOccurrencesOfString:@"tmb"
                                         withString:@"ori"]];
    
    // Load high-res after loading the thumbnail
    // Hm, the second request doesn't seem to complete until I navigate away/back...
    /*
    [self.posterImageView setImageWithURLRequest:[NSURLRequest requestWithURL:thumbnailPosterURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"Success -- loaded thumbnail");
        [self.posterImageView setImage:image];
        
        [self.posterImageView setImageWithURLRequest:[NSURLRequest requestWithURL:highResPosterURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *highResImage) {
            NSLog(@"Success -- loaded high-res");
            [self.posterImageView setImage:highResImage];
        } failure:nil];
    } failure:nil];
    */

    // ^Is this better than just sending 2 requests to setImageWith URL?
    [self.posterImageView setImageWithURL:thumbnailPosterURL];
    [self.posterImageView setImageWithURL:highResPosterURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
