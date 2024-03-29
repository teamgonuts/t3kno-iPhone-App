//
//  ExpandedSongCell.m
//  t3kno
//
//  Created by Me on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpandedSongCell.h"
#import "Song.h"
#import "NSString+MD5Addition.h"
#import "UIDevice+IdentifierAddition.h"

@implementation ExpandedSongCell
@synthesize webView;
@synthesize loadingLabel;
@synthesize scoreLabel;
@synthesize receivedData;
@synthesize song;


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

///thumbs up button pressed (touch up inside)
- (IBAction)upVote:(id)sender {
    bool debug = false;
    if (debug) NSLog(@"upVote clicked!");
    
    [self  voteOnSong:@"1"];
}

///thumbs down button pressed (touch up inside)
- (IBAction)downVote:(id)sender {
    bool debug = false;
    if (debug) NSLog(@"downVote clicked!");
    
    [self voteOnSong:@"-1"];
}

/**Calls t3k.no's api to submit song's vote. Checks if user has voted on the song before using the iPhone's mac address as a unique identifier. If the user has voted before, it allows the user to change their vote, but not cast the same vote again.
 */
-(void) voteOnSong:(NSString *)voteValue
{
    bool debug = false;
    
    //will be the same if the user deletes the app and reinstalls it
    //uses mac addresss
    NSString *uniqueID = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    
    //trimming strings of whitespaces
    NSString *ytcode = [song->ytcode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *user = [song->user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (debug)
    {
        NSLog(@"voteOnSong called! Parameters:");
        NSLog(@"--vote: %@", voteValue);
        NSLog(@"--ytcode: %@", ytcode);
        NSLog(@"--uniqueID: %@", uniqueID);
        NSLog(@"--user: %@", user);
    }
    
        
    NSString *urlString = [[NSString alloc] 
                           initWithFormat:@"http://t3k.no/app/vote.php?vote=%@&ytcode=%@&uid=%@&user=%@",
                           voteValue, ytcode, uniqueID, user];
    
    NSURL *urlToRequest = [NSURL URLWithString:urlString];
    
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:urlToRequest
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
        NSLog(@"Connection to t3k.no/app/vote.php has failed");
    }
    
    if (debug){
        NSLog(@"%@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    }

}

# pragma mark -
# pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    BOOL debug = false;
    if (debug){
        NSLog(@"didReceiveResponse called!");  
    }
    
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    bool debug = false;
    if (debug) NSLog(@"connection appending data!");
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

//receivedData will be the vote result (1 or -1)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    BOOL debug = false;
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    if(debug){
        NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    }
    
    NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    if(debug){
        NSLog(@"--result: %@", result);
        NSLog(@"--(int)result: %d", [result intValue]);
    }
    
    if ([receivedData length] > 0) //if the vote was valid
    {
        int newScore = [scoreLabel.text intValue] + [result intValue];
        
        scoreLabel.text = [[NSString alloc] initWithFormat:@"%d", newScore];
    }

    // release the connection, and the data object
    [connection release];
    [receivedData release];
    
    
}

@end
