// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "FolderViewController.h"
#import "PlaybackManager.h"

#import <CocoaUPnP/CocoaUPnP.h>

@interface FolderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *items;
@end

@implementation FolderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.hidden = YES;
    self.items = [NSMutableArray array];
    [self fetchChildren];
}

- (void)fetchChildren
{
    UPPResponseBlock block = ^(NSDictionary *response, NSError *error) {
        if (response) {
            [self loadResults:response[@"Result"]];
        } else {
            NSLog(@"Error fetching results: %@", error);
        }
    };

    [[self.device contentDirectoryService]
     browseWithObjectID:self.objectId
     browseFlag:BrowseDirectChildren
     filter:@"dc:title,upnp:originalTrackNumber,res,res@duration"
     startingIndex:@0
     requestedCount:@0
     sortCritera:nil
     completion:block];
}

- (void)loadResults:(NSArray *)results
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.items addObjectsFromArray:results];

        if (self.tableView.hidden) {
            self.tableView.hidden = NO;
            [self.activityIndicator stopAnimating];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UPPMediaItem *item = self.items[indexPath.row];
    cell.textLabel.text = [self titleForMediaItem:item];
    cell.detailTextLabel.text = [item duration];

    if ([item isContainer]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (NSString *)titleForMediaItem:(UPPMediaItem *)item
{
    if ([item.objectClass isEqualToString:@"object.item.audioItem.musicTrack"]) {
        NSString *title = [NSString stringWithFormat:@"%02d - %@",
                           [item.trackNumber intValue], item.itemTitle];
        return title;
    }

    return item.itemTitle;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPPMediaItem *item = self.items[indexPath.row];

    if ([item.objectClass isEqualToString:@"object.item.audioItem.musicTrack"]) {
        [self.playbackManager playItem:item];
        return;
    }

    [self pushFolderViewControllerWithItem:item];
}

- (void)pushFolderViewControllerWithItem:(UPPMediaItem *)item
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FolderViewController *newViewController = [storyboard instantiateViewControllerWithIdentifier:@"FolderViewController"];
    newViewController.device = self.device;
    newViewController.playbackManager = self.playbackManager;

    newViewController.objectId = item.objectID;
    newViewController.title = item.itemTitle;

    [self.navigationController pushViewController:newViewController animated:YES];
}

@end
