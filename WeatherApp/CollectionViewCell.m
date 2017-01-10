//
//  CollectionViewCell.m
//  WeatherApp
//
//  Created by Alvin Kuang on 12/19/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
         self.backgroundColor = [UIColor orangeColor];
         
         self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 375, 20)];
         self.weatherIconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 60, 60)];
         self.weatherDescripLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 375, 20)];
         self.humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 375, 20)];
         self.windSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 375, 20)];
         self.minTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 375, 20)];
         self.maxTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 375, 20)];
         
         [self.contentView addSubview:self.dayLabel];
         [self.contentView addSubview:self.weatherIconView];
         [self.contentView addSubview:self.weatherDescripLabel];
         [self.contentView addSubview:self.humidityLabel];
         [self.contentView addSubview:self.windSpeedLabel];
         [self.contentView addSubview:self.minTempLabel];
         [self.contentView addSubview:self.maxTempLabel];
     }
    
    return self;
}

@end
