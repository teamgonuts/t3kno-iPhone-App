//
//  CBHViewController.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHViewController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate>{
    bool pageControlBeingUsed;
}

//rankings View
- (IBAction)loadTableView:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *tableTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSData *receivedData;
@property (strong, nonatomic) NSArray *genreData;
@property (strong, nonatomic) NSArray *filterData;

//filterview
@property (retain, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) NSString *genreFilter; 
@property (strong, nonatomic) NSString *timeFilter;

//page control
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

//custom methods
- (NSString *) refreshTitle;
- (void) playSong:(NSString *)ytcode;
- (IBAction)changePage:(id)sender;

//need to do
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)openSearchBar:(id)sender;





@end
