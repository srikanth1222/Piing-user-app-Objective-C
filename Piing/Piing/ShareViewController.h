//
//  ShareViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Social/SLComposeViewController.h>
#import <Social/Social.h>


@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
{
    UILabel *lblPromoCode;
}

-(void)socialMediaButtonClicked:(id)sender;


@end
