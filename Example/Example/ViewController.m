// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "ViewController.h"
#import "UPPBasicDevice.h"
#import "UPPDiscovery.h"
#import "FolderViewController.h"
#import "UPPMediaServerDevice.h"
#import "UPPMediaRendererDevice.h"
#import "PlaybackManager.h"

@interface ViewController () <UPPDiscoveryDelegate>
@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) PlaybackManager *playbackManager;
@property (strong, nonatomic) NSTimer *searchTimer;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.playbackManager = [[PlaybackManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UPPDiscovery sharedInstance] setDelegate:self];
    [self setupSearchTimer];
}

- (void)setupSearchTimer
{
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                        target:self
                                                      selector:@selector(timerFired:)
                                                      userInfo:nil
                                                       repeats:YES];
    [self.searchTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchTimer invalidate];
}

- (void)timerFired:(NSTimer *)timer
{
    [[UPPDiscovery sharedInstance] startBrowsingForServices:@"ssdp:all"];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)devices
{
    if (!_devices) {
        _devices = [NSMutableArray array];
    }

    return _devices;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    UPPBasicDevice *device = self.devices[indexPath.row];
    cell.textLabel.text = device.friendlyName;
    cell.detailTextLabel.text = device.deviceType;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id device = self.devices[indexPath.row];

    if ([device isKindOfClass:[UPPMediaRendererDevice class]]) {
        self.playbackManager.renderer = device;
    }

    else if ([device isKindOfClass:[UPPMediaServerDevice class]]) {
        [self pushViewControllerForDevice:device];
    }
}

- (void)pushViewControllerForDevice:(UPPMediaServerDevice *)device
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FolderViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"FolderViewController"];
    viewController.title = [device friendlyName];
    viewController.device = device;
    viewController.playbackManager = self.playbackManager;

    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UPPDiscoveryDelegate

- (void)discovery:(UPPDiscovery *)discovery didFindDevice:(UPPBasicDevice *)device
{
    if ([self.devices containsObject:device]) {
        return;
    }

    [self.devices addObject:device];
    NSInteger row = [self.devices indexOfObject:device];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)discovery:(UPPDiscovery *)discovery didRemoveDevice:(UPPBasicDevice *)device
{
    if (![self.devices containsObject:device]) {
        return;
    }

    NSInteger row = [self.devices indexOfObject:device];
    [self.devices removeObject:device];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
