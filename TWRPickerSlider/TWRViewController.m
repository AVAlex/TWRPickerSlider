//
//  TWRViewController.m
//  TWRPickerSlider
//
//  Created by Michelangelo Chasseur on 28/08/14.
//  Copyright (c) 2014 Touchware. All rights reserved.
//

#import "TWRViewController.h"
#import "TWRSliderStackedView.h"
#import "TWRPickerSlider.h"
#import "TWRDemoObject.h"

@interface TWRViewController () <TWRPickerSliderDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)resetButtonPressed:(UIButton *)sender;

@property (nonatomic, strong) TWRPickerSlider *slider1;

@end

@implementation TWRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.translucent = NO;
	// Do any additional setup after loading the view, typically from a nib.
    TWRDemoObject *obj1 = [[TWRDemoObject alloc] initWithTitle:@"Object 1"];
    TWRDemoObject *obj2 = [[TWRDemoObject alloc] initWithTitle:@"Object 2"];
    TWRDemoObject *obj3 = [[TWRDemoObject alloc] initWithTitle:@"Object 3"];
    
    // Picker Slider 1
    _slider1 = [[TWRPickerSlider alloc] init];
    
    // Colors
    _slider1.mainColor = [UIColor lightGrayColor];
    _slider1.secondaryColor = [UIColor whiteColor];
    
    // Objects for picker
    _slider1.pickerObjects = @[obj1, obj2, obj3];
    
    // Texts
    _slider1.leftText = @"Slider #1:";
    _slider1.rightText = @"Select";
    
    // Delegate
    _slider1.delegate = self;
    
    // Picker Slider 2
    TWRPickerSlider *slider2 = [[TWRPickerSlider alloc] init];
    
    // Colors
    slider2.mainColor = [UIColor grayColor];
    slider2.secondaryColor = [UIColor whiteColor];
    
    // Objects for picker
    slider2.pickerObjects = @[obj1, obj2, obj3];
    
    // Texts
    slider2.leftText = @"Slider #2:";
    slider2.rightText = @"Select";
    
    // Delegate
    slider2.delegate = self;

    
    // Picker Slider 1
    TWRPickerSlider *slider3 = [[TWRPickerSlider alloc] init];
    
    // Colors
    slider3.mainColor = [UIColor darkGrayColor];
    slider3.secondaryColor = [UIColor whiteColor];
    
    // Objects for picker
    slider3.pickerObjects = @[obj1, obj2, obj3];
    
    // Texts
    slider3.leftText = @"Slider #3:";
    slider3.rightText = @"Select";
    
    // Delegate
    slider3.delegate = self;
    
    
    TWRSliderStackedView *stack = [[TWRSliderStackedView alloc] initWithPosition:TWRPickerSliderPositionTop topPadding:20];
//    TWRSliderStackedView *stack = [[TWRSliderStackedView alloc] initWithTabBar];
    stack.type = TWRPickerSliderTypeDatePicker;
    stack.sliders = @[_slider1, slider2, slider3];
    [self.view addSubview:stack];
}

- (void)objectSelected:(id<TWRPickerSliderDatasource>)selectedObject sender:(TWRPickerSlider *)sender{
    NSLog(@"Selected object: %@", [selectedObject twr_pickerTitle]);
}

- (IBAction)resetButtonPressed:(UIButton *)sender {
    [_slider1 resetPicker];
}

@end
