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
#import "YoutubeView.h"
#import "ExpandedSongCell.h"

@implementation CBHViewController
@synthesize logoImageView;
@synthesize scrollView;
@synthesize filterView;
@synthesize filterTableView;
@synthesize pageControl;
@synthesize tableTitle;
@synthesize tableView;
@synthesize searchBar;
@synthesize searchButton;
@synthesize songs;
@synthesize receivedData;
@synthesize genreFilter;
@synthesize timeFilter;
@synthesize filterKeys;
@synthesize filterValues;
@synthesize tableViewCells;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// loading up the filter table
    NSString *path = [[NSBundle mainBundle] pathForResource:@"filter" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.filterValues = dict;
    NSArray *array = [filterValues allKeys];
    self.filterKeys = array;
    
    //default filter = the fresh list
    genreFilter = @"all";
    timeFilter = @"new";
    songs = [[NSMutableArray alloc] init];
    pageControlBeingUsed = NO;
    expandedRow = -1; //default = there is no expanded row

    
    //creating the scrollview & frame
    if (filterView == nil){
        UIView *temp = [[UIView alloc] init];
        filterView = temp;
    }
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width; //set it to the right of the screen
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [filterView setFrame:frame];
    [self.scrollView addSubview:filterView];
    [filterView release];
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    
    //testing
    filterTableView.allowsMultipleSelection = true;
        
    
}

- (void)viewDidUnload
{
    [self setTableTitle:nil];
    [self setSongs:nil];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setFilterView:nil];

    [self setFilterTableView:nil];
    [self setSearchButton:nil];
    [self setLogoImageView:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.filterKeys = nil;
    self.filterValues = nil;
    self.tableViewCells = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTableView:nil];    

    //hiding pickers/search bar
    searchBar.hidden = true;
    


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

- (void)dealloc {
    [tableTitle release];
    [tableView release];
    [searchBar release];
    [scrollView release];
    [pageControl release];
    [filterView release];
    [filterTableView release];
    [logoImageView release];
    [searchButton release];
    [super dealloc];
    
}

#pragma mark -
#pragma mark Load Embedded Player
- (void) playSong:(NSString *)ytcode{
    BOOL debug = false;
    if(debug){
        NSLog(@"playSong()!");
    }
    YoutubeView *youTubeView = [[YoutubeView alloc] 
                                initWithStringAsURL:@"http://www.youtube.com/watch?v=gczw0WRmHQU" 
                                frame:CGRectMake(0, 280, 320, 136)];
    
    [[self view] addSubview:youTubeView];
    
    //opens window in safari
    //[[UIApplication sharedApplication] 
     //openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=gczw0WRmHQU"]];
    if(debug){
        NSLog(@"playSong() ended!");
    }
}

#pragma mark -
#pragma mark Rankings View

//if there is a song in the rankings that is open, close it
-(void)closeExpandedSong{
    bool debug = false;
    if(debug) NSLog(@"--about to delete row: %d", expandedRow);
    
    //change the closed cell's bg
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(expandedRow-1) inSection:0];
    SongCell *cell = (SongCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (debug) NSLog(@"about to change bgImage for cell with title: %@", cell.titleLabel.text);
    cell.bgImage.image = [UIImage imageNamed:@"tablecellbg.png"];
    
    //remove the expandedRow
    if (expandedRow != -1){ //if there is a row open
        NSIndexPath *removeAt = [NSIndexPath indexPathForRow:expandedRow inSection:0];
        NSArray *rowArray = [[NSArray alloc] initWithObjects:removeAt, nil];
    
        expandedRow = -1;
        [tableView deleteRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
    }
}


- (IBAction)loadTableView:(id)sender {
    bool debug = false;
    if (debug){
        
        NSLog(@"loadTableView called!");  
        NSLog(@"  Genre: %@", genreFilter);
        NSLog(@"  Time: %@", timeFilter);
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
    
    [searchBar setHidden:true];
    //[self refreshTitle];
}

/*================================**
    PageControl/ScrollView Delegate
 *================================*/
#pragma mark -
#pragma mark Page Control and ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    bool debug = false;
    if(debug){
        NSLog(@"scrollViewDidScroll called!");
    }
    
    if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}


-(IBAction)changePage:(id)sender{
    // update the scroll view to the appropriate page
    bool debug = false;
    if(debug){
        NSLog(@"changePage called!");
    }
    
    // Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
    
}


/*=========================**
    NSURLConnection Delegate
 *=========================*/
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
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSDictionary *songDictionary in songsArray){
        [temp addObject:[[Song alloc] initWithDictionary:songDictionary]];
    }
    songs = temp;
    
    static NSString *SongCellIdentifier = @"SongCellIdentifier";
    static BOOL nibsRegistered = NO;
    if(!nibsRegistered){
        UINib *nib = [UINib nibWithNibName:@"SongCell" bundle:nil];
        UINib *nib2 = [UINib nibWithNibName:@"ExpandedSongCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:SongCellIdentifier];
        [tableView registerNib:nib2 forCellReuseIdentifier:@"ExpandedSongCellIdentifier"];
        nibsRegistered = YES;
    }
    
    NSMutableArray *cellArray = [[NSMutableArray alloc] init];
    for (Song *song in songs) {
        SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:SongCellIdentifier];
        cell.scoreLabel.text = song->score;
        cell.genreLabel.text = song->genre;
        cell.titleLabel.text = song->title;
        cell.artistLabel.text = song->artist;
        [cellArray addObject:cell];
    }
    tableViewCells = cellArray;
    
    if(debug){
        NSLog(@"songs.length:%u, song, %@",[songs count], songs);
    }
    
    [tableView reloadData];
    
   }



