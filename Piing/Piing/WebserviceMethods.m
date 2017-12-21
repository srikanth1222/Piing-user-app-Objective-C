//
//  WebserviceMethods.m
//  Ping
//
//  Created by SHASHANK on 15/02/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "WebserviceMethods.h"
#import <Reachability/Reachability.h>



#define TimeOUtInterval   60.0f
@interface WebserviceMethods ()
{
    //    UIBackgroundTaskIdentifier bgTask;
    BOOL isUploading;
}

//@property (nonatomic, retain) NSString *successCallback;

@end
@implementation WebserviceMethods
@synthesize successCallback;

+(id) sharedWebRequest
{
    static WebserviceMethods *sharedWebRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWebRequest = [[self alloc] init];
    });
    return sharedWebRequest;
}


+(void)sendRequestWithURLString:(NSString *)URLString requestMethod:(NSString *)method withDetailsDictionary:(NSDictionary *)parameters andResponseCallBack:(void(^)(NSURLResponse *response, NSError *error, id responseObj))apiResponse{
        
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if ([reach isReachable])
    {
        NSLog(@"REACHABLE!");
        
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
//
//        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in [storage cookies]) {
//            [storage deleteCookie:cookie];
//        }
        
        NSMutableURLRequest *req1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        
        [req1 setHTTPMethod:@"POST"];
        [req1 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req1 setHTTPBody:postData];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        sessionConfig.URLCache = nil;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        
        [[session dataTaskWithRequest:req1 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            AppDelegate *appDel = [[PiingHandler sharedHandler] appDel];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                if (!error && data) {
                    
                    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    
                    appDel.loginMethodCalled = NO;
                    
                    DLog(@"API Response.. %@", responseObject);
                    
                    apiResponse(response, error, responseObject);
                    
                } else {
                    //NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                    
                    [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"" andBtnTitle:@"OK"];
                    
                    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                }
            }];
            
        }] resume];
        
        
        
//        [[session dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            
//            AppDelegate *appDel = [[PiingHandler sharedHandler] appDel];
//            
//            if (!error) {
//                
//                appDel.loginMethodCalled = NO;
//                
//                DLog(@"API Response.. %@", responseObject);
//                
//                apiResponse(response, error, responseObject);
//                
//            } else {
//                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
//                
//                [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"" andBtnTitle:@"OK"];
//                
//                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
//            }
//            
//        }]resume];
        
    }
    else
    {
        
        AppDelegate *appDel = [[PiingHandler sharedHandler] appDel];
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        //apiResponse(nil, nil, nil);
        
        [appDel showAlertWithMessage:@"The Internet connection appears to be offline." andTitle:@"" andBtnTitle:@"OK"];
    }
    
}

-(void)getRequestWithParam:(NSString*)req andWithDelegate:(id) parent andCallbackMethod:(NSString *)callback
{
    DLog(@"Get URL.. %@", req);
    
    NSURL *reqURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",req] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSError *error = nil;
//    NSURLResponse *response = nil;
    NSMutableURLRequest *getReq = [[NSMutableURLRequest alloc] initWithURL:reqURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TimeOUtInterval];
    
    //NSData *data = [NSURLConnection sendSynchronousRequest:getReq returningResponse:&response error:&error];
    
    [NSURLConnection sendAsynchronousRequest:getReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable error) {
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@",responseString);
        
        if (error)
        {
            DLog(@"%@ %li %@",error,(long)[error code],[error localizedDescription]);
            
            //UIAlertView *errorMessageAlert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //[errorMessageAlert show];
            
            UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message:[error localizedDescription]
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [errorMessageAlert addAction:defaultAction];
            [(UIViewController *)parent presentViewController:errorMessageAlert animated:YES completion:nil];
            
            //        [[iToast makeText:[error localizedDescription]] show];
            
            if (callback) {
                
                [parent performSelectorOnMainThread:NSSelectorFromString(callback) withObject:nil waitUntilDone:YES];
                
            }
            else if ([parent respondsToSelector:@selector(receivedResponse:)]) {
                
                [parent performSelectorOnMainThread:@selector(receivedResponse:) withObject:nil waitUntilDone:YES];
            }
            else {
                
            }
            
            
            return;
            
        }
        
        if (callback) {
            
            //        [parent performSelector:NSSelectorFromString(callback) withObject:[self parseData:data]];
            [parent performSelectorOnMainThread:NSSelectorFromString(callback) withObject:[self parseData:data] waitUntilDone:YES];
            
        }
        else if ([parent respondsToSelector:@selector(receivedResponse:)]) {
            
            [parent performSelectorOnMainThread:@selector(receivedResponse:) withObject:[self parseData:data] waitUntilDone:YES];
        }
        else {
            
        }

    }];
    
    
}

