//
//  MoviesViewController.m
//  rottenTomatoesDemo
//
//  Created by Raylene Yung on 10/13/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UITabBar *movieTypeTabBar;

@property (weak, nonatomic) IBOutlet UITabBarItem *movieTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *dvdTabBarItem;
@property (weak, nonatomic) UITabBarItem *selectedTabBarItem;


- (void)setupTabBar;
- (void)setupNetworkErrorView;
- (void)setupMovieTableView;
- (void)loadMovieData;
- (void)loadDVDData;

@end

@implementation MoviesViewController

NSString *const RottenTomatoesAPIKey = @"gd6zknyveccx6wbrxx6pkxe6";

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self setupTabBar];
    [self setupNetworkErrorView];
    [self setupMovieTableView];
    [self loadMovieData];
    
    // Setup refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)setupTabBar {
    NSLog(@"setupTabBar");
    self.movieTypeTabBar.delegate = self;
    [self.movieTypeTabBar setTintColor:[UIColor yellowColor]];
    [self.movieTypeTabBar setSelectedItem:self.movieTabBarItem];
    self.selectedTabBarItem = self.movieTabBarItem;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (self.selectedTabBarItem == item) {
        // Do nothing!
        return;
    }
    self.selectedTabBarItem = item;
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    if (item == self.movieTabBarItem) {
        NSLog(@"MOVIES");
        [self loadMovieData];
    } else if (item == self.dvdTabBarItem) {
        NSLog(@"DVDS");
        [self loadDVDData];
    }
}

- (void)setupNetworkErrorView {
    NSLog(@"setupNetworkErrorView");
    [self.networkErrorView setHidden:YES];
}

- (void)setupMovieTableView {
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    self.moviesTableView.rowHeight = 118;
    
    // Create reusable cell -- nib name must match .xib filename
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
}

- (void)loadMovieData {
    self.title = @"Movies";
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=gd6zknyveccx6wbrxx6pkxe6&limit=30&country=us"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // Show error if request fails
        NSLog(@"connection error:%@", connectionError);
        if (connectionError) {
            [self.networkErrorView setHidden:FALSE];
            
        } else if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
            self.movies = responseDictionary[@"movies"];
            //NSLog(@"movies response: %@", self.movies);
        
            // Triggers refresh of table info
            [self.moviesTableView reloadData];
        }

        // Clear/stop any active loading indicators
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadDVDData {
    self.title = @"DVDs";
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/current_releases.json?apikey=gd6zknyveccx6wbrxx6pkxe6&limit=30&country=us"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // Show error if request fails
        NSLog(@"connection error:%@", connectionError);
        if (connectionError) {
            [self.networkErrorView setHidden:FALSE];
        } else if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.movies = responseDictionary[@"movies"];
            // Triggers refresh of table info
            [self.moviesTableView reloadData];
        }
        
        // Clear/stop any active loading indicators
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"num movies: %ld", self.movies.count);
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    // Needs UIImageView+AFNetworking
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movieData = self.movies[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// For UIRefreshControl
- (void)onRefresh {
    NSLog(@"onRefresh!");
    [self.networkErrorView setHidden:TRUE];
    if (self.selectedTabBarItem == self.movieTabBarItem) {
        [self loadMovieData];
    } else if (self.selectedTabBarItem == self.dvdTabBarItem) {
        [self loadDVDData];
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
