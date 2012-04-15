//
//  CBHViewController.m
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CBHViewController.h"
#import "Song.h"
#import "SongCell.h"
#import "SBJson.h"

@implementation CBHViewController

@synthesize tableTitle;
@synthesize topOfToolbar;
@synthesize tableView;
@synthesize genrePicker;
@synthesize genrePickerData;
@synthesize songs;
@synthesize receivedData;
@synthesize genreFilter;
@synthesize timeFilter;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //genres
    NSArray *genres = [[NSArray alloc] initWithObjects:@"All", @"Drum & Base", 
                       @"Dubstep", @"Electro", @"Hardstyle", @"House", @"Trance", nil];
    genrePickerData = genres;
    
    //default filter = the fresh list
    genreFilter = @"all";
    timeFilter = @"new";
    
    songs = [[NSMutableArray alloc] init];
    [self loadTableView:nil];

    
        
    
}

- (void)viewDidUnload
{
    [self setTableTitle:nil];
    [self setSongs:nil];
    [self setTableView:nil];
    [self setGenrePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.genrePickerData = nil;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    genrePicker.hidden = true;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)loadTableView:(id)sender {
    bool debug = true;
    if (debug){
      NSLog(@"loadTableView called!");  
    }
    
    NSString *urlString = [[NSString alloc] 
                          initWithFormat:@"http://t3k.no/app/request_songs.php?genrefilter=%@&timefilter=%@",
                          genreFilter, timeFilter];
    
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
        NSLog(@"Connection to t3k.no/app/request_songs.php has failed");
    }
    
    if (debug){
        NSLog([[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    }
    

}

/*=========================**
    NSURLConnection Delegate
 *=========================*/

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    BOOL debug = true;
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    BOOL debug = false;
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    if(debug){
        NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    // release the connection, and the data object
    [connection release];
    [receivedData release];
    
    NSArray *songsArray = [jsonString JSONValue];
    
    for(NSDictionary *songDictionary in songsArray){
        [songs addObject:[[Song alloc] initWithDictionary:songDictionary]];
    }
    
    if(debug){
        NSLog(@"songs.length:%u, song, %@",[songs count], songs);
    }
    
    [tableView reloadData];
    
   }


/*=========================**
       Filter Controls
 *=========================*/

- (IBAction)openGenreOptions:(id)sender {
    //toggles the genrePicker hidden or visible
    if (genrePicker.hidden == false){
        //hide genrePicker
        genrePicker.hidden = true;
        
        //show the tableView
        tableView.hidden = false;
    }
    else{
        //hide the other views
        tableView.hidden   = true;
        
        //show the genrePicker
        genrePicker.hidden = false;
    }
}

- (IBAction)openTopOfOptions:(id)sender {
    if (topOfToolbar.hidden == false){
        topOfToolbar.hidden = true;
    }else{
        topOfToolbar.hidden = false;
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component{
    return [genrePickerData count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component{
    return [genrePickerData objectAtIndex:row];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)songTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SongCellIdentifier = @"SongCellIdentifier";
    static BOOL nibsRegistered = NO;
    if(!nibsRegistered){
        UINib *nib = [UINib nibWithNibName:@"SongCell" bundle:nil];
        [songTableView registerNib:nib forCellReuseIdentifier:SongCellIdentifier];
        nibsRegistered = YES;
    }
    
    SongCell *cell = [songTableView dequeueReusableCellWithIdentifier:SongCellIdentifier];
    
    NSUInteger row = [indexPath row];
    Song *temp = [songs objectAtIndex:row];
    NSLog(@"%@", temp->title);
    cell.titleLabel.text = temp->title;
    cell.artistLabel.text = temp->artist;
    cell.genreLabel.text = temp->genre;
    cell.scoreLabel.text = temp->score;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0; //same number as SongCell.xib
}
- (void)dealloc {
    [tableTitle release];
    [topOfToolbar release];
    [tableView release];
    [genrePicker release];
    [super dealloc];
}
@end
