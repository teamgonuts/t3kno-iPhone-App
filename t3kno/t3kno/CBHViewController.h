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
}

//universal
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;

//upload (Youtube) view
@property (retain, nonatomic) IBOutlet UIView *searchView;
@property (retain, nonatomic) IBOutlet UIWebView *youtubeWebView;
- (IBAction)browserBackButtonPressed:(id)sender;
- (IBAction)browserForwardButtonPressed:(id)sender;
- (IBAction)uploadButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)homeButtonPressed:(id)sender;

//final upload song view
@property (strong, nonatomic) IBOutlet UIPickerView *genrePicker;
@property (strong, nonatomic) NSArray *genrePickerData;
@property (retain, nonatomic) IBOutlet UIView *finalUploadSongView;
- (IBAction)finalUploadCancelButtonPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *thumbnailWebView;
@property (retain, nonatomic) IBOutlet UITextField *genreTextField;
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextField *artistTextField;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *titleTextFieldLabel;
@property (retain, nonatomic) IBOutlet UILabel *displayedTextLabel;

//rankings View
- (IBAction)loadTableView:(id)sender;
- (void) closeExpandedSong;
- (void) scrollToMiddleView;
@property (retain, nonatomic) IBOutlet UIView *rankingsView;
@property (retain, nonatomic) IBOutlet UILabel *rankingsTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) NSMutableArray *songs;
@property (retain, nonatomic) NSMutableArray *tableViewCells;
@property (strong, nonatomic) NSMutableData *receivedData;
- (IBAction)seachButtonIconPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;



//filterview
- (void) refreshFilters;
- (void) refreshTitle;
@property (retain, nonatomic) IBOutlet UIView *filterView;
@property (retain, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) NSDictionary *filterValues;
@property (strong, nonatomic) NSArray *filterKeys;


//page control
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;



@end