-(id)parseData:(NSData *)data{
    
    NSError *error = nil;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        DLog(@"Error parsing JSON.");
        // return nil;
        NSDictionary *dic = @{@"message":@"Server Error",@"success":@"false"};
        return dic;
        
    }
    else {
        //        DLog(@"Array: %@", jsonData);
        return jsonData;
    }
    
}
-(id)sendSynchronousRequestForComponent:(NSString *) name methodName:(NSString *)methodname  type:(NSString *) type  parameters:(NSDictionary *) parameters andWithDel:(id)parentDel{
    
    delegate = parentDel;
    
    id results;
    
    NSMutableURLRequest *urlRequest = [self generateURLRequestForComponent2:name methodName:methodname type:type parameters:parameters];
    
    NSLog(@"Input parameters %@",[[NSString alloc] initWithData:urlRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    isUploading = YES;
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    isUploading = NO;
    NSLog(@"Response Data :%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    AppDelegate *appDel = [PiingHandler sharedHandler].appDel;
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    if (error == nil)
    {
        // Parse data here
        results = [self parseData:data];
        
    }
    else
    {
        //        if(![methodname isEqualToString:@"redeem-voucher"])
        //            [[iToast makeText:[error localizedDescription]] show];
        
        //        UIAlertView *errorMessageAlert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [errorMessageAlert show];
        
//        UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                                   message:[error localizedDescription]
//                                                                            preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {}];
//        
//        [errorMessageAlert addAction:defaultAction];
//        
//       // AppDelegate *appdel = (UIViewController *)delegate;
//        
//        [(UIViewController *)delegate presentViewController:errorMessageAlert animated:YES completion:nil];
        //AppDelegate *appdel = (UIViewController *)delegate;
        [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"Error" andBtnTitle:@"OK"];
        
        //        else if ([parent respondsToSelector:@selector(receivedResponse:)]) {
        //
        //            [parent performSelectorOnMainThread:@selector(receivedResponse:) withObject:nil waitUntilDone:YES];
        //        }
        
    }
    
    return results;
}

-(void)sendAsynchronousRequestForComponent:(NSString *) name  methodName:(NSString *)methodname type:(NSString *) type   parameters:(NSDictionary *) parameters delegate:(id)del
{
    //    NSMutableURLRequest *urlRequest = [self generateURLRequestForComponent:name methodName:methodname type:type parameters:parameters];
    
    NSMutableURLRequest *urlRequest;
    
    if ([name isEqual:@"venue"])
    {
        urlRequest = [self generateURLRequestForComponent:name methodName:methodname type:type parameters:parameters];
        isUploading = NO;
    }
    else if ([name containsString:@"RegisterDevice"])
        urlRequest = [self generateURLRequestForComponent2:name methodName:methodname type:type parameters:parameters];
    else
        urlRequest = [self generateURLRequestForComponent2:name methodName:methodname type:type parameters:parameters];
    //    else
    //    {
    //        urlRequest = [self generateURLRequestForComponent:name methodName:methodname type:type parameters:parameters];
    //        isUploading =YES;
    //    }
    delegate = del;
    
    currentConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
    //    [currentConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [currentConnection start];
}
-(NSMutableURLRequest *)generateURLRequestForComponent2:(NSString *)name  methodName:(NSString *)methodNeme type:(NSString *) type parameters:(NSDictionary *)param
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@?",BASE_URL,name,methodNeme];
    
    
    
    
    //    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    //	[postRequest setURL:reqURL];
    //	[postRequest setHTTPMethod:type];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setHTTPMethod:type];
    
    if([[type uppercaseString] isEqualToString:@"POST"]){
        
        NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        for (int i=0; i<2; i++) {
            if([parameters valueForKey:@"profile"] || [parameters valueForKey:@"cover"])
            {
                NSString *key;
                if([parameters valueForKey:@"profile"])
                    key=@"profile";
                else
                    key =@"cover";
                UIImage *img=[parameters valueForKey:key];
                
                
                NSData *imageData =UIImageJPEGRepresentation(img,1.0);
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: application/x-www-form-urlencoded; name=\"%@\"; filename=\"%@%@.jpg\"",key,@"winter",key]  dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:imageData];
                
                [parameters removeObjectForKey:key];
            }
        }
        
        
        NSArray *allDicKeys = [parameters allKeys];
        
        for (int i=0;i<[allDicKeys count];i++) {
            if(i)
                urlString = [urlString stringByAppendingFormat:@"&%@=%@",[allDicKeys objectAtIndex:i],[param valueForKey:[allDicKeys objectAtIndex:i]]];
            else
                urlString = [urlString stringByAppendingFormat:@"%@=%@",[allDicKeys objectAtIndex:i],[param valueForKey:[allDicKeys objectAtIndex:i]]];
        }
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        NSLog(@"\nrequest .. %@ \nInput parameters %@", request, [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    }else{
        
        
        NSArray *allDicKeys = [parameters allKeys];
        if([allDicKeys count])
            urlString = [urlString stringByAppendingString:@""];
        
        for (int i=0;i<[allDicKeys count];i++) {
            if(i)
                urlString = [urlString stringByAppendingFormat:@"&%@=%@",[allDicKeys objectAtIndex:i],[param valueForKey:[allDicKeys objectAtIndex:i]]];
            else
                urlString = [urlString stringByAppendingFormat:@"%@=%@",[allDicKeys objectAtIndex:i],[param valueForKey:[allDicKeys objectAtIndex:i]]];
        }
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url string:%@",urlString);
    
    NSURL * reqURL = [NSURL URLWithString:urlString];
    [request setURL:reqURL];
    
    return request;
    
}
-(NSMutableURLRequest *)generateURLRequestForComponent:(NSString *)name  methodName:(NSString *)methodNeme type:(NSString *) type parameters:(NSDictionary *)param
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@/%@",BASE_URL,name,methodNeme];
    
    
    
    
    //    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    //	[postRequest setURL:reqURL];
    //	[postRequest setHTTPMethod:type];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [request setHTTPMethod:type];
    
    if([[type uppercaseString] isEqualToString:@"POST"]){
        
        NSString *boundary = @"------------------------------78731b562e5a";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField: @"Accept"];
        
        NSMutableData *body = [NSMutableData data];
        
        [ body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        for (int i=0; i<2; i++) {
            if([parameters valueForKey:@"profile"] || [parameters valueForKey:@"cover"])
            {
                NSString *key;
                if([parameters valueForKey:@"profile"])
                    key=@"profile";
                else
                    key =@"cover";
                UIImage *img=[parameters valueForKey:key];
                
                
                NSData *imageData =UIImageJPEGRepresentation(img,1.0);
                
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@%@.jpg\"\r\n",key,@"winter",key]  dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:imageData];
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [parameters removeObjectForKey:key];
            }
        }
        
        
        NSArray *allDicKeys = [parameters allKeys];
        
        for (int i=0;i<[allDicKeys count];i++) {
            
            
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n",[allDicKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n%@",[parameters valueForKey:[allDicKeys objectAtIndex:i]]] dataUsingEncoding:NSUTF8StringEncoding]];
            if (!(i==[allDicKeys count]-1)) {
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            else{
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        NSLog(@"\nrequest .. %@ \nInput parameters %@", request, [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    }else{
        
        
        NSArray *allDicKeys = [parameters allKeys];
        if([allDicKeys count])
            urlString = [urlString stringByAppendingString:@"?"];
        
        for (int i=0;i<[allDicKeys count];i++) {
            if(i)
                urlString = [urlString stringByAppendingFormat:@"&&%@=%@",[allDicKeys objectAtIndex:i],[param valueForKey:[allDicKeys objectAtIndex:i]]];
            else
                urlString = [urlString stringByAppendingFormat:@"%@=%@",[allDicKeys objectAtIndex:i],[param valueForKey:[allDicKeys objectAtIndex:i]]];
        }
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url string:%@",urlString);
    
    NSURL * reqURL = [NSURL URLWithString:urlString];
    [request setURL:reqURL];
    
    return request;
    
}
#pragma mark Connection delegate methods
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] initWithCapacity:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (!delegate)
    {
        DLog(@"No delegate in webservice");
        return;
    }
    DLog(@"Delegate in webservice");
    
    
    AppDelegate *appDel = [PiingHandler sharedHandler].appDel;
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    if ([delegate respondsToSelector:NSSelectorFromString(self.successCallback)]) {
        [delegate performSelector:NSSelectorFromString(self.successCallback) withObject:[self parseData:responseData]];
    }
    else if([delegate respondsToSelector:@selector(receivedResponse:)])
        [delegate receivedResponse:[self parseData:responseData]];
    
    responseData = nil;
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //    isUploading = NO;
   
    AppDelegate *appDel = [PiingHandler sharedHandler].appDel;
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    //        UIAlertView *errorMessageAlert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [errorMessageAlert show];
    
//    
//    UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@"Error"
//                                                                               message:[error localizedDescription]
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [errorMessageAlert addAction:defaultAction];
//    [(UIViewController *)delegate presentViewController:errorMessageAlert animated:YES completion:nil];
    //    [[iToast makeText:[error localizedDescription]] show];
    
    [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"Error" andBtnTitle:@"OK"];
    
    responseData = nil;
    
    if ([delegate respondsToSelector:NSSelectorFromString(self.successCallback)]) {
        [delegate performSelector:NSSelectorFromString(self.successCallback) withObject:nil];
    }
    else if([delegate respondsToSelector:@selector(receivedResponse:)])
        [delegate receivedResponse:nil];
    
}
#pragma mark Some other Methods
-(NSMutableAttributedString *) getAttributedStringWithSpacing:(NSString *) string andWithColor:(UIColor *) selectedColor andFont:(UIFont *) selectedFont
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(2)
                             range:NSMakeRange(0, [string length])];
    
    //    [attributedString addAttribute:NSFontAttributeName
    //                             value:selectedFont
    //                             range:NSMakeRange(0, [string length])];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:selectedColor
                             range:NSMakeRange(0, [string length])];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:selectedFont
                             range:NSMakeRange(0, [string length])];

    return attributedString;

}

@end
