//
//  TWRPickerSlider.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#define PICKER_DEFAULT_VISIBLE_HEIGHT 44

#import "TWRPickerSlider.h"
#import "TWRPickerSliderHeaderView.h"

@interface TWRPickerSlider () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) NSUInteger visibleHeight;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) TWRPickerSliderHeaderView *header;
@property (assign, nonatomic) BOOL open;
@property (strong, nonatomic) id<TWRPickerSliderDataDelegate> selectedObject;

@end

@implementation TWRPickerSlider

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame visibleHeight:PICKER_DEFAULT_VISIBLE_HEIGHT];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame visibleHeight:(NSUInteger)visibleHeight {
    self = [super initWithFrame:frame];
    if (self) {
        self.open = NO;
        self.visibleHeight = visibleHeight;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.backgroundColor = self.mainColor;
    self.frame = CGRectMake(CGRectGetMinX(newSuperview.frame), CGRectGetMaxY(newSuperview.frame) - self.visibleHeight, CGRectGetWidth(newSuperview.frame), CGRectGetHeight(self.frame));
    
    // Header
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TWRPickerSliderHeaderView class])
                                                      owner:self
                                                    options:nil];
    self.header = [nibViews objectAtIndex:0];
    self.header.leftLabel.text = self.leftText;
    self.header.rightLabel.text = self.rightText;
    self.header.leftLabel.textColor = self.secondaryColor;
    self.header.rightLabel.textColor = self.secondaryColor;
    
    UIImage *headerImage = [[UIImage imageNamed:@"input_icon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.header.imageView setImage:headerImage];
    self.header.imageView.tintColor = self.secondaryColor;
    [self addSubview:self.header];
    
    // Button
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(newSuperview.frame), self.visibleHeight)];
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    // Picker View
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.visibleHeight, CGRectGetWidth(newSuperview.frame), CGRectGetHeight(self.frame) - self.visibleHeight)];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.tintColor = self.secondaryColor;
    [self addSubview:self.picker];
}

- (void)buttonPressed:(id)sender {
    NSLog(@"Button pressed");

    switch (self.open) {
        case NO:
        {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.frame) + self.visibleHeight);
            } completion:^void(BOOL finished) {
                self.open = !self.open;
            }];
        }
            break;
            
        case YES:
        {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^void(BOOL finished) {
                self.open = !self.open;
                if ([self.delegate respondsToSelector:@selector(objectSelected:)]) {
                    [self.delegate objectSelected:self.selectedObject];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Picker View Datasource / Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerObjects.count + 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[self secondaryColor]}];
    } else {
        id<TWRPickerSliderDataDelegate>object = [self.pickerObjects objectAtIndex:row - 1];
        if ([[object class] conformsToProtocol:@protocol(TWRPickerSliderDataDelegate)]) {
            return [[NSAttributedString alloc] initWithString:[object pickerTitle] attributes:@{NSForegroundColorAttributeName:[self secondaryColor]}];
        } else {
            [[NSException exceptionWithName:@"TWRPickerSliderDataDelegateException" reason:@"Objects provided as the picker datasource should be conformant to TWRPickerSliderDataDelegate protocol!" userInfo:nil] raise];
        }
    }
    
    // fallback
    return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[self secondaryColor]}];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        return;
    }
    id<TWRPickerSliderDataDelegate>object = [self.pickerObjects objectAtIndex:row - 1];
    self.selectedObject = object;
    self.header.rightLabel.text = [object pickerTitle];
}

@end