/*=========================**
        Filter Controls
 *=========================*/
- (NSString *) refreshTitle{
    bool debug = false;
    if (debug){
        NSLog(@"refreshTitle()!");
        NSLog(@"  Genre: %@", genreFilter);
        NSLog(@"  Time: %@", timeFilter);
    }
    
    NSString *genre = genreFilter;
    NSString *time = timeFilter;
    
    if ([genre isEqualToString:@"all"]){
        genre = @"Tracks";
    }
    else if ([genre isEqualToString:@"DnB"]){
        genre = @"Drum & Bass";
    }
    
    //the fresh List is selected
    if ([genre isEqualToString:@"Tracks"] && 
        [time isEqualToString:@"new"]){
        tableTitle.text = @"The Fresh List";
    }
    //the freshest + genre
    else if ([time isEqualToString:@"new"]){
        tableTitle.text = [[NSString alloc] initWithFormat:@"The Freshest %@", genre];
    }
    //top top [genre] of the [time]
    else{
        tableTitle.text = [[NSString alloc] initWithFormat:@"Top %@ of the %@",
                           genre, time];
    }
    
}




#pragma -
#pragma mark Search Bar Delegate Methods


- (IBAction)seachButtonIconPressed:(id)sender {
    bool debug = false;
    if (debug) NSLog(@"SearchButtonPressed");
    //toggles the genrePicker hidden or visible
    if (searchBar.hidden == false){ //hide the searchBar
        //hide searchBar
        [searchBar resignFirstResponder]; //close keyboard
        searchBar.hidden = true;
        
        //show the tableView
        tableView.hidden = false;
        logoImageView.hidden = false;
    }
    else{//show the search bar
        //hide the logo
        logoImageView.hidden = true;
        
        //scroll to the rankings
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        [self.scrollView scrollRectToVisible:frame animated:YES];
        
        //show the searchBar and tableView
        searchBar.hidden = false;
        tableView.hidden = false;
        
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    bool debug = false;
    
    NSString *searchTerm = [aSearchBar text];
    
    if (debug){
        NSLog(@"Searched: %@", searchTerm);
    }
    
    tableTitle.text = [[NSString alloc] initWithFormat:@"Searching: %@" , searchTerm];
    
    NSString *urlString = [[NSString alloc] 
                           initWithFormat:@"http://t3k.no/app/search.php?searchTerm=%@&",
                           searchTerm];
    
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
        NSLog(@"Connection to t3k.no/app/search.php has failed");
    }
    
    if (debug){
        NSLog([[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
    }
    
    [searchBar setHidden:true];
    [searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text  = @"";
    [self seachButtonIconPressed:nil];
}


#pragma mark -
#pragma mark Table View Data Source Methods


- (NSInteger) numberOfSectionsInTableView:(UITableView *)songTableView{
    bool debug = false;
    if (debug) NSLog(@"numberOfSectionsInTable Called!");
    if (songTableView == tableView){//tableView
        if (debug) NSLog(@"--TableView: rankings");
        return 1;
    }else if (songTableView == filterTableView){
        if (debug) NSLog(@"--TableView: filter");
        return [filterKeys count];
    }
    else{
        if (debug) NSLog(@"--Unknown tableview");
        return -1;
    }
}

- (NSInteger)tableView:(UITableView *)songTableView
 numberOfRowsInSection:(NSInteger)section{
    bool debug = false;
    if (debug) NSLog(@"numberOfRowsInSection Called!");
    if(songTableView == tableView)
    {
        if (debug) {
            NSLog(@"--TableView: rankings");
            NSLog(@"expanded row: %d", expandedRow);
            NSLog(@"songs.count: %d", [songs count]);
        }
        
        if (expandedRow == -1) 
            return [self.songs count];
        else //one row is expanded, so there is +1
            return ([self.songs count]+1);
        
    }else if(songTableView == filterTableView){ //its the filter tableView
        if (debug) NSLog(@"--TableView: filter");
        if (debug) NSLog(@"--section: %d", section);
        NSString *key = [filterKeys objectAtIndex:section];
        NSArray *filterSection = [filterValues objectForKey:key];
        return [filterSection count];
    }
    else{
        if (debug) NSLog(@"--unknown tableview called, returning -1");
        return -1;
    }
        
    
}

- (UITableViewCell *)tableView:(UITableView *)songTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"modifying cell %d",indexPath.row);
    bool debug = false;
    if (songTableView == tableView){
        if (debug) NSLog(@"--tableView: tableView");
 
        NSUInteger row = [indexPath row];
        if (row == expandedRow){ //the expanded row, return the custom cell
            ExpandedSongCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"ExpandedSongCellIdentifier"];
            if(debug) NSLog(@"row == expandedRow"); 
            NSString *playerHTML = @"<html><head>\
                                    <body style=\"margin:0\">\
                                    <embed id=\"yt\" src=\"http://www.youtube.com/watch?v=oN86d0CdgHQ\" type=\"application/x-shockwave-flash\" width=\"50\" height=\"50\"></embed>\
                                    </body></html>";

            UIWebView *player = [[UIWebView alloc] init];
            [player loadHTMLString:playerHTML baseURL:nil];
            
            tempCell.webView = player;
            return tempCell;
        }
        else if (expandedRow != -1 && row > expandedRow)
            row--;
        
        if(debug){
            NSLog(@"row: %d", row);
            NSLog(@"expandedRow: %d", expandedRow);
        }
        UITableViewCell *cell = [tableViewCells objectAtIndex:row];
        return cell;
    } 
    else if (songTableView == filterTableView){ //tableView is FilterView
        if(debug) NSLog(@"--tableView: filterTableView");
        NSUInteger section = [indexPath section];
        NSUInteger row = [indexPath row];
        
        NSString *key = [filterKeys objectAtIndex:section];
        if(debug) NSLog(@"key: %@", key);
        NSArray *filterSection = [filterValues objectForKey:key];
        if(debug) NSLog(@"section: %@" , filterSection);
        
        static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
        UITableViewCell *cell = [songTableView 
                                 dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault 
                    reuseIdentifier:SectionsTableIdentifier];
        }
        
        cell.textLabel.text = [filterSection objectAtIndex:row];
        cell.textColor = [UIColor whiteColor];
        return cell;
    }
    else{
        if (debug) NSLog(@"--unknown tableView: returning nil");
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)songTableView
titleForHeaderInSection:(NSInteger)section{
    if (songTableView == tableView){
        //todo: call refresh title
        return @"The Fresh List";
    }
    else if (songTableView == filterTableView){
        return [filterKeys objectAtIndex:section];
    }
    else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)songTableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (songTableView == tableView){
        if (expandedRow == [indexPath row])
            return 86.0; //same as ExpandedSongCell.xib
        else 
            return 44.0; //same as SongCell.xib
    }else if (songTableView == filterTableView){
        return 30;
    }
}


