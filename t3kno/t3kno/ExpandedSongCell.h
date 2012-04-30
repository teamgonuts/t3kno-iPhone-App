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

@property (retain, nonatomic) IBOutlet UIWebView *webView; ///<webview for embedded youtube song
@property (retain, nonatomic) IBOutlet UILabel *loadingLabel; ///<loading... text displayed before embedded song is loaded
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;///<label to display song's score
@property (strong, nonatomic) NSMutableData *receivedData; ///<received data for NSURLConnection
@property (strong, nonatomic) Song *song; ///<Song object associated with the cell

- (IBAction)upVote:(id)sender; ///<thumbs up button
- (IBAction)downVote:(id)sender;///<thumbs down button
- (void)voteOnSong:(NSString *)voteValue;///<calls t3k.no's api to submit vote


@end
