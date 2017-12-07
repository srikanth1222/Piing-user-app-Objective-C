//
//  GoogleMapView2.h
//  GoogleMapsPOC
//
//  Created by Shashank on 17/05/15.
//  Copyright (c) 2015 Shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomGMSMarker.h"


@protocol GoogleMapViewDelegate<NSObject>

-(void)googlemapViewTappedOnMarker:(CustomGMSMarker *)marker;
-(void) durationResponse:(NSDictionary *) durationResponse;

@end


@interface GoogleMapView2 : UIView <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *gMapView;
    
    GMSMarker *clientMarker, *piingoMarker;
}

@property (nonatomic, strong) NSMutableArray *allMarkersArray;

@property (nonatomic, strong) id delegate;

-(void) clearAllMarkers;

-(void) addMarker:(id) obj withIndex:(int) index;

-(void)getDirectionRoutesFrom:(NSString *)saddr to:(NSString *)daddr withTravelMode:(NSString *)travelMode andWithUsingWaypoints:(NSArray *) waypoints;

-(void) addPiingoMarkder:(id) obj;
-(void) addClientMarker:(id) obj;

-(void) replaceMarker:(id) obj PositionAtIndex:(NSInteger) page;
- (void)focusMapToShowAllMarkers;

@end
