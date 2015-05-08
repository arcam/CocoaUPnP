// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "ViewController.h"
#import "UPPBasicDevice.h"
#import "UPPDiscovery.h"

@interface ViewController () <UPPDiscoveryDelegate>
@property (strong, nonatomic) NSMutableArray *devices;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UPPDiscovery sharedInstance] setDelegate:self];
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
