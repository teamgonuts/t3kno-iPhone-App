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
    bool expanded; ///<if the song has an expanded cell attached to it
}
@property (retain, nonatomic) IBOutlet UILabel *titleLabel; ///<UILabel for song's title

@property (retain, nonatomic) IBOutlet UILabel *artistLabel;///<UILabel for song's artist

@property (retain, nonatomic) IBOutlet UIImageView *bgImage;///<custon bg image for SongCell
@property (retain, nonatomic) IBOutlet UILabel *genreLabel;///<UILabel for song's genre
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;///<UILabel for song's score

@end
