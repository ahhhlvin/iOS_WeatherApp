//
//  WeatherObject.h
//  WeatherApp
//
//  Created by Alvin Kuang on 12/19/16.
//  Copyright © 2016 Alvin Kuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *weatherDescription;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSNumber *minTemp;
@property (nonatomic, strong) NSNumber *maxTemp;

@end
