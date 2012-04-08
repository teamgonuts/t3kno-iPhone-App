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

@implementation CBHViewController

@synthesize tableTitle;
@synthesize topOfToolbar;
@synthesize songs;

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
    topOfToolbar.hidden = true;
    
    
    //Temporary Array of Sample Songs
    Song *song1;
    song1 = [[Song alloc] initWithTitle:@"Molly" 
                              andArtist:@"Cedric Gervais"
                               andGenre:@"House" 
                               andScore:@"3"];
    Song *song2;
    song2 = [[Song alloc] initWithTitle:@"Strobe Lights Say My Name"        andArtist:@"Kap Slap" andGenre:@"DnB" andScore:@"2"];
    Song *song3;
    song3 = [[Song alloc] initWithTitle:@"Take Me Over" andArtist:@"Manufactured Superstars" andGenre:@"House" andScore:@"-1"];
    Song *song4;
    song4 = [[Song alloc] initWithTitle:@"Ecstasy" andArtist:@"ATB"
             andGenre:@"Trance" andScore:@"7"];
    Song *song5;
    song5 = [[Song alloc] initWithTitle:@"Shotgun" andArtist:@"Zedd"
             andGenre:@"House" andScore:@"1"];
    Song *song6;
    song6 = [[Song alloc] initWithTitle:@"Lights" andArtist:@"Klaypex"
             andGenre:@"Dubstep" andScore:@"5"];
    Song *song7;
    song7 = [[Song alloc] initWithTitle:@"Ghosts n Stuff" 
                              andArtist:@"Deadmau5"
             andGenre:@"House" andScore:@"69"];
    Song *song8;
    song8 = [[Song alloc] initWithTitle:@"Funky Vodka" andArtist:@"TJR"
             andGenre:@"House" andScore:@"-4"];
    Song *song9;
    song9 = [[Song alloc] initWithTitle:@"Falling" andArtist:@"Starkillers"
             andGenre:@"Electro" andScore:@"6"];
    Song *song10;
    song10 = [[Song alloc] initWithTitle:@"Dear God 2.0 (Zeds Dead Remix)" 
                               andArtist:@"The Roots ft. Monsters of Folk"
              andGenre:@"Dubstep" andScore:@"19"];
    NSArray *songsArray = [[NSArray alloc] initWithObjects:song1, song2, song3, song4, song5, song6, song7, song8, song9, song10, nil];
    
    self.songs = songsArray;
    
    
}

- (void)viewDidUnload
{
    [self setTableTitle:nil];
    [self setTopOfToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    NSString *genrefilter = @"all"; 
    NSString *timefilter = @"new";
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://t3k.no/app/request_songs.php"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *post =[[NSString alloc] initWithFormat:@"genrefilter=%@timefilter=%@submit", genrefilter, timefilter];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSLog([[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

}

- (IBAction)openGenreOptions:(id)sender {
}

- (IBAction)openTopOfOptions:(id)sender {
    if (topOfToolbar.hidden == false){
        topOfToolbar.hidden = true;
    }else{
        topOfToolbar.hidden = false;
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SongCellIdentifier = @"SongCellIdentifier";
    static BOOL nibsRegistered = NO;
    if(!nibsRegistered){
        UINib *nib = [UINib nibWithNibName:@"SongCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:SongCellIdentifier];
        nibsRegistered = YES;
    }
    
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:SongCellIdentifier];
    
    NSUInteger row = [indexPath row];
    Song *temp = [songs objectAtIndex:row];
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
    [super dealloc];
}
@end
