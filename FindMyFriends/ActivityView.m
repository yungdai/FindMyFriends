//
//  ActivityView.m
//  FindMyFriends
//
//  Created by Yung Dai on 2015-05-13.
//  Copyright (c) 2015 Yung Dai. All rights reserved.
//

#import "ActivityView.h"


// create new constans for how the this vew will center itself and have the activity view indicator on the right.
static CGFloat const ActivityViewLabelCenterXOffset = 5.0f;
static CGFloat const ActivityViewActivityIndicatorRightInset = 10.0f;

@implementation ActivityView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // setting up the activity view programatically (you can change this later to to match the style you require)
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:self.activityIndicator];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGRect labelFrame = CGRectZero;
    labelFrame.size = [self.label sizeThatFits:bounds.size];
    labelFrame.origin.x = CGRectGetMidX(bounds) - CGRectGetMidX(labelFrame) + ActivityViewLabelCenterXOffset;
    labelFrame.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(labelFrame);
    self.label.frame = labelFrame;
    
    CGRect activityIndicatorFrame = self.activityIndicator.frame;
    activityIndicatorFrame.origin.x = CGRectGetMinX(labelFrame) - CGRectGetWidth(activityIndicatorFrame) - ActivityViewActivityIndicatorRightInset;
    activityIndicatorFrame.origin.y = CGRectGetMidY(labelFrame) - floorf(CGRectGetHeight(activityIndicatorFrame) / 2.0f);
    self.activityIndicator.frame = activityIndicatorFrame;
    
}

- (void)setLabel:(UILabel *)label {
    if (self.label != label) {
        [_label removeFromSuperview];
        _label = label;
        [self addSubview:_label];
        [self setNeedsLayout];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
