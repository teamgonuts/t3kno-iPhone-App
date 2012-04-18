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
    int no_of_rows;
}

//universal
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;

//rankings View
- (IBAction)loadTableView:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *tableTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSData *receivedData;
- (IBAction)seachButtonIconPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;



//filterview
@property (retain, nonatomic) IBOutlet UIView *filterView;
@property (retain, nonatomic) IBOutlet UITableView *filterTableView;
@property (strong, nonatomic) NSString *genreFilter; 
@property (strong, nonatomic) NSString *timeFilter;
@property (strong, nonatomic) NSDictionary *filterValues;
@property (strong, nonatomic) NSArray *filterKeys;

//page control
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

//custom methods
- (NSString *) refreshTitle;
- (void) playSong:(NSString *)ytcode;
- (IBAction)changePage:(id)sender;

//need to do

@end
