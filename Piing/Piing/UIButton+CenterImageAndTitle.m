//
//  UIButton+ImageLabelPosition.m
//  Piing
//
//  Created by Veedepu Srikanth on 06/12/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "UIButton+CenterImageAndTitle.h"

@implementation UIButton (CenterImageAndTitle)

- (void)centerImageAndTitle:(float)spacing
{
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

- (void)buttonImageAndTextWithImagePosition:(NSString *) strPosition WithSpacing:(float) spacing
{
    
    if ([strPosition isEqualToString:@"TOP"])
    {
        CGSize imageSize = self.imageView.image.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
        
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
        self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    }
    else if ([strPosition isEqualToString:@"BOTTOM"])
    {
        CGSize imageSize = self.imageView.image.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, (imageSize.height + spacing), 0.0);
        
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
        self.imageEdgeInsets = UIEdgeInsetsMake((titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    }
    else if ([strPosition isEqualToString:@"LEFT"])
    {
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing, 0.0, 0.0);
    }
    else if ([strPosition isEqualToString:@"RIGHT"])
    {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        CGSize imageSize = self.imageView.image.size;
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - (imageSize.width), 0.0, 0.0);
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - (imageSize.width + spacing), 0.0, 0.0);
    }
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end
