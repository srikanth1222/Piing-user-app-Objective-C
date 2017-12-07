//
//  WebserviceMethods.h
//  Ping
//
//  Created by SHASHANK on 15/02/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate<NSObject>

@optional
-(void)receivedResponse:(id)response;
@end

@interface WebserviceMethods : NSObject <NSURLConnectionDelegate>
{
    NSURLConnection *currentConnection;
    NSMutableData *responseData;
    id delegate;
}
@property (nonatomic, retain) NSString *successCallback;

+ (id)sharedWebRequest;

+(void)sendRequestWithURLString:(NSString *)urlString requestMethod:(NSString *)method withDetailsDictionary:(NSDictionary *)detailsDictionary andResponseCallBack:(void(^)(NSURLResponse *response, NSError *error, id responseObj))apiResponse;

-(void)getRequestWithParam:(NSString*)req andWithDelegate:(id) parent andCallbackMethod:(NSString *)callback;
//-(id)sendSynchronousRequestForComponent:(NSString *) name methodName:(NSString *)methodname  type:(NSString *) type  parameters:(NSDictionary *) parameters;
-(id)sendSynchronousRequestForComponent:(NSString *) name methodName:(NSString *)methodname  type:(NSString *) type  parameters:(NSDictionary *) parameters andWithDel:(id) parentDel;

-(void)sendAsynchronousRequestForComponent:(NSString *) name  methodName:(NSString *)methodname type:(NSString *) type   parameters:(NSDictionary *) parameters delegate:(id)del;

-(NSMutableAttributedString *) getAttributedStringWithSpacing:(NSString *) string andWithColor:(UIColor *) selectedColor andFont:(UIFont *) selectedFont;

@end