- (void)tableView: (UITableView *)songTableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    bool debug = false;
    if (debug) NSLog(@"didSelectRowAtIndexPath called!");
    //todo: if the user selects expanded cell, doesn't do anything
    if(songTableView == tableView){
        SongCell *cell = (SongCell *)[songTableView cellForRowAtIndexPath:indexPath];
        if (cell->expanded == NO){
            if (debug) NSLog(@"row clicked: %d" , [indexPath row]);
            //get the correct index to place the new cell
            NSInteger atRow;
            if (expandedRow != -1 && expandedRow < [indexPath row]){ 
                //fix offset incase the row is below the expanded one
                atRow = [indexPath row];
                
            } else{
                atRow = [indexPath row] + 1;
            }
            
            //if there is another cell open change it
            if (expandedRow != -1) [self closeExpandedSong];
            //TODO: the next row doesn't open if there is already an expanding song
            
            //change cell image
            cell.bgImage.image = [UIImage imageNamed:@"tablecellbg_click.png"];
            cell->expanded = YES;
                        
            //add new cell below
            NSIndexPath *insertAt = [NSIndexPath indexPathForRow:atRow inSection:0];
            NSArray *rowArray = [[NSArray alloc] initWithObjects:insertAt, nil];
            
            if (debug) NSLog(@"Expanded row: %d", atRow);
            expandedRow = atRow;
            
            [tableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
                        
            
        }else { //cell is already open, so close it
            cell->expanded = NO;
            
            if(debug) NSLog(@"--about to delete row: %d", expandedRow);
            [self closeExpandedSong];
        }
    }
}


@end
