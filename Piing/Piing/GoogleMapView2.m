//
//  GoogleMapView2.m
//  GoogleMapsPOC
//
//  Created by Shashank on 17/05/15.
//  Copyright (c) 2015 Shashank. All rights reserved.//

#import "GoogleMapView2.h"
#import "AppDelegate.h"


@interface GoogleMapView2 ()
{
    GMSPolyline *gmsPline;
    GMSCoordinateBounds *bounds;
    
    NSMutableDictionary *dictSaveGoogleData;
    
    NSString *strSourcAddr;
    NSString *strDestinationAddr;
    
    NSMutableArray *arrWayPoints;
    
    AppDelegate *appDel;
}

@end


@implementation GoogleMapView2

@synthesize delegate, allMarkersArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        appDel = [PiingHandler sharedHandler].appDel;
        
        allMarkersArray = [[NSMutableArray alloc] init];
        
        arrWayPoints = [[NSMutableArray alloc]init];
        
        piingoMarker = [[GMSMarker alloc] init];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[appDel.latitude doubleValue] longitude:[appDel.longitude doubleValue] zoom:20];
        
        gMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) camera:camera];
        gMapView.settings.rotateGestures = NO;
        gMapView.settings.tiltGestures = NO;
        gMapView.delegate = self;
        gMapView.myLocationEnabled = NO;
        [self addSubview:gMapView];
        
        dictSaveGoogleData = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}


-(void) addClientMarker:(id) obj
{
    DLog(@"Lat: %@ \n long: %@", [obj objectForKey:@"lat"], [obj objectForKey:@"lon"]);
    
    clientMarker.map = nil;
    clientMarker = nil;
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [[obj objectForKey:@"lat"] doubleValue];
    coordinates.longitude = [[obj objectForKey:@"lon"] doubleValue];
    
    clientMarker = [[GMSMarker alloc] init];
    clientMarker.position = coordinates;
    
    if ([obj objectForKey:@"markImage"])
    {
        clientMarker.icon = [UIImage imageNamed:[obj objectForKey:@"markImage"]];
    }
    else
    {
        clientMarker.icon = [UIImage imageNamed:@"home_map"];
    }
    
    //clientMarker.appearAnimation = kGMSMarkerAnimationPop;
    clientMarker.map = gMapView;
    
    [allMarkersArray removeAllObjects];
    
    [allMarkersArray addObject:clientMarker];
}


-(void) addPiingoMarkder:(id) obj
{
    DLog(@"Lat: %@, long: %@", [obj objectForKey:@"lat"], [obj objectForKey:@"lon"]);
    
//    piingoMarker.map = nil;
//    piingoMarker = nil;
//    
//    piingoMarker = [[GMSMarker alloc] init];
    
    piingoMarker.icon = [UIImage imageNamed:@"piingo_van"];
    piingoMarker.groundAnchor = CGPointMake(0.5, 0.5);
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [[obj objectForKey:@"lat"] doubleValue];
    coordinates.longitude = [[obj objectForKey:@"lon"] doubleValue];
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    
    piingoMarker.position = coordinates;
    piingoMarker.rotation = appDel.headingInDegrees;
    piingoMarker.map = gMapView;
    
    [CATransaction commit];
    
    [allMarkersArray removeObject:piingoMarker];
    
    [allMarkersArray addObject:piingoMarker];
}

-(void) addMarker:(id) obj withIndex:(int) index
{
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [[obj objectForKey:@"lat"] doubleValue];
    coordinates.longitude = [[obj objectForKey:@"lon"] doubleValue];
    
    CustomGMSMarker *marker = [[CustomGMSMarker alloc] init];
    marker.position = coordinates;
    marker.icon = [UIImage imageNamed:[obj objectForKey:@"markImage"]];
    //marker.infoWindowAnchor = CGPointMake(0.38, 0.0);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = gMapView;
    
    [allMarkersArray addObject:marker];
}


