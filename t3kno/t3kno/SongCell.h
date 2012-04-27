//
//  SongCell.h
//  t3kno
//
//  Created by Me on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongCell : UITableViewCell{
    @public
    bool expanded;
}
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *artistLabel;

@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UILabel *genreLabel;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;

@end
