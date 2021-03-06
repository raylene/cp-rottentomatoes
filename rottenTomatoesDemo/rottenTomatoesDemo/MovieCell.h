//
//  MovieCell.h
//  rottenTomatoesDemo
//
//  Created by Raylene Yung on 10/13/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end
