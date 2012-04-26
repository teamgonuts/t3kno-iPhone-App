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

//definitions for filter tableview
#define _genreFiltersSection 0
#define _timeFiltersSection 1
#define _allRow 0
#define _dnbRow 1
#define _dubstepRow 2
#define _electroRow 3
#define _hardstyleRow 4
#define _houseRow 5
#define _tranceRow 6

@implementation CBHViewController
@synthesize logoImageView;
@synthesize scrollView;
@synthesize filterView;
@synthesize filterTableView;
@synthesize pageControl;
@synthesize rankingsView;
@synthesize rankingsTitle;
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
    
    //selecting the defualt rows in filter tableview
    NSIndexPath *allIndexPath = [[NSIndexPath alloc] init];
    allIndexPath = [NSIndexPath indexPathForRow:0 inSection:_genreFiltersSection];
    [filterTableView selectRowAtIndexPath:allIndexPath animated:false scrollPosition:nil];
    
    NSIndexPath *freshestIndexPath = [[NSIndexPath alloc] init];
    freshestIndexPath = [NSIndexPath indexPathForRow:0 inSection:_timeFiltersSection];
    [filterTableView selectRowAtIndexPath:freshestIndexPath animated:false scrollPosition:nil];


    
    //initializing views
    if (filterView == nil){
        UIView *temp = [[UIView alloc] init];
        filterView = temp;
    }
    if (rankingsView == nil){
        UIView *temp = [[UIView alloc] init];
        rankingsView = temp;
    }
    
    //placing views in scrollView
    //right view
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * 2; //set it to the right of the screen
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [filterView setFrame:frame];
    [self.scrollView addSubview:filterView];
    [filterView release];
    
    //center view
    frame.origin.x = self.scrollView.frame.size.width;
    [rankingsView setFrame:frame];
    [self.scrollView addSubview:rankingsView];
    [rankingsView release];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    [self scrollToMiddleView];
    
        
        
    
}

- (void)viewDidUnload
{
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
    [self setRankingsView:nil];
    [self setRankingsTitle:nil];
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
    [tableView release];
    [searchBar release];
    [scrollView release];
    [pageControl release];
    [filterView release];
    [filterTableView release];
    [logoImageView release];
    [searchButton release];
    [rankingsView release];
    [rankingsTitle release];
    [super dealloc];
    
}


