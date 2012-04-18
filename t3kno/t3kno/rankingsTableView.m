//
//  RankingsTableView.m
//  t3kno
//
//  Created by Me on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RankingsTableView.h"
#import "CBHViewController.h"

@implementation RankingsTableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)songTableView{
    bool debug = false;
    if (debug) NSLog(@"numberOfSectionsInTable Called!");
    if (songTableView == tableView){//tableView
        if (debug) NSLog(@"--TableView: rankings");
        return 1;
    }else{
        if (debug) NSLog(@"--TableView: filter");
        return [filterKeys count];
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
    }else{ //its the filter tableView
        if (debug) NSLog(@"--TableView: filter");
        if (debug) NSLog(@"--section: %d", section);
        NSString *key = [filterKeys objectAtIndex:section];
        NSArray *filterSection = [filterValues objectForKey:key];
        return [filterSection count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)songTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    bool debug = true;
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
    } else{ //tableView is FilterView
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
        //cell.textColor = [UIColor whiteColor];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)songTableView
titleForHeaderInSection:(NSInteger)section{
    NSString *title  = "The Fresh List";
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView_in
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0; //same as SongCell.xib
}


- (void)tableView: (UITableView *)songTableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    //SongCell *cell = [songTableView cellForRowAtIndexPath:indexPath];
    //UIImageView *clickedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecellbg_click.png"]];
    //[cell setSelectedBackgroundView:clickedBackgroundView];
    //[cell setSelected:YES];
    //cell.artistLabel.textColor = [UIColor blackColor];
    //cell.bgImage.image = [UIImage imageNamed:@"tablecellbg_click.png"];
    //cell.titleLabel.textColor = [UIColor blackColor];
    
    //cell.scoreLabel.textColor = [UIColor blackColor];
    //cell.genreLabel.textColor = [UIColor blackColor];
    
    
    
    
}

@end
