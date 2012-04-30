//
//  CBHViewController.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    bool pageControlBeingUsed;
    int expandedRow;
    NSString *genreFilter;
    NSString *timeFilter;
    bool scrolledFromUploadView;
    NSMutableString *titlePlaceHolder;
    NSURLConnection *uploadConnection;
}

//universal
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;

//upload (Youtube) view
@property (retain, nonatomic) IBOutlet UIWebView *youtubeWebView; ///<view to upload youtube songs
- (IBAction)browserBackButtonPressed:(id)sender; ///<Browser's back button
- (IBAction)browserForwardButtonPressed:(id)sender; ///<Browser's forward button
- (IBAction)uploadButtonPressed:(id)sender; ///<initial upload button in browser bar
- (IBAction)refreshButtonPressed:(id)sender;///<Browser's refresh button
- (IBAction)homeButtonPressed:(id)sender;///<Browser's home button

//final upload song view
@property (strong, nonatomic) NSString *uploadytcode;///<youtube video code of the song to be uploaded
@property (strong, nonatomic) IBOutlet UIPickerView *genrePicker;///<UIPickerView to select a genre for uploaded song
@property (strong, nonatomic) NSArray *genrePickerData;///<Data for genrePicker (UIPickerView)
@property (retain, nonatomic) IBOutlet UIView *finalUploadSongView;///<View where user enters details of song to be uploaded
- (IBAction)finalUploadCancelButtonPressed:(id)sender;///<button to cancel user's upload
- (IBAction)finalUploadButtonPressed:(id)sender;///<button to submit song to database
@property (retain, nonatomic) IBOutlet UIWebView *thumbnailWebView;///<youtube song's thumbnail
@property (retain, nonatomic) IBOutlet UITextField *genreTextField;///<Uploaded song's genre
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;///<Uploaded song's title
@property (retain, nonatomic) IBOutlet UITextField *artistTextField;///<Uploaded song's artist
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;///<User that uploaded the song
@property (retain, nonatomic) IBOutlet UILabel *videoTitleLabel;///<Uploaded video's youtube title
@property (retain, nonatomic) IBOutlet UILabel *titleTextFieldLabel;///<title label for uploaded song's textfield
@property (retain, nonatomic) IBOutlet UILabel *displayedTextLabel;///<label to help user see what he is typing

//rankings View
- (IBAction)loadTableView:(id)sender;
- (void) closeExpandedSong;
- (void) scrollToMiddleView;
@property (retain, nonatomic) IBOutlet UIView *rankingsView; ///<middle view to display songs
@property (retain, nonatomic) IBOutlet UILabel *rankingsTitle;///<label at the top of the page
@property (retain, nonatomic) IBOutlet UITableView *tableView;///<song rankings UITableView
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;///<scroll view that holds all 3 main views
@property (retain, nonatomic) NSMutableArray *songs; ///<array of Song objects
@property (retain, nonatomic) NSMutableArray *tableViewCells;///<array of custon SongCell objects
@property (strong, nonatomic) NSMutableData *receivedData;///<received data for NSURLConnections
- (IBAction)seachButtonIconPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar; ///<search bar to search t3k.no
@property (retain, nonatomic) IBOutlet UIButton *searchButton; ///<magnifying glass button by logo



//filterview
- (void) refreshFilters;
- (void) refreshTitle;
@property (retain, nonatomic) IBOutlet UIView *filterView; ///<right view that displays filters
@property (retain, nonatomic) IBOutlet UITableView *filterTableView;///<UITableView with filters (time/genre)
@property (strong, nonatomic) NSDictionary *filterValues;///<filterTableView's row values
@property (strong, nonatomic) NSArray *filterKeys;///<filterTableView's section headers


//page control
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;///<page control at bottom of page



@end