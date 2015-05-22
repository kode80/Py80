//
//  KDEExceptionView.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/22/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEExceptionView.h"


@interface KDEExceptionView ()

@property (nonatomic, readwrite, strong) NSTextView *textView;
@property (nonatomic, readwrite, strong) NSLayoutConstraint * leftConstraint;
@property (nonatomic, readwrite, strong) NSLayoutConstraint * topConstraint;

@end


@implementation KDEExceptionView

- (void) addToTextView:(NSTextView *)textView
{
    self.textView = textView;
    NSView *documentView = textView.enclosingScrollView.documentView;
    NSDictionary *views = @{ @"v" : self };
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [documentView addSubview:self];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[v]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views];
    [documentView addConstraints:horizontalConstraints];
    [textView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:textView.superview
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0f
                                                                    constant:-10.0f]];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[v]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
    [documentView addConstraints:verticalConstraints];
    self.leftConstraint = horizontalConstraints[0];
    self.topConstraint = verticalConstraints[0];
}

- (void) updateConstraintsForCharacterRange:(NSRange)characterRange
{
    NSRange glyphRange = [self.textView.layoutManager glyphRangeForCharacterRange:characterRange
                                                             actualCharacterRange:NULL];
    NSRect lineRect = [self.textView.layoutManager boundingRectForGlyphRange:glyphRange
                                                             inTextContainer:self.textView.textContainer];
    [self.superview convertRect:lineRect
                       fromView:self.textView];
    
    self.leftConstraint.constant = lineRect.origin.x;
    self.topConstraint.constant = lineRect.origin.y + lineRect.size.height;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (void) layout
{
    [super layout];
    self.label.preferredMaxLayoutWidth = self.label.bounds.size.width;
}

@end