-(void) addCustomMarkers:(id) obj
{
    CLLocationCoordinate2D coordinates;
    
    if ([obj objectForKey:@"lat"])
    {
        coordinates.latitude = [[obj objectForKey:@"lat"] doubleValue];
        coordinates.longitude = [[obj objectForKey:@"lon"] doubleValue];
    }
    else {
        coordinates.latitude = [[obj objectForKey:@"lt"] doubleValue];
        coordinates.longitude = [[obj objectForKey:@"ln"] doubleValue];
    }
    
    CustomGMSMarker *marker = [[CustomGMSMarker alloc] init];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    marker.position = coordinates;
    [CATransaction commit];
    
    marker.icon = [UIImage imageNamed:@"home_map"];
    marker.infoWindowAnchor = CGPointMake(0.38, 0.0);
    //marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = gMapView;
}

-(void)getDirectionRoutesFrom:(NSString *)saddr to:(NSString *)daddr withTravelMode:(NSString *)travelMode andWithUsingWaypoints:(NSArray *) arraywaypoints
{
    [arrWayPoints removeAllObjects];
    
    NSMutableString *wayPointsStr = [[NSMutableString alloc] init];
    
    if ([arraywaypoints count])
    {
        for (int w = 0; w < [arraywaypoints count] ;w++)
        {
            NSDictionary *dictCoordinates = [arraywaypoints objectAtIndex:w];
            
            NSString *str;
            
            if ([dictCoordinates objectForKey:@"lat"])
            {
                str = [NSString stringWithFormat:@"%f", [[dictCoordinates objectForKey:@"lat"]doubleValue]];
            }
            else if ([dictCoordinates objectForKey:@"lt"])
            {
                str = [NSString stringWithFormat:@"%f", [[dictCoordinates objectForKey:@"lt"]doubleValue]];
            }
            
            if ([saddr containsString:str])
            {
                continue;
            }
            
            if (![wayPointsStr length])
            {
                if ([dictCoordinates objectForKey:@"lat"])
                {
                    [wayPointsStr appendFormat:@"%f,%f",[[dictCoordinates objectForKey:@"lat"] doubleValue],[[dictCoordinates objectForKey:@"lon"] doubleValue]];
                }
                else if ([dictCoordinates objectForKey:@"lt"])
                {
                    [wayPointsStr appendFormat:@"%f,%f",[[dictCoordinates objectForKey:@"lt"] doubleValue],[[dictCoordinates objectForKey:@"ln"] doubleValue]];
                }
            }
            else
            {
                if ([dictCoordinates objectForKey:@"lat"])
                {
                    [wayPointsStr appendFormat:@"|%f,%f",[[dictCoordinates objectForKey:@"lat"] doubleValue],[[dictCoordinates objectForKey:@"lon"] doubleValue]];
                }
                else if ([dictCoordinates objectForKey:@"lt"])
                {
                    [wayPointsStr appendFormat:@"|%f,%f",[[dictCoordinates objectForKey:@"lt"] doubleValue],[[dictCoordinates objectForKey:@"ln"] doubleValue]];
                }
            }
            
            [arrWayPoints addObject:dictCoordinates];
            
        }
       
    }
    
//    if ([dictSaveGoogleData objectForKey:@"destination"])
//    {
//        daddr = @"17.4368,78.4439";
//    }
//    
//    [dictSaveGoogleData setObject:@"YES" forKey:@"destination"];
   
    
    
//
//    CLLocationCoordinate2D coordinates;
//    coordinates.latitude = 17.4368;
//    coordinates.longitude = 78.4439;
//    
//    CustomGMSMarker *marker = [[CustomGMSMarker alloc] init];
//    marker.position = coordinates;
//    marker.icon = [UIImage imageNamed:@"piingo_map"];
//    marker.infoWindowAnchor = CGPointMake(0.38, 0.0);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    marker.map = gMapView;
//    
//    saddr = @"17.3688,78.5247";
//    
//    coordinates.latitude = 17.3688;
//    coordinates.longitude = 78.5247;
//    
//    marker = [[CustomGMSMarker alloc] init];
//    marker.position = coordinates;
//    marker.icon = [UIImage imageNamed:@"piingo_map"];
//    marker.infoWindowAnchor = CGPointMake(0.38, 0.0);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    marker.map = gMapView;
//    
//    wayPointsStr = [@"17.3667,78.5000" mutableCopy];
//    
//    coordinates.latitude = 17.3667;
//    coordinates.longitude = 78.5000;
//    
//    marker = [[CustomGMSMarker alloc] init];
//    marker.position = coordinates;
//    marker.icon = [UIImage imageNamed:@"piingo_map"];
//    marker.infoWindowAnchor = CGPointMake(0.38, 0.0);
//    marker.appearAnimation = kGMSMarkerAnimationPop;
//    marker.map = gMapView;
    
    
    strSourcAddr = saddr;
    strDestinationAddr = daddr;
    
    NSString *strAvoid = @"tolls|highways|ferries";
    NSString *strTraffic_model = @"optimistic";
    
    travelMode = @"driving";
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString* apiUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&waypoints=%@&mode=%@&avoid=%@&traffic_model=%@&departure_time=%ld&sensor=false&key=%@", saddr, daddr, wayPointsStr, travelMode, strAvoid, strTraffic_model, (long) timeInterval, GOOGLE_API_KEY];
    
    NSURL* apiUrl = [NSURL URLWithString:[apiUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    DLog(@"%@",apiUrlStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:apiUrl];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self  startImmediately:NO];
    [urlConnection start];
}


#pragma mark MapViewDelegate Methods

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(CustomGMSMarker *)marker;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(googlemapViewTappedOnMarker:)])
    {
        [self.delegate googlemapViewTappedOnMarker:marker];
    }
    
    return NO;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture;
{
    
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(CustomGMSMarker *)marker{
    
    if (![marker isKindOfClass:[CustomGMSMarker class]])
    {
        return;
    }
    
    NSLog(@"tapped on: %d", marker.markerindex);
    
    if ([self.delegate respondsToSelector:@selector(googlemapViewTappedOnMarker:)]) {
        [self.delegate performSelector:@selector(googlemapViewTappedOnMarker:) withObject:marker];
    }
}

-(void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
   
}

-(void) clearAllMarkers
{
    [allMarkersArray removeAllObjects];
    
    [gMapView clear];
}


- (void)focusMapToShowAllMarkers
{
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (GMSMarker *marker in allMarkersArray)
    {
        [path addCoordinate: marker.position];
    }
    
    GMSCoordinateBounds *bounds1 = [[GMSCoordinateBounds alloc] initWithPath:path];
    [gMapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds1 withPadding:60.0f]];
    
    if ([allMarkersArray count] == 1)
    {
        [gMapView animateToZoom:15];
    }
}

#pragma mark Map postion Changed

-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{

}

-(void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    
}

-(void) replaceMarker:(id) obj PositionAtIndex:(NSInteger) page
{
    CustomGMSMarker *marker = [allMarkersArray objectAtIndex:page];
    
    CustomGMSMarker *marker1 = marker;
    
    marker.map = nil;
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = [[obj objectForKey:@"lat"] doubleValue];
    coordinates.longitude = [[obj objectForKey:@"lon"] doubleValue];
    
    marker1.position = coordinates;
    marker.icon = [UIImage imageNamed:[obj objectForKey:@"markImage"]];
    marker1.infoWindowAnchor = CGPointMake(0.38, 0.0);
    marker1.appearAnimation = kGMSMarkerAnimationPop;
    marker1.map = gMapView;
    
    [allMarkersArray replaceObjectAtIndex:page withObject:marker1];
}

@end
