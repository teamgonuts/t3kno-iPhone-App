//
//  CBHViewController.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    bool pageControlBeingUsed;
    int expandedRow;
    //bool searching; //if the user has entered a search term
}

//universal
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;

//upload (Youtube) view
@property (retain, nonatomic) IBOutlet UIView *searchView;
- (IBAction)browserBackButtonPressed:(id)sender;
- (IBAction)browserForwardButtonPressed:(id)sender;
- (IBAction)uploadButtonPressed:(id)sender;

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
@property (strong, nonatomic) NSData *receivedData;
- (IBAction)seachButtonIconPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;



//filterview
- (void) refreshFilters;
- (void) refreshTitle;
@property (retain, nonatomic) IBOutlet UIView *filterView;
@property (retain, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) NSString *genreFilter; 
@property (strong, nonatomic) NSString *timeFilter;
@property (strong, nonatomic) NSDictionary *filterValues;
@property (strong, nonatomic) NSArray *filterKeys;


//page control
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;



@end