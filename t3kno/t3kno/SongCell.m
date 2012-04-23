//
//  SongCell.m
//  t3kno
//
//  Created by Me on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell
@synthesize titleLabel;
@synthesize artistLabel;
@synthesize bgImage;
@synthesize genreLabel;
@synthesize scoreLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        expanded = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
         
}

- (void)dealloc {
    [titleLabel release];
    [artistLabel release];
    [genreLabel release];
    [scoreLabel release];
    [bgImage release];
    [super dealloc];
}
@end
