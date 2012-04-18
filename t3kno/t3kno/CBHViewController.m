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

@implementation CBHViewController
@synthesize logoImageView;
@synthesize scrollView;
@synthesize filterView;
@synthesize filterTableView;
@synthesize pageControl;
@synthesize tableTitle;
@synthesize tableView;
@synthesize searchBar;
@synthesize songs;
@synthesize receivedData;
@synthesize genreFilter;
@synthesize timeFilter;
@synthesize filterKeys;
@synthesize filterValues;

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
    [self loadTableView:nil];    
    
    //right frame
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
    

    /*
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * 2; //set it to the right of the screen
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    [subview setFrame:<#(CGRect)#>
    subview.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:subview];
    [subview release];
     */     
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height);
    
    pageControlBeingUsed = NO;
    

    /* PUTS IN FAKE HEADER"
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 61, scrollView.frame.size.width, 30)] autorelease];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.text = @"Header";
    tableView.tableHeaderView = lbl;
     */
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.filterKeys = nil;
    self.filterValues = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    [self refreshTitle];
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
    bool debug = true;
    if (debug) NSLog(@"SearchButtonPressed");
    //toggles the genrePicker hidden or visible
    if (searchBar.hidden == false){
        //hide searchBar
        [searchBar resignFirstResponder]; //close keyboard
        searchBar.hidden = true;
        
        //show the tableView
        tableView.hidden = false;
        logoImageView.hidden = false;
    }
    else{
        //hide the other views
        logoImageView.hidden = true;
        
        //show the searchBar and tableView
        searchBar.hidden = false;
        tableView.hidden = false;
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    bool debug = false;
    
    NSString *searchTerm = [searchBar text];
    
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
    bool debug = true;
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
        if (debug) NSLog(@"--TableView: rankings");
        return [self.songs count];
        
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
    if (songTableView == tableView){
        NSLog(@"loading tableView cell");
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
        cell.titleLabel.text = temp->title;
        cell.artistLabel.text = temp->artist;
        cell.genreLabel.text = temp->genre;
        cell.scoreLabel.text = temp->score;
    
        return cell;
    } else if (songTableView == filterTableView){ //tableView is FilterView
        if(debug) NSLog(@"loading filterView cell");
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
        return 44.0; //same as SongCell.xib
    }else if (songTableView == filterTableView){
        return 30;
    }else{
        return 1; //error, never get here
    }
}


- (void)tableView: (UITableView *)songTableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    //[cell setSelectedBackgroundView:clickedBackgroundView];
    //[cell setSelected:YES];
    
        
    if(songTableView == tableView){
        SongCell *cell = [songTableView cellForRowAtIndexPath:indexPath];
        if (cell->expanded == NO){
            //change cell image
            cell.bgImage.image = [UIImage imageNamed:@"tablecellbg_click.png"];
            cell->expanded = YES;
            
            //add new cell below
            
        }else { //cell is already open, so close it
            //change cell image
            cell.bgImage.image = [UIImage imageNamed:@"tablecellbg.png"];
            cell->expanded = NO;
            
            //remove expaned cell below
        }
        
        /*
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:2 inSection:0];
        [tableView insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexP, nil] 
                         withRowAnimation:UITableViewRowAnimationRight];
         */
        
    }
    
    
    
    
}


@end
