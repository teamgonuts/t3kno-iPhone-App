//
//  ExpandedSongCell.m
//  t3kno
//
//  Created by Me on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpandedSongCell.h"

@implementation ExpandedSongCell
@synthesize webView;
@synthesize loadingLabel;
@synthesize scoreLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [webView release];
    [loadingLabel release];
    [scoreLabel release];
    [super dealloc];
}
- (IBAction)upVote:(id)sender {
    bool debug = true;
    NSString *uniqueID = [[UIDevice currentDevice] uniqueIdentifier];
    if (debug) NSLog(@"uniqueID: %@", uniqueID);
}

- (IBAction)downVote:(id)sender {
}
@end
