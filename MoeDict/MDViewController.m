//
//  MDViewController.m
//  MoeDict
//
//  Created by jamie on 2/12/13.
//  Copyright (c) 2013 jamie. All rights reserved.
//

#import "MDViewController.h"
#import "MDReferenceLibraryViewController.h"

@interface MDViewController () <UITextViewDelegate>

@end

@implementation MDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
 
}

#pragma mark -UITextViewDelegate

- (void)textViewDidChangeSelection:(UITextView *)textView {
  NSString *term = [textView.text substringWithRange:textView.selectedRange];
  
  if (!term.length) {
    return;
  }
  
  MDReferenceLibraryViewController *referenceLibraryViewController = [[MDReferenceLibraryViewController alloc] initWithTerm:term];
  [self
   presentViewController:referenceLibraryViewController
   animated:YES
   completion:^{
     // no op
   }];
}
@end
