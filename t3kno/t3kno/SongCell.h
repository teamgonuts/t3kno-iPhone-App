//
//  SongCell.h
//  t3kno
//
//  Created by Me on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *artistLabel;

@property (retain, nonatomic) IBOutlet UILabel *genreLabel;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;
@end