#pragma mark -
#pragma mark Rankings View
//scrolls to the middle view
-(void)scrollToMiddleView{
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width; //scroll to middle
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

//if there is a song in the rankings that is open, close it
-(void)closeExpandedSong{
    bool debug = false;
    if(debug) NSLog(@"--about to delete row: %d", expandedRow);
    
    //change the closed cell's bg
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(expandedRow-1) inSection:0];
    SongCell *cell = (SongCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (debug) NSLog(@"about to change bgImage for cell with title: %@", cell.titleLabel.text);
    cell.bgImage.image = [UIImage imageNamed:@"songcell_bg5.png"];
    
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

#pragma mark -
#pragma mark Filter Table View

//method will set the new filters based on the filter tableview's selections
//method will also refresh the title and reload the rankings tableview
- (void) refreshFilters
{
    bool debug = false;
    NSArray *selectedRows = [filterTableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) 
    {
        UITableViewCell *cell = [filterTableView cellForRowAtIndexPath:indexPath];
        
       
        if (indexPath.section == _genreFiltersSection)
        {
            if ([cell.textLabel.text isEqualToString:@"Drum & Bass"])
                genreFilter = @"dnb";
            else
            {
                genreFilter = [cell.textLabel.text lowercaseString];
            }
            
        }
        else if (indexPath.section == _timeFiltersSection)
        {
            if (debug) NSLog(@"old timefilter: %@", timeFilter);
            if ([cell.textLabel.text isEqualToString:@"The Freshest"])
                timeFilter = @"new";
            else if ([cell.textLabel.text isEqualToString:@"Today's Best"])
                timeFilter = @"day";
            else if ([cell.textLabel.text isEqualToString:@"Top of the Week"])
                timeFilter = @"week";
            else if ([cell.textLabel.text isEqualToString:@"Top of the Month"])
                timeFilter = @"month";
            else if ([cell.textLabel.text isEqualToString:@"Top of the Year"])
                timeFilter = @"year";
            else if ([cell.textLabel.text isEqualToString:@"All Time Best"])
                timeFilter = @"century";
            else
                if (debug) NSLog(@"time filter selection not recognized");
            
            if (debug) NSLog(@"new timefilter: %@", timeFilter);

        }
        
        //ERROR ALERT
        //for some reason when the genre is 'all' sometimes the cell returns nil
        //the following line is a quick fix, investigate the reason
        if (cell == nil)
        {
            if (debug) NSLog(@"cell == nil");
            genreFilter = @"all";
        }
    }
    
    [self refreshTitle];
    [self loadTableView:nil];
}

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
    else if ([genre isEqualToString:@"dnb"]){
        genre = @"Drum & Bass";
    }
    
    //the fresh List is selected
    if ([genre isEqualToString:@"Tracks"] && 
        [time isEqualToString:@"new"]){
        rankingsTitle.text = @"The Fresh List";
    }
    //the freshest + genre
    else if ([time isEqualToString:@"new"]){
        rankingsTitle.text = [[NSString alloc] initWithFormat:@"The Freshest %@", genre];
    }
    else if ([time isEqualToString:@"day"])
        rankingsTitle.text = [[NSString alloc] initWithFormat:@"Today's Best %@", genre];
    else if ([time isEqualToString:@"century"])
        rankingsTitle.text = [[NSString alloc] initWithFormat:@"Best %@ of All Time", genre];
    //top top [genre] of the [time]
    else{
        rankingsTitle.text = [[NSString alloc] initWithFormat:@"Top %@ of the %@",
                              genre, time];
    }
    
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
        [self scrollToMiddleView];
        
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
    
    rankingsTitle.text = [[NSString alloc] initWithFormat:@"Searching: %@" , searchTerm];
    
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
    bool debug = false;
    if (debug) NSLog(@"modifying cell %d",indexPath.row);
    
    // =============================
    //         Rankings TableView
    // =============================
    if (songTableView == tableView){
        if (debug) NSLog(@"--tableView: tableView");
 
        NSUInteger row = [indexPath row];
        if (row == expandedRow){ //the expanded row, return the custom cell
            ExpandedSongCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"ExpandedSongCellIdentifier"];
            
            if(debug) NSLog(@"row == expandedRow"); 
            Song *tempSong = [songs objectAtIndex:(expandedRow - 1)];
            
            tempCell.scoreLabel.text = tempSong->score; //adding song score
            
            //embedding youtube video
            NSString *ytcode = tempSong->ytcode;
            NSString *playerHTML = [[NSString alloc] initWithFormat:@"<html><head> <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 88\"/></head><body style=\"background:#F00;margin-top:0px;margin-left:0px\"><div><object width=\"88\" height=\"60\"><param name=\"movie\" value=\"http://www.youtube.com/v/%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/%@\"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"88\" height=\"60\"></embed></object></div></body></html>", ytcode, ytcode];
            

            [tempCell.webView loadHTMLString:playerHTML baseURL:nil];
            
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
    // =============================
    //         Filter TableView
    // =============================
    else if (songTableView == filterTableView)
    {
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
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }
    else
    {
        if (debug) NSLog(@"--unknown tableView: returning nil");
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)songTableView
titleForHeaderInSection:(NSInteger)section
{
    if (songTableView == filterTableView)
    {
        return [filterKeys objectAtIndex:section];
    }
    else // no headers for rankings view
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)songTableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (songTableView == tableView)
    {
        if (expandedRow == [indexPath row])
            return 68.0; //same as ExpandedSongCell.xib
        else 
            return 44.0; //same as SongCell.xib
    }
    else if (songTableView == filterTableView)
    {
        return 30;
    }
}

- (void)tableView: (UITableView *)songTableView
willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(songTableView == filterTableView)
    {
        //if the selected row is already selected, return nil so it cannot be deselected
        NSArray *selectedRows = [filterTableView indexPathsForSelectedRows];
        for (NSIndexPath *selectedIndexPath in selectedRows) {
            if(selectedIndexPath == indexPath)
                return nil;
        }

    }
}

- (void)tableView: (UITableView *)songTableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
    bool debug = false;
    if (debug) NSLog(@"didSelectRowAtIndexPath called!");
    
    // =============================
    //         Rankings TableView
    // =============================    
    if(songTableView == tableView)
    {
        //if the cell clicked is the expanded row, do nothing
        if (indexPath.row == expandedRow)
            return;
        
        SongCell *cell = (SongCell *)[songTableView cellForRowAtIndexPath:indexPath];
        if (cell->expanded == NO)
        {
            if (debug) NSLog(@"row clicked: %d" , [indexPath row]);
            
            //get the correct index to place the new cell
            NSInteger atRow;
            if (expandedRow != -1 && expandedRow < [indexPath row]){ 
                //fix offset incase the row is below the expanded one
                atRow = [indexPath row];
                
            } else{
                atRow = [indexPath row] + 1;
            }
            if (debug) NSLog(@"Expanded row: %d", atRow);
            
            //if there is another cell open change it
            if (expandedRow != -1) [self closeExpandedSong];
            
            //change cell image
            cell.bgImage.image = [UIImage imageNamed:@"songcell_bg4_click.png"];
            cell->expanded = YES;
                        
            //add new cell below
            NSIndexPath *insertAt = [NSIndexPath indexPathForRow:atRow inSection:0];
            NSArray *rowArray = [[NSArray alloc] initWithObjects:insertAt, nil];
            
            expandedRow = atRow;
            
            [tableView insertRowsAtIndexPaths:rowArray withRowAnimation:UITableViewRowAnimationTop];
        }
        else 
        { //cell is already open, so close it
            cell->expanded = NO;
            
            if(debug) NSLog(@"--about to delete row: %d", expandedRow);
            [self closeExpandedSong];
        }
    }
    // =============================
    //         Filter TableView
    // =============================   
    else if (songTableView == filterTableView)
    {
        bool debug2 = false;
        NSArray *selectedRows = [filterTableView indexPathsForSelectedRows];
        
        
        if (debug2)
        {
            NSLog(@"selectedRows.count: %d", [selectedRows count]);
            NSIndexPath *one = [selectedRows objectAtIndex:0];
            NSIndexPath *two = [selectedRows objectAtIndex:1];
            NSIndexPath *three = [selectedRows objectAtIndex:2];
            
            NSLog(@"selectedRow[0].section: %d, .row: %d", one.section, one.row);
            NSLog(@"selectedRow[1].section: %d, .row: %d", two.section, two.row);
            NSLog(@"selectedRow[2].section: %d, .row: %d", three.section, three.row);
        }
        
        //there will always be 3 rows selected at this point
        //the last object in the array selectedRows is the newest one selected
        //the first two objects are the current selections, but can be in any order
        
        if (indexPath.section == _genreFiltersSection)
        {
            //======deselect current selection
            //finding the correct selected row to deselect
            NSIndexPath *temp = [selectedRows objectAtIndex:0];
            if (temp.section == _genreFiltersSection)
                [filterTableView deselectRowAtIndexPath:temp animated:false];
            else
                [filterTableView deselectRowAtIndexPath:[selectedRows objectAtIndex:1] animated:false];
            
        }
        else if (indexPath.section == _timeFiltersSection)
        {
            //deselect current selection
            NSIndexPath *temp = [selectedRows objectAtIndex:0];
            if (temp.section == _timeFiltersSection)
                [filterTableView deselectRowAtIndexPath:temp animated:false
                 ];
            else
                [filterTableView deselectRowAtIndexPath:[selectedRows objectAtIndex:1] animated:false];
        }
        
        //method will automatically refresh title and load new tableview as well
        [self refreshFilters];
    }

}


@end
