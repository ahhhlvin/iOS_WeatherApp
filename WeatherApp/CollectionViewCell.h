//
//  CollectionViewCell.h
//  WeatherApp
//
//  Created by Alvin Kuang on 12/19/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *weatherIconView;
@property (nonatomic, strong) UILabel *weatherDescripLabel;
@property (nonatomic, strong) UILabel *humidityLabel;
@property (nonatomic, strong) UILabel *windSpeedLabel;
@property (nonatomic, strong) UILabel *minTempLabel;
@property (nonatomic, strong) UILabel *maxTempLabel;

@end
