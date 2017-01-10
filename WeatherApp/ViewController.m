//
//  ViewController.m
//  WeatherApp
//
//  Created by Alvin Kuang on 12/19/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "CollectionViewCell.h"
#import "WeatherObject.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray<WeatherObject *> *weatherArray;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *cityID;
@property (strong, nonatomic) NSString *cityState;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    
    self.weatherArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 375, 30)];
    self.headerLabel.adjustsFontSizeToFitWidth = true;
    self.cityID = @"4670592";
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, 375, 40)];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"city ID, e.g. 4670592"];
    [self.view addSubview:self.searchBar];
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, 375, 250) collectionViewLayout:self.flowLayout];
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell_reuse"];
    
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.loadingView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 370, 375, 40)];
    self.messageLabel.adjustsFontSizeToFitWidth = true;
    [self.view addSubview:self.messageLabel];
    
    [self fetchWeatherData:self.cityID];
}

-(void)fetchWeatherData:(NSString *)cityID {
    
    self.cityID = cityID;
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", @"http://api.openweathermap.org/data/2.5/forecast/daily?id=", self.cityID, @"&cnt=6&units=imperial&APPID=5ce3af43784cd035386cb1fe3ee4bd60"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *cityDict = [responseObject objectForKey:@"city"];
        self.cityState = [NSString stringWithFormat:@"%@, %@", [cityDict objectForKey:@"name"], [cityDict objectForKey:@"country"]];
        
        NSArray *listArray = [responseObject objectForKey:@"list"];
        for (int i = 0; i < listArray.count; i++) {
            if (i != 0) {
                NSNumber *epochDate = [listArray[i] objectForKey:@"dt"];
                NSDictionary *tempDict = [listArray[i] objectForKey:@"temp"];
                
                NSNumber *tempMin = [tempDict objectForKey:@"min"];
                NSNumber *tempMax = [tempDict objectForKey:@"max"];
                NSString *humidity = [listArray[i] objectForKey:@"humidity"];
                NSNumber *windSpeed = [listArray[i] objectForKey:@"speed"];
                NSArray *weatherArray = [listArray[i] objectForKey:@"weather"];
                NSString *weatherDescription = [[weatherArray firstObject] objectForKey:@"main"];
                NSString *iconURL = [[weatherArray firstObject] objectForKey:@"icon"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeInterval seconds = [epochDate doubleValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
                [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];
                NSString *dateString = [dateFormatter stringFromDate:date];
                
                WeatherObject *weatherObj = [[WeatherObject alloc] init];
                
                weatherObj.date = dateString;
                weatherObj.iconURL = [NSString stringWithFormat:@"%@%@%@", @"http://openweathermap.org/img/w/", iconURL, @".png"];
                weatherObj.weatherDescription = weatherDescription;
                weatherObj.humidity = humidity;
                weatherObj.windSpeed = windSpeed;
                weatherObj.minTemp = tempMin;
                weatherObj.maxTemp = tempMax;
                
                [self.weatherArray addObject:weatherObj];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setHidden:YES];
            [self.collectionView reloadData];
            self.headerLabel.text = [NSString stringWithFormat:@"%@: %@ (%@)", @"Weather for", self.cityID, self.cityState];
            self.messageLabel.text = @"SUCCESS! :)";
        });
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        self.messageLabel.text = @"ERROR: Please confirm city ID is valid before trying again.";
        NSLog(@"Error: %@", error);
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.loadingView setHidden:NO];
    if (self.messageLabel.text != nil) {
        self.messageLabel.text = @"";
    }
    [self.weatherArray removeAllObjects];
    [self fetchWeatherData:searchBar.text];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.weatherArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 230);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_reuse" forIndexPath:indexPath];
    
    if (self.weatherArray.count > 0) {
        WeatherObject *currentWeatherObj = self.weatherArray[indexPath.row];
        
        cell.dayLabel.text = currentWeatherObj.date;
        [cell.weatherIconView sd_setImageWithURL:[NSURL URLWithString:currentWeatherObj.iconURL]];
        cell.weatherDescripLabel.text = currentWeatherObj.weatherDescription;
        cell.humidityLabel.text = [NSString stringWithFormat:@"%@: %@ %@", @"Humidity", currentWeatherObj.humidity, @"%"];
        cell.windSpeedLabel.text = [NSString stringWithFormat:@"%@: %d %@", @"Wind Speed", [currentWeatherObj.windSpeed intValue], @"mph"];
        cell.minTempLabel.text = [NSString stringWithFormat:@"%@: %d %@", @"Low", [currentWeatherObj.minTemp intValue], @"°F"];
        cell.maxTempLabel.text = [NSString stringWithFormat:@"%@: %d %@", @"High", [currentWeatherObj.maxTemp intValue], @"°F"];
    }
    
    return cell;
}


@end
