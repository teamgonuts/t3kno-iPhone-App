//
//  ExpandedSongCell.h
//  t3kno
//
//  Created by Me on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface ExpandedSongCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSData *receivedData;
@property (strong, nonatomic) Song *song;

- (IBAction)upVote:(id)sender;
- (IBAction)downVote:(id)sender;
- (void)voteOnSong:(NSString *)voteValue;


